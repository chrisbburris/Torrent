/*
 * README
 * 
 * The following code is for a video game called Torrent, 
 * which was made by a student team at The Guildhall of Southern Methodist University.
 * 
 * This code's purpose is for the portfolio website of Chris Burris, one of the students
 * who worked on the game.
 * 
 * You can visit Chris Burris' website at: chrisbburris.com
 * 
 */

class TTPlayerController extends UTPlayerController
	dependson( TTPawn )
	dependson( TTPlayerReplicationInfo )
	config(Game);

var TTFlagZone MyZone;

var float myFlagZoneALife;
var float myFlagZoneBLife;
var float myFlagZoneCLife;
var float oldFlagZoneALife;
var float oldFlagZoneBLife;
var float oldFlagZoneCLife;

var bool orangeCappingA;
var bool orangeDecappingA;
var bool cyanCappingA;
var bool cyanDecappingA;

var bool orangeCappingB;
var bool orangeDecappingB;
var bool cyanCappingB;
var bool cyanDecappingB;

var bool orangeCappingC;
var bool orangeDecappingC;
var bool cyanCappingC;
var bool cyanDecappingC;

enum CaptureSFX_State
{
	CaptureSFX_Off,
	CaptureSFX_Begin,
	CaptureSFX_Playing,
	CaptureSFX_Stop
};
var CaptureSFX_State Capture;

var AudioComponent CapturingSound;
var bool isCapping;


function Init()
{
	myFlagZoneALife = 0.0;
	myFlagZoneBLife = 0.0;
	myFlagZoneCLife = 0.0;
	oldFlagZoneALife = -1.0;
	oldFlagZoneBLife = -1.0;
	oldFlagZoneCLife = -1.0;

	orangeCappingA = false;
	orangeDecappingA = false;
	cyanCappingA = false;
	cyanDecappingA = false;

	orangeCappingB = false;
	orangeDecappingB = false;
	cyanCappingB= false;
	cyanDecappingB = false;

	orangeCappingC = false;
	orangeDecappingC = false;
	cyanCappingC = false;
	cyanDecappingC = false;
}


simulated function DrawHUD( HUD H )
{
	
	
	local TTHUDMoviePlayer moviePlayer;
	local TTGameReplicationInfo TTGameInfo;
	local TTPlayerReplicationInfo TTPlayerInfo;
	local float flagZoneMaxLife;
	

	moviePlayer = TTHUDMoviePlayer(TTHUD(H).HudMovie);
	TTGameInfo = TTGameReplicationInfo(WorldInfo.GRI);
	TTPlayerInfo = TTPlayerReplicationInfo(PlayerReplicationInfo);
	flagZoneMaxLife = TTMapInfo(WorldInfo.GetMapInfo()).FlagZoneHP;

	// force scoreboard on if dedicated server spectator
	if (bDedicatedServerSpectator && !H.bShowScores)
	{
		H.ShowScores();
	}

	if(TTPlayerInfo.Team.TeamIndex == 0)
	{
		moviePlayer.SetHudColor(moviePlayer.Orange);
		moviePlayer.ScaleAmmoBar(UTWeapon(UTPawn(Pawn).Weapon).GetAmmoCount(), UTWeapon(UTPawn(Pawn).Weapon));
	}

	if(TTPlayerInfo.Team.TeamIndex == 1)
	{
		moviePlayer.SetHudColor(moviePlayer.Cyan);
		moviePlayer.ScaleAmmoBar(UTWeapon(UTPawn(Pawn).Weapon).GetAmmoCount(), UTWeapon(UTPawn(Pawn).Weapon));
	}

	if ( TTGameInfo.GameMode == 0 )
	{
		if(TTPlayerInfo.ZoneInside != -1)
		{
			if(TTPlayerInfo.ZoneInside == 0 && TTPlayerInfo.ZoneInside != 1 && TTPlayerInfo.ZoneInside != 2)
			{
				DrawFlagZoneHacking(moviePlayer, TTGameInfo, TTPlayerInfo, flagZoneMaxLife, 0, myFlagZoneALife, oldFlagZoneALife);
			}
			else if(TTPlayerInfo.ZoneInside == 1 && TTPlayerInfo.ZoneInside != 0 && TTPlayerInfo.ZoneInside != 2)
			{
				DrawFlagZoneHacking(moviePlayer, TTGameInfo, TTPlayerInfo, flagZoneMaxLife, 1, myFlagZoneBLife, oldFlagZoneBLife);
			}

			else if(TTPlayerInfo.ZoneInside == 2 && TTPlayerInfo.ZoneInside != 0 && TTPlayerInfo.ZoneInside != 1)
			{
				DrawFlagZoneHacking(moviePlayer, TTGameInfo, TTPlayerInfo, flagZoneMaxLife, 2, myFlagZoneCLife, oldFlagZoneCLife);
			}
		}
		else if(TTPlayerInfo.ZoneInside == -1)
		{
			moviePlayer.HackingA.SetVisible(false);
			moviePlayer.HackingB.SetVisible(false);
			moviePlayer.HackingC.SetVisible(false);
			moviePlayer.UploadingTF.SetVisible(false);
			moviePlayer.HackNumber.SetVisible(false);
			moviePlayer.HackPerc.SetVisible(false);
			moviePlayer.HackBar.SetVisible(false);
		}

		DrawFlagZoneCapping(moviePlayer, TTGameInfo, TTPlayerInfo, flagZoneMaxLife, 0, myFlagZoneALife, oldFlagZoneALife);
		DrawFlagZoneCapping(moviePlayer, TTGameInfo, TTPlayerInfo, flagZoneMaxLife, 1, myFlagZoneBLife, oldFlagZoneBLife);
		DrawFlagZoneCapping(moviePlayer, TTGameInfo, TTPlayerInfo, flagZoneMaxLife, 2, myFlagZoneCLife, oldFlagZoneCLife);
	}
	else
	{
		// Disable node icons at top of hud
		moviePlayer.PointA.SetVisible( false );
		moviePlayer.PointB.SetVisible( false );
		moviePlayer.PointC.SetVisible( false );
	}

	if(TTPawn(Pawn) == none)
	{
		moviePlayer.SetHealthBar(0.0);
		moviePlayer.bHudColorSet = false;

		moviePlayer.HackingA.SetVisible(false);
		moviePlayer.HackingB.SetVisible(false);
		moviePlayer.HackingC.SetVisible(false);
		moviePlayer.UploadingTF.SetVisible(false);
		moviePlayer.hackNumber.SetVisible(false);
		moviePlayer.hackPerc.SetVisible(false);
		moviePlayer.hackBar.SetVisible(false);

		moviePlayer.NewPistolAmmoMax = moviePlayer.PistolAmmoMax;
		moviePlayer.NewRifleAmmoMax = moviePlayer.RifleAmmoMax;
		moviePlayer.NewShotgunAmmoMax = moviePlayer.ShotgunAmmoMax;
	}

	if( Pawn != None )
	{
		if( (UTWeapon(Pawn.Weapon) != None) )
		{
			UTWeapon(Pawn.Weapon).ActiveRenderOverlays(H);
		}

		if( TTPawn(Pawn).bBlinded )
		{
			H.Canvas.SetPos( 0.0f, 0.0f );
			H.Canvas.SetDrawColor( 255, 255, 255, TTPawn(Pawn).timeBlind );
			H.Canvas.DrawRect( H.Canvas.ClipX, H.Canvas.ClipY );
		}
	}
}


simulated function DrawFlagZoneHacking(TTHUDMoviePlayer moviePlayer,
	TTGameReplicationInfo TTGameInfo, TTPlayerReplicationInfo TTPlayerInfo,
	float flagZoneMaxLife, int flagZoneID, out float myFlagZoneLife, 
	out float oldFlagZoneLife)
{
	local float flagZoneCurrentLife;
	local GFxObject hackingText;
	local GFxObject hackPerc;
	local GFxObject hackBar;
	local GFxObject capBar;
	local GFxObject capPoint;
	local GFxObject flagLetter;
	local GFxObject hackNumber;
	local int percentage;

	flagZoneCurrentLife = TTGameInfo.ZoneCurrentHP[flagZoneID];
	
	hackingText = moviePlayer.UploadingTF;
	hackPerc = moviePlayer.HackPerc;
	hackBar = moviePlayer.HackBar;
	hackNumber = moviePlayer.HackNumber;

	if(flagZoneID == 0)
	{
		capBar = moviePlayer.CapBarA;
		capPoint = moviePlayer.PointA;
		flagLetter = moviePlayer.HackingA;
	}
	else if(flagZoneID == 1)
	{
		capBar = moviePlayer.CapBarB;
		capPoint = moviePlayer.PointB;
		flagLetter = moviePlayer.HackingB;
	}
	else if(flagZoneID == 2)
	{
		capBar = moviePlayer.CapBarC;
		capPoint = moviePlayer.PointC;
		flagLetter = moviePlayer.HackingC;
	}

	if(flagZoneCurrentLife > 0.0 && flagZoneCurrentLife < flagZoneMaxLife)
	{   
		flagLetter.SetVisible(true);
		hackingText.SetVisible(true);
		hackNumber.SetVisible(true);
		hackPerc.SetVisible(true);
		hackBar.SetVisible(true);

		capBar.SetVisible(true);
		moviePlayer.ChangeColorMC(capPoint, moviePlayer.White);
		moviePlayer.ChangeColorMC(flagLetter, moviePlayer.White);

		if(TTPlayerInfo.Team.TeamIndex == 0)
		{
			if ( TTGameInfo.ZoneIsBlue(flagZoneID) ||
				TTGameInfo.ZonePartialBlue(flagZoneID) )
			{
				hackingText.SetText("Hacking.....");
				moviePlayer.ChangeColorMC(capBar, moviePlayer.Cyan);
				moviePlayer.ChangeColorMC(hackBar, moviePlayer.Cyan);
				moviePlayer.ChangeColorTF(hackNumber, moviePlayer.Cyan);
				moviePlayer.ChangeColorTF(hackPerc, moviePlayer.Cyan);
			}
			else if ( TTGameInfo.ZoneIsRed(flagZoneID) ||
				TTGameInfo.ZonePartialRed(flagZoneID) )
			{
				hackingText.SetText("Uploading...");
				moviePlayer.ChangeColorMC(capBar, moviePlayer.Orange);
				moviePlayer.ChangeColorMC(hackBar, moviePlayer.Orange);
				moviePlayer.ChangeColorTF(hackNumber, moviePlayer.Orange);
				moviePlayer.ChangeColorTF(hackPerc, moviePlayer.Orange);
			}
		}
		else if(TTPlayerInfo.Team.TeamIndex == 1)
		{
			if ( TTGameInfo.ZoneIsRed(flagZoneID) ||
				TTGameInfo.ZonePartialRed(flagZoneID) )
			{
				hackingText.SetText("Hacking.....");
				moviePlayer.ChangeColorMC(capBar, moviePlayer.Orange);
				moviePlayer.ChangeColorMC(hackBar, moviePlayer.Orange);
				moviePlayer.ChangeColorTF(hackNumber, moviePlayer.Orange);
				moviePlayer.ChangeColorTF(hackPerc, moviePlayer.Orange);
			}
			else if ( TTGameInfo.ZoneIsBlue(flagZoneID) ||
				TTGameInfo.ZonePartialBlue(flagZoneID) )
			{
				hackingText.SetText("Uploading...");
				moviePlayer.ChangeColorMC(capBar, moviePlayer.Cyan);
				moviePlayer.ChangeColorMC(hackBar, moviePlayer.Cyan);
				moviePlayer.ChangeColorTF(hackNumber, moviePlayer.Cyan);
				moviePlayer.ChangeColorTF(hackPerc, moviePlayer.Cyan);
			}
		}
		
		percentage = int(moviePlayer.ScaleCapBar(hackBar, flagZoneMaxLife, flagZoneCurrentLife));

		hackNumber.SetText(percentage+1);
	}
	else if(flagZoneCurrentLife <= 0.0 || flagZoneCurrentLife >= flagZoneMaxLife)
	{
		if ( Capture == CaptureSFX_Playing )
			Capture = CaptureSFX_Stop;
		
		flagLetter.SetVisible(false);
		hackingText.SetVisible(false);
		hackNumber.SetVisible(false);
		hackPerc.SetVisible(false);
		hackBar.SetVisible(false);
		capBar.SetVisible(false);
	}

	oldFlagZoneLife = flagZoneCurrentLife;
}


simulated function DrawFlagZoneCapping(TTHUDMoviePlayer moviePlayer,
	TTGameReplicationInfo TTGameInfo, TTPlayerReplicationInfo TTPlayerInfo,
	float flagZoneMaxLife, int flagZoneID, out float myFlagZoneLife,
	out float oldFlagZoneLife)
{
	local float flagZoneCurrentLife;
	local GFxObject capBar;
	local GFxObject capPoint;

	flagZoneCurrentLife = TTGameInfo.ZoneCurrentHP[flagZoneID];

	if(flagZoneID == 0)
	{
		capBar = moviePlayer.CapBarA;
		capPoint = moviePlayer.PointA;
	}
	else if(flagZoneID == 1)
	{
		capBar = moviePlayer.CapBarB;
		capPoint = moviePlayer.PointB;
	}
	else if(flagZoneID == 2)
	{
		capBar = moviePlayer.CapBarC;
		capPoint = moviePlayer.PointC;
	}

	capBar.SetVisible(true);

	if ( TTGameInfo.ZonePartialBlue( flagZoneID ) )
	{
		moviePlayer.ChangeColorMC(capBar, moviePlayer.Cyan);
	}

    if ( TTGameInfo.ZonePartialRed( flagZoneID ) )
	{
		moviePlayer.ChangeColorMC(capBar, moviePlayer.Orange);
	}

	if(TTGameInfo.ZoneIsRed(flagZoneID) && flagZoneCurrentLife == flagZoneMaxLife)
	{
		moviePlayer.ChangeColorMC(capPoint, moviePlayer.Orange);
		capBar.SetVisible(false);
	}
	if(TTGameInfo.ZoneIsBlue(flagZoneID) && flagZoneCurrentLife == flagZoneMaxLife)
	{
		moviePlayer.ChangeColorMC(capPoint, moviePlayer.Cyan);
		capBar.SetVisible(false);
	}
	
	if(TTGameInfo.ZoneIsNeutral(flagZoneID))
	{
		moviePlayer.ChangeColorMC(capPoint, moviePlayer.White);
	}

	if(flagZoneCurrentLife != flagZoneMaxLife)
	{
		moviePlayer.ChangeColorMC(capPoint, moviePlayer.White);
	}

	moviePlayer.ScaleCapBar(capBar, flagZoneMaxLife, flagZoneCurrentLife);

	oldFlagZoneLife = flagZoneCurrentLife;
}


unreliable client function ClientPlayTakeHit(vector HitLoc, byte Damage, class<DamageType> DamageType)
{
	DamageShake(Damage, DamageType);

	if ( MyHUD != None )
		TTHUDMoviePlayer(TTHUD(MyHud).HudMovie).DisplayHit(HitLoc, Damage, DamageType);
}


simulated function flagZoneLifeLerp(out float myFlagZoneLife, float realFlagZoneLife)
{
	if (myFlagZoneLife != realFlagZoneLife)
	{
		if(realFlagZoneLife > myFlagZoneLife) myFlagZoneLife = Lerp(myFlagZoneLife, realFlagZoneLife, 0.01);

		else if(realFlagZoneLife < myFlagZoneLife) myFlagZoneLife = Lerp(myFlagZoneLife, realFlagZoneLife, 0.01);
	}

	if(myFlagZoneLife > realFlagZoneLife * 0.99) myFlagZoneLife = realFlagZoneLife;

	if(myFlagZoneLife < realFlagZoneLife * 0.01) myFlagZoneLife = realFlagZoneLife;
}


//Stop sound from playing
unreliable client event ClientStopSound(SoundCue ASound)
{
	ClientHearSound(none, self, Location, false, false);
}


reliable client function PlayStartupMessage(byte StartupStage)
{
	if ( StartupStage == 7 )
	{
		ReceiveLocalizedMessage( class'UTTimerMessage', 17, PlayerReplicationInfo );
	}
	else
	{
		ReceiveLocalizedMessage( class'TTStartupMessage', StartupStage, PlayerReplicationInfo );
	}
}


defaultproperties
{
	MinRespawnDelay=1.5
}
