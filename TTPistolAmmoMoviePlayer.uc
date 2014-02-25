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

class TTPistolAmmoMoviePlayer extends GFxMoviePlayer;

var GFxObject AmmoCount, EMP;

var int Cyan;
var int Orange;
var int Red;


simulated function Init(optional LocalPlayer player)
{
	//Colors
	Cyan = 0x19ffff;
	Orange = 0xffa800;
	Red = 0xff0000;

	EMP.SetVisible(false);

	SetTimingMode(TM_Game);
	Start();
}


simulated function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0);

	AmmoCount = GetVariableObject("_root.ammoDisplay");
	EMP = GetVariableObject("_root.emp");

	return true;
}


function SetAmmoText()
{
    local int ammo;
	local TTPlayerReplicationInfo TTPlayerInfo;

	if(GetPC() != none && GetLP() != none)
	{
		ammo = UTWeapon(UTPawn(GetPC().Pawn).Weapon).GetAmmoCount();
		TTPlayerInfo = TTPlayerReplicationInfo(GetPC().PlayerReplicationInfo);

		AmmoCount.SetString("text", ""$ammo);

		if(ammo <= 100/4)
		{
			ChangeColorTF(AmmoCount, Red);
			EMP.SetVisible(true);
			ChangeColorMC(EMP, Red);
		}
		else
		{
			if(TTPlayerInfo.Team.TeamIndex == 0)
			{
				ChangeColorTF(AmmoCount, Orange);
				EMP.SetVisible(true);
				ChangeColorMC(EMP, Orange);
			}
			else if(TTPlayerInfo.Team.TeamIndex == 1)
			{
				ChangeColorTF(AmmoCount, Cyan);
				EMP.SetVisible(true);
				ChangeColorMC(EMP, Cyan);
			}
		}
	}

	SetEMP();
}


function SetEMP()
{
	local TTWeap_EMPPistol pistol;

	if(GetPC() != none && GetLP() != none)
	{
		pistol = TTWeap_EMPPistol(UTPawn(GetPC().Pawn).Weapon);

		if(pistol.InventoryGroup == 1)
		{
			if(pistol.bEMPReady) EMP.GotoAndStopI(1);
			else EMP.GotoAndStopI(2);
		}
	}
}


function ChangeColorMC(GFxObject obj, int newColor)
{
	ActionScriptVoid("_root.ChangeColorMC");
}


function ChangeColorTF(GFxObject obj, int newColor)
{
	ActionScriptVoid("_root.ChangeColorTF");
}


DefaultProperties
{
	MovieInfo = SwfMovie 'TT_Weapons.TorrentPistolAmmoDisplay'
	bEnableGammaCorrection = false;
	RenderTextureMode = RTM_AlphaComposite
}
