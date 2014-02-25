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

class TTRifleAmmoMoviePlayer extends GFxMoviePlayer;

var GFxObject AmmoCount, Loadout;

var int Cyan;
var int Orange;
var int Red;


simulated function Init(optional LocalPlayer player)
{
	//Colors
	Cyan = 0x19ffff;
	Orange = 0xffa800;
	Red = 0xff0000;

	SetTimingMode(TM_Game);
	Start();
}


simulated function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0);

	AmmoCount = GetVariableObject("_root.ammoDisplay");
	Loadout = GetVariableObject("_root.loadout");

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

		if(ammo <= 120/4)
		{
			ChangeColorTF(AmmoCount, Red);
			Loadout.SetVisible(true);
			ChangeColorMC(Loadout, Red);
		}
		else
		{
			if(TTPlayerInfo.Team.TeamIndex == 0)
			{
				ChangeColorTF(AmmoCount, Orange);
				Loadout.SetVisible(true);
				ChangeColorMC(Loadout, Orange);
			}
			else if(TTPlayerInfo.Team.TeamIndex == 1)
			{
				ChangeColorTF(AmmoCount, Cyan);
				Loadout.SetVisible(true);
				ChangeColorMC(Loadout, Cyan);
			}
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
	MovieInfo = SwfMovie 'TT_Weapons.TorrentRifleAmmoDisplay'
	bEnableGammaCorrection = false;
	RenderTextureMode = RTM_AlphaComposite
}
