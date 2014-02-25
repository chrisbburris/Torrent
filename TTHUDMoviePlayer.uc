/*
 * README
 * 
 * The following code is for a video game called Torrent, 
 * which was made by a student team at The Guildhall of Southern Methodist University.
 * 
 * This code's purpose is for the portfolio website of Chris Burris, one of the students
 * who worked on the game.
 * 
 * This was originally the defualt HUD code in UDK. Chris Burris modified this code to
 * have it work for Torrent. There are comments below that specify which parts of the 
 * code were written by Chris Burris.
 * 
 * You can visit Chris Burris' website at: chrisbburris.com
 * 
 */

class TTHUDMoviePlayer extends UTGFxTeamHUD;

var GFxObject     HealthTextTF, HealthPercTF, AmmoTextTF;

var GFxObject       CrosshareRifle, 
					CrosshareShotgun,
					CrosshareRing,
					Crosshare,
					LoadoutPistol, 
					LoadoutRifle, 
					LoadoutShotgun, 
					HealthBar,
					HUDTop, 
					PistolAmmo, 
					RifleAmmo, 
					ShotgunAmmo,
					AmmoBarBackground,
					PistolAmmoBackground, 
					RifleAmmoBackground, 
					ShotgunAmmoBackground,
					HackCompleteMC,
					HackCompleteTF,
					DamageTop,
					DamageBottom,
					DamageRight,
					DamageLeft;
					

var repnotify GFxObject     PointA,
							PointB,
							PointC,
							CapBarA,
							CapBarB,
							CapBarC,
							HackingA,
							HackingB,
							HackingC,
							HackNumber,
							UploadingTF,
							HackPerc,
							HackBar;


var bool bHudColorSet;

// Colors
var int Cyan;
var int Orange;
var int Yellow;
var int Red;
var int Green;
var int White;
var int HudColor;

//Teams
var int OrangeTeam;
var int CyanTeam;

// Points
var int A;
var int B;
var int C;

// Point State
var int CyanState;
var int OrangeState;
var int NeutralState;

var int PistolAmmoMax;
var int RifleAmmoMax;
var int ShotgunAmmoMax;
var int NewPistolAmmoMax;
var int NewRifleAmmoMax;
var int NewShotgunAmmoMax;

var MaterialInstanceConstant pistolAmmoMat;
var MaterialInstanceConstant rifleAmmoMat;
var MaterialInstanceConstant shotgunAmmoMat;

var LinearColor AmmoColor;
var LinearColor OrangeAmmoColor;
var LinearColor CyanAmmoColor;
var LinearColor RedAmmoColor;


/*
 * Callback fired from Flash when Minimap is loaded.
 *   "ExternalInterface.call("RegisterMinimapView", this)";
 *   
 * Used to pass a reference to the MovieClip which is loaded
 * from Flash back to UnrealScript.
 */
function registerMiniMapView(GFxMinimap mc, float r)
{
    /*Minimap = mc;
	Radius = r;
	CurZoomf = 64;
	NormalZoomf = 64;
	if (Minimap != none)
	{
		Minimap.Init(self);
		Minimap.SetVisible(false);
		Minimap.SetFloat("_xscale", 85);
		Minimap.SetFloat("_yscale", 85);
	}*/
}


function UpdateGameHUD(UTPlayerReplicationInfo PRI)
{

	local int j, CurScores[2];

	CurScores[0] = GRI.Teams[0].Score;
	CurScores[1] = GRI.Teams[1].Score;

	for (j = 0; j < 2; j++)
	{
		if (LastScore[j] != CurScores[j])
		{
			LastScore[j] = CurScores[j];
			if (CurScores[j] > -100000)
				ScoreTF[j].SetText(CurScores[j]);
			else
				ScoreTF[j].SetText("");
		}
	}
}


// Written by Chris Burris
function ChangeColorMC(GFxObject obj, int newColor)
{
	ActionScriptVoid("_root.playerStats.ChangeColorMC");
}


// Written by Chris Burris
function ChangeColorTF(GFxObject obj, int newColor)
{
	ActionScriptVoid("_root.playerStats.ChangeColorTF");
}


// Written by Chris Burris
function SetHudColor(int newColor)
{
	HudColor = newColor;

	ChangeColorMC(ReticuleMC, HudColor);
	ChangeColorMC(CrosshareRifle, HudColor);
	ChangeColorMC(CrosshareShotgun, HudColor);
	ChangeColorMC(CrosshareRing, HudColor);
	ChangeColorMC(Crosshare, HudColor);
	ChangeColorMC(LoadoutPistol, HudColor);
	ChangeColorMC(LoadoutRifle, HudColor);
	ChangeColorMC(LoadoutShotgun, HudColor);
	ChangeColorMC(HUDTop, HudColor);
	ChangeColorMC(RifleAmmo, HudColor);
	ChangeColorMC(ShotgunAmmo, HudColor);
	ChangeColorMC(PistolAmmo, HudColor);
	ChangeColorMC(RifleAmmoBackground, HudColor);
	ChangeColorMC(ShotgunAmmoBackground, HudColor);
	ChangeColorMC(PistolAmmoBackground, HudColor);

	ChangeColorTF(HealthTF, White);
	ChangeColorTF(HealthTextTF, White);
	ChangeColorTF(HealthPercTF, White);

	HUDTop.SetVisible(true);
	if(newColor == Cyan)
	{
		HUDTop.GotoAndStopI(1);
		AmmoColor = CyanAmmoColor;
	}
	else
	{
		HUDTop.GotoAndStopI(2);
		AmmoColor = OrangeAmmoColor;
	}

	bHudColorSet = true;
}


// Written by Chris Burris
function SwitchCrosshare(UTWeapon weapon)
{	
	if(weapon.InventoryGroup == 1)
	{
		ReticuleMC.SetVisible(true);
		CrosshareRifle.SetVisible(false);
		CrosshareShotgun.SetVisible(false);
		CrosshareRing.SetVisible(true);
		Crosshare.SetVisible(true);
	}
    else if(weapon.InventoryGroup == 2)
	{
		ReticuleMC.SetVisible(false);
		CrosshareRifle.SetVisible(true);
		CrosshareShotgun.SetVisible(false);
		CrosshareRing.SetVisible(true);
		Crosshare.SetVisible(true);
	}
	else if(weapon.InventoryGroup == 3)
	{
		ReticuleMC.SetVisible(false);
		CrosshareRifle.SetVisible(false);
		CrosshareShotgun.SetVisible(true);
		CrosshareRing.SetVisible(true);
		Crosshare.SetVisible(true);
	}
}


// Written by Chris Burris
function SwitchLoadout(UTWeapon weapon)
{
	LoadoutPistol.SetVisible(true);
	LoadoutRifle.SetVisible(true);
	LoadoutShotgun.SetVisible(true);

	if(weapon.InventoryGroup == 1)
	{
		LoadoutPistol.GotoAndStopI(1);
		LoadoutRifle.GotoAndStopI(2);
		LoadoutShotgun.GotoAndStopI(2);
	}
    else if(weapon.InventoryGroup == 2)
	{
		LoadoutPistol.GotoAndStopI(2);
		LoadoutRifle.GotoAndStopI(1);
		LoadoutShotgun.GotoAndStopI(2);
	}
	else if(weapon.InventoryGroup == 3)
	{
		LoadoutPistol.GotoAndStopI(2);
		LoadoutRifle.GotoAndStopI(2);
		LoadoutShotgun.GotoAndStopI(1);
	}
}


// Written by Chris Burris
function SetHealthBar(float health)
{   
	HealthBar.SetVisible(true);
	HealthTF.SetVisible(true);

	if(health == 100.0)
	{
		ChangeColorMC(HealthBar, Green);
		HealthBar.GotoAndStopI(1);
	}
	else if(health < 100.0 && health >= 95.0)
	{
		HealthBar.GotoAndStopI(2);
	}
	else if(health < 95.0 && health >= 90.0)
	{
		HealthBar.GotoAndStopI(3);
	}
	else if(health < 90.0 && health >= 85.0)
	{
		HealthBar.GotoAndStopI(4);
	}
	else if(health < 85.0 && health >= 80.0)
	{
		HealthBar.GotoAndStopI(5);
	}
	else if(health < 80.0 && health >= 75.0)
	{
		HealthBar.GotoAndStopI(6);
	}
	else if(health < 75.0 && health >= 70.0)
	{
		HealthBar.GotoAndStopI(7);
	}
	else if(health < 70.0 && health >= 65.0)
	{
		ChangeColorMC(HealthBar, Green);
		HealthBar.GotoAndStopI(8);
	}
	else if(health < 65.0 && health >= 60.0)
	{
		ChangeColorMC(HealthBar, Yellow);
		HealthBar.GotoAndStopI(9);
	}
	else if(health < 60.0 && health >= 55.0)
	{
		ChangeColorMC(HealthBar, Yellow);
		HealthBar.GotoAndStopI(10);
	}
	else if(health < 55.0 && health >= 50.0)
	{
		ChangeColorMC(HealthBar, Yellow);
		HealthBar.GotoAndStopI(11);
	}
	else if(health < 50.0 && health >= 45.0)
	{
		ChangeColorMC(HealthBar, Yellow);
		HealthBar.GotoAndStopI(12);
	}
	else if(health < 45.0 && health >= 40.0)
	{
		ChangeColorMC(HealthBar, Yellow);
		HealthBar.GotoAndStopI(13);
	}
	else if(health < 40.0 && health >= 35.0)
	{
		ChangeColorMC(HealthBar, Yellow);
		HealthBar.GotoAndStopI(14);
	}
	else if(health < 35.0 && health >= 30.0)
	{
		ChangeColorMC(HealthBar, Yellow);
		HealthBar.GotoAndStopI(15);
	}
	else if(health < 30.0 && health >= 25.0)
	{
		ChangeColorMC(HealthBar, Red);
		HealthBar.GotoAndStopI(16);
	}
	else if(health < 25.0 && health >= 20.0)
	{
		ChangeColorMC(HealthBar, Red);
		HealthBar.GotoAndStopI(17);
	}
	else if(health < 20.0 && health >= 15.0)
	{
		ChangeColorMC(HealthBar, Red);
		HealthBar.GotoAndStopI(18);
	}
	else if(health < 15.0 && health >= 10.0)
	{
		ChangeColorMC(HealthBar, Red);
		HealthBar.GotoAndStopI(19);
	}
	else if(health < 10.0 && health >= 5.0)
	{
		ChangeColorMC(HealthBar, Red);
		HealthBar.GotoAndStopI(20);
	}
	else if(health < 5.0 && health >= 1.0)
	{
		ChangeColorMC(HealthBar, Red);
		HealthBar.GotoAndStopI(21);
	}
	else if(health <= 0.0)
	{
		ChangeColorMC(HealthBar, Red);
		HealthBar.GotoAndStopI(21);
	}
}


// Written by Chris Burris
function SetLoadoutAmmo(UTWeapon weapon, int ammo)
{
	if(weapon.InventoryGroup == 1)
	{
		if (ammo > 30)
				ammo = 30;
		PistolAmmo.GotoAndStopI(31 - ammo);

		if(ammo >= 16)
		{
			ChangeColorMC(PistolAmmo, HudColor);
		}
		else if(ammo <= 5)
		{
			ChangeColorMC(PistolAmmo, Red);
		}
	}
    else if(weapon.InventoryGroup == 2)
	{
		if (ammo > 30)
				ammo = 30;
		RifleAmmo.GotoAndStopI(31 - ammo);

		if(ammo >= 16)
		{
			ChangeColorMC(RifleAmmo, HudColor);
		}
		else if(ammo <= 5)
		{
			ChangeColorMC(RifleAmmo, Red);
		}
	}
	else if(weapon.InventoryGroup == 3)
	{
		if (ammo > 30)
				ammo = 30;
		ShotgunAmmo.GotoAndStopI(31 - ammo);

		if(ammo >= 16)
		{
			ChangeColorMC(ShotgunAmmo, HudColor);
		}
		else if(ammo <= 5)
		{
			ChangeColorMC(ShotgunAmmo, Red);
		}
	}
}


// Written by Chris Burris
function float ScaleCapBar(GFxObject capBar, float maxLife, float currentLife)
{
	local GFxObject.ASDisplayInfo DI;

	DI.hasYScale = true;

	DI.YScale = (100.0 * currentLife) / maxLife;

	if (DI.YScale <= 0)
	{
		DI.YScale = 0;
	}

	capBar.SetDisplayInfo(DI);

	return DI.YScale;
}


// Written by Chris Burris
function ScaleAmmoBar(int ammo, UTWeapon weapon)
{
	local GFxObject.ASDisplayInfo DI;

	DI.hasXScale = true;

	if(weapon.InventoryGroup == 1)
	{
		if(ammo > NewPistolAmmoMax)
		{
			NewPistolAmmoMax = ammo;
			DI.XScale = (100.0 * ammo) / NewPistolAmmoMax;
		}
		else DI.XScale = (100.0 * ammo) / NewPistolAmmoMax;
		
		if(ammo > (NewPistolAmmoMax/4))
		{
			ChangeColorMC(PistolAmmo, HudColor);
			ChangeColorMC(PistolAmmoBackground, HudColor);
		}
		else if(ammo <= (NewPistolAmmoMax/4))
		{
			ChangeColorMC(PistolAmmo, Red);
			ChangeColorMC(PistolAmmoBackground, Red);
		}

		PistolAmmo.SetDisplayInfo(DI);
	}
	else if(weapon.InventoryGroup == 2)
	{
		if(ammo > NewRifleAmmoMax)
		{
			NewRifleAmmoMax = ammo;
			DI.XScale = (100.0 * ammo) / NewRifleAmmoMax;
		}
		else DI.XScale = (100.0 * ammo) / NewRifleAmmoMax;

		if(ammo > (NewRifleAmmoMax/4))
		{
			ChangeColorMC(RifleAmmo, HudColor);
			ChangeColorMC(RifleAmmoBackground, HudColor);
		}
		else if(ammo <= (NewRifleAmmoMax/4))
		{
			ChangeColorMC(RifleAmmo, Red);
			ChangeColorMC(RifleAmmoBackground, Red);
		}

		RifleAmmo.SetDisplayInfo(DI);
	}
	else if (weapon.InventoryGroup == 3)
	{
		if(ammo > NewShotgunAmmoMax)
		{
			NewShotgunAmmoMax = ammo;
			DI.XScale = (100.0 * ammo) / NewShotgunAmmoMax;
		}
		else DI.XScale = (100.0 * ammo) / NewShotgunAmmoMax;

		if(ammo > (NewShotgunAmmoMax/4))
		{
			ChangeColorMC(ShotgunAmmo, HudColor);
			ChangeColorMC(ShotgunAmmoBackground, HudColor);
		}
		else if(ammo <= (NewShotgunAmmoMax/4))
		{
			ChangeColorMC(ShotgunAmmo, Red);
			ChangeColorMC(ShotgunAmmoBackground, Red);
		}

		ShotgunAmmo.SetDisplayInfo(DI);
	}

	if (DI.XScale <= 0)
	{
		DI.XScale = 0;
	}
}


// Written by Chris Burris
function SetHackCompleteText(string text)
{
	HackCompleteMC.SetVisible(true);
	HackCompleteTF.SetText(text);
	HackCompleteMC.GotoAndPlay("on");
}


/*
 * Creates a new LogMessage MovieClip for use in the 
 * log.
 */
function GFxObject CreateMessageRow()
{
	return LogMC.AttachMovie("LogMessage", "logMessage"$NumMessages++);
}


/*
 * Initalizes a new MessageRow and adds it to the list
 * of available log MessageRow MovieClips for reuse.
 */
function GFxObject InitMessageRow()
{
	local MessageRow mrow;

	mrow.Y = 0;
	mrow.MC = CreateMessageRow();

	mrow.TF = mrow.MC.GetObject("message").GetObject("textField");
	mrow.TF.SetBool("html", true);
	mrow.TF.SetString("htmlText", "");

	FreeMessages.AddItem(mrow);
	return mrow.MC;
}


// Written by Chris Burris
function Init(optional LocalPlayer player)
{
	local int j;
	local GFxObject TempWidget;

	super.Init(player);

	ThisWorld = GetPC().WorldInfo;
	GRI = UTGameReplicationInfo(GetPC().WorldInfo.GRI);

    Start();
    Advance(0);

    NumMessages = 0;
	LastHealth = -110;
	LastArmor = -110;
	LastAmmoCount = -110;
	LastScore[0] = -110;
	LastScore[1] = -110;

	bHudColorSet = false;

	//Colors
	Cyan = 0x19ffff;
	Orange = 0xffa800;
	Yellow = 0xffff00;
	Red = 0xff0000;
	Green = 0x00FF00;
	White = 0xffffff;
	HudColor = 0xffffff;

	//Teams
	OrangeTeam = 0;
	CyanTeam = 1;

	// Points
	A = 0;
	B = 1;
	C = 2;

	// Point States
	OrangeState = 0;
	CyanState = 1;
	NeutralState = 2;

	PistolAmmoMax = 100;
	RifleAmmoMax = 120;
	ShotgunAmmoMax = 24;
	NewPistolAmmoMax = PistolAmmoMax;
	NewRifleAmmoMax = RifleAmmoMax;
	NewShotgunAmmoMax = ShotgunAmmoMax;

	pistolAmmoMat = MaterialInstanceConstant 'TT_Weapons.pistolAmmoDisplay_mat_inst';

	OrangeAmmoColor = MakeLinearColor(1, 0.4, 0, 1);
	CyanAmmoColor =  MakeLinearColor(0, 1, 1, 1);
	RedAmmoColor = MakeLinearColor(1, 0, 0, 1);

	TempWidget = GetVariableObject("_root.expBar"); 
	if ( TempWidget != None ) 
	{ 
		TempWidget.SetBool("_visible", false);
	}

    TempWidget = GetVariableObject("_root.rank"); 
	if ( TempWidget != None ) 
	{
		TempWidget.SetBool("_visible", false);
	}

    TempWidget = GetVariableObject("_root.billboard"); 
	if ( TempWidget != None ) 
	{
		TempWidget.SetBool("_visible", false);
	}

	TempWidget = GetVariableObject("_root.title"); 
	if ( TempWidget != None ) 
	{
		TempWidget.SetBool("_visible", false);
	}
    TempWidget = GetVariableObject("_root.stats"); 
	if ( TempWidget != None ) 
	{
		TempWidget.SetBool("_visible", false);
	}

    TempWidget = GetVariableObject("_root.flag"); 
	if ( TempWidget != None ) 
	{
		TempWidget.SetVisible(false);
	}

	TempWidget = GetVariableObject("_root.teamStats.redWinning"); 
	if ( TempWidget != None ) 
	{
		TempWidget.SetVisible(false);
	}

	TempWidget = GetVariableObject("_root.teamStats.blueWinning"); 
	if ( TempWidget != None ) 
	{
		TempWidget.SetVisible(false);
	}

    LogMC = GetVariableObject("_root.log");
    for (j = 0; j < 15; j++)
		InitMessageRow();

    TeamStatsMC = GetVariableObject("_root.teamStats");
    PlayerStatsMC = GetVariableObject("_root.playerStats");
    PlayerStatsMC.GotoAndStopI(3);
    PlayerStatsMC.GotoAndStopI(2);
    HealthTF = GetVariableObject("_root.playerStats.HealthNumber");
	HealthTextTF = GetVariableObject("_root.playerStats.HealthText");
	HealthPercTF = GetVariableObject("_root.playerStats.HealthPerc");
    HealthBarMC = GetVariableObject("_root.playerStats.HealthCyan");
	PistolAmmoBackground = GetVariableObject("_root.playerStats.PistolAmmo.ammoBackground");
	RifleAmmoBackground = GetVariableObject("_root.playerStats.RifleAmmo.ammoBackground");
	ShotgunAmmoBackground = GetVariableObject("_root.playerStats.ShotgunAmmo.ammoBackground");
	AmmoTextTF = GetVariableObject("_root.playerStats.AmmoText");
    MaxAmmoMC = GetVariableObject("_root.playerStats.ammo.ammoBG");
	
    PointA = GetVariableObject("_root.teamStats.PointA");
    PointB = GetVariableObject("_root.teamStats.PointB");
    PointC = GetVariableObject("_root.teamStats.PointC");
    CrosshareRifle = GetVariableObject("_root.Crosshares.CrosshareRifle");
    CrosshareShotgun = GetVariableObject("_root.Crosshares.CrosshareShotgun");
	CrosshareRing = GetVariableObject("_root.Crosshares.CrosshareRing");
	Crosshare = GetVariableObject("_root.Crosshares.Crosshare");
    LoadoutPistol = GetVariableObject("_root.playerStats.LoadoutPistol"); 
    LoadoutRifle = GetVariableObject("_root.playerStats.LoadoutRifle"); 
    LoadoutShotgun = GetVariableObject("_root.playerStats.LoadoutShotgun"); 
    HealthBar = GetVariableObject("_root.playerStats.NewHealthBar");
    HUDTop = GetVariableObject("_root.teamStats.HUDTop");
	PistolAmmo = GetVariableObject("_root.playerStats.PistolAmmo.ammoBar");
	RifleAmmo = GetVariableObject("_root.playerStats.RifleAmmo.ammoBar");
	ShotgunAmmo = GetVariableObject("_root.playerStats.ShotgunAmmo.ammoBar");
	CapBarA = GetVariableObject("_root.teamStats.CapBarA");
	CapBarB = GetVariableObject("_root.teamStats.CapBarB");
	CapBarC = GetVariableObject("_root.teamStats.CapBarC");
	HackingA = GetVariableObject("_root.teamStats.HackingA");
	HackingB = GetVariableObject("_root.teamStats.HackingB");
	HackingC = GetVariableObject("_root.teamStats.HackingC");
	UploadingTF = GetVariableObject("_root.teamStats.UploadingText");
	HackNumber = GetVariableObject("_root.teamStats.HackNumber");
	HackPerc = GetVariableObject("_root.teamStats.HackPerc");
	HackBar = GetVariableObject("_root.teamStats.HackBar");

	DamageTop = GetVariableObject("_root.damageTop");
	DamageBottom = GetVariableObject("_root.damageBottom");
	DamageRight = GetVariableObject("_root.damageRight");
	DamageLeft = GetVariableObject("_root.damageLeft");

	CenterTextTF = GetVariableObject("_root.centerTextMC.centerText.textField");
	CenterTextMC = GetVariableObject("_root.centerTextMC");

	HackCompleteTF = GetVariableObject("_root.teamStats.HackCompleteText.LeftText.textField");
	HackCompleteMC = GetVariableObject("_root.teamStats.HackCompleteText");

    ReticuleMC = GetVariableObject("_root.Crosshares.CrossharePistol");

	HealthTF.SetVisible(false);
	CrosshareRifle.SetVisible(false);
	CrosshareShotgun.SetVisible(false);
	CrosshareRing.SetVisible(false);
	Crosshare.SetVisible(false);
	ReticuleMC.SetVisible(false);
	LoadoutPistol.SetVisible(false);
	LoadoutRifle.SetVisible(false);
	LoadoutShotgun.SetVisible(false);
	HealthBar.SetVisible(false);
	HudTop.SetVisible(false);
	HackingA.SetVisible(false);
	HackingB.SetVisible(false);
	HackingC.SetVisible(false);
	UploadingTF.SetVisible(false);
	HackNumber.SetVisible(false);
	HackPerc.SetVisible(false);
	HackBar.SetVisible(false);
	CapBarA.SetVisible(false);
	CapBarB.SetVisible(false);
	CapBarC.SetVisible(false);

	HackCompleteMC.SetVisible(false);

	MultiKillMC = GetVariableObject("_root.popup");

    TimeTF = GetVariableObject("_root.teamStats.roundTime");

	if ( bIsTeamHUD )
	{
		ScoreBarMC[0] = GetVariableObject("_root.teamStats.teamRed");
		ScoreTF[0] = GetVariableObject("_root.teamStats.TicketsOrange");
		ScoreBarMC[1] = GetVariableObject("_root.teamStats.teamBlue");
		ScoreTF[1] = GetVariableObject("_root.teamStats.TicketsCyan");
	}
	else
	{
		ScoreBarMC[1] = GetVariableObject("_root.teamStats.teamRed");
		ScoreTF[1] = GetVariableObject("_root.teamStats.scoreRed");
		ScoreBarMC[0] = GetVariableObject("_root.teamStats.teamBlue");
		ScoreTF[0] = GetVariableObject("_root.teamStats.scoreBlue");
	}

	if ( bIsTeamHUD )
	{
		//EnemyNameTF.SetVisible(false);
		/*FlagCarrierTF[0] = FlagCarrierMC[0].GetObject("textField");
		FlagCarrierTF[1] = FlagCarrierMC[1].GetObject("textField");
		FlagCarrierTF[0].SetText("");
		FlagCarrierTF[1].SetText("");*/
	}
	else
	{
		ScoreBarMC[0].SetVisible(false);
		ScoreBarMC[1].SetVisible(false);
		ScoreTF[0].SetVisible(false);
		ScoreTF[1].SetVisible(false);
		TeamStatsMC.SetVisible(false);  // FIXMESTEVE - also removes clock
	}

	HitLocMC[0] = GetVariableObject("_root.dirHit.t");
	HitLocMC[1] = GetVariableObject("_root.dirHit.tr");
	HitLocMC[2] = GetVariableObject("_root.dirHit.r");
	HitLocMC[3] = GetVariableObject("_root.dirHit.br");
	HitLocMC[4] = GetVariableObject("_root.dirHit.b");
	HitLocMC[5] = GetVariableObject("_root.dirHit.bl");
	HitLocMC[6] = GetVariableObject("_root.dirHit.l");
	HitLocMC[7] = GetVariableObject("_root.dirHit.tl");

    LogMC.SetFloat("_yrotation", -15);
    TeamStatsMC.SetFloat("_yrotation", -15);

    PlayerStatsMC.SetFloat("_yrotation", 15);

    ClearStats(true);
}


static function string FormatTime(int Seconds)
{
	local int Hours, Mins;
	local string NewTimeString;

	Hours = Seconds / 3600;
	Seconds -= Hours * 3600;
	Mins = Seconds / 60;
	Seconds -= Mins * 60;
	if (Hours > 0)
		NewTimeString = ( Hours > 9 ? String(Hours) : "0"$String(Hours)) $ ":";
	NewTimeString = NewTimeString $ ( Mins > 9 ? String(Mins) : "0"$String(Mins)) $ ":";
	NewTimeString = NewTimeString $ ( Seconds > 9 ? String(Seconds) : "0"$String(Seconds));

	return NewTimeString;
}


function ClearStats(optional bool clearScores)
{
	local GFxObject.ASDisplayInfo DI;
	local int i;
	DI.hasXScale = true;
	DI.XScale = 0;

	if (LastVehicle != none)
	{
		PlayerStatsMC.GotoAndStopI(2);
		LastVehicle = none;
	}
	if (LastHealth != -10)
	{
		HealthTF.SetString("text", "0");
		LastHealth = -10;
	}
	if (LastArmor != -10)
	{		
		LastArmor = -10;
	}
	if (LastAmmoCount != -10)
	{
		LastAmmoCount = -10;
	}
	if (LastWeapon != none)
	{
		if ( MaxAmmoMC != None )  MaxAmmoMC.GotoAndStopI(51);
		LastWeapon = none;
	}

	if (clearScores && LastScore[0] != -100000)
	{
		if ( bIsTeamHUD )
		{
			for ( i = 0; i < 2; ++i )
			{
				LastScore[i] = -100000;
				if ( ScoreTF[i] != None ) ScoreTF[i].SetString("text", "");
				if ( ScoreBarMC[i] != None ) ScoreBarMC[i].SetDisplayInfo(DI);
				if ( FlagCarrierTF[i] != None ) FlagCarrierTF[i].SetText("");
			}
		}
		TimeTF.SetString("text", "");
		LastEnemy = none;
	}
}


// Written by Chris Burris
function SetCenterText2(string type, string text)
{
	CenterTextTF.SetBool("html", true);
	CenterTextTF.SetString(type, text);
	CenterTextMC.GotoAndPlay("on");
}


function AddMessage(string type, string msg)
{
	local MessageRow mrow;
	local GFxObject.ASDisplayInfo DI;
	local int j;

	if (Len(msg) == 0)
		return;

	if (FreeMessages.Length > 0)
	{
		mrow = FreeMessages[FreeMessages.Length-1];
		FreeMessages.Remove(FreeMessages.Length-1,1);
	}
	else
	{
		mrow = Messages[Messages.Length-1];
		Messages.Remove(Messages.Length-1,1);
	}

	mrow.TF.SetString(type, msg);
	mrow.Y = 0;
	DI.hasY = true;
	DI.Y = 0;
	mrow.MC.SetDisplayInfo(DI);
	mrow.MC.GotoAndPlay("show");
	for (j = 0; j < Messages.Length; j++)
	{
		Messages[j].Y -= MessageHeight;
		DI.Y = Messages[j].Y;
		Messages[j].MC.SetDisplayInfo(DI);
	}
	Messages.InsertItem(0,mrow);
}


function TickHud(float DeltaTime)
{
	local UTPawn UTP;
	local UTVehicle UTV;
	local UTWeaponPawn UWP;
	local int TotalArmor;
	local UTWeapon Weapon;
	local int i;
	local UTPlayerReplicationInfo PRI;
	local GFxObject.ASDisplayInfo DI;
	local PlayerController PC;

	PC = GetPC();

	GRI = UTGameReplicationInfo(PC.WorldInfo.GRI);
	PRI = UTPlayerReplicationInfo(PC.PlayerReplicationInfo);

	if ( GRI != None )
	{
		// score & time
		if ( TimeTF != None )
		{
			TimeTF.SetString("text", FormatTime(GRI.TimeLimit != 0 ? GRI.RemainingTime : GRI.ElapsedTime));
		}

		if ( PRI != None )
		{
			UpdateGameHUD(PRI);
		}
	}

	UTP = UTPawn(PC.Pawn);

	if (UTP == None)
	{
		UTV = UTVehicle(PC.Pawn);
		if ( UTV == None )
		{
			UWP = UTWeaponPawn(PC.Pawn);
			if ( UWP != None )
			{
				UTV = UTVehicle(UWP.MyVehicle);
				UTP = UTPawn(UWP.Driver);
			}
		}
		else
		{
			UTP = UTPawn(UTV.Driver);
		}

		if (UTV == None)
		{
			ClearStats();
			return;
		}
		else if (UTVehicle_Hoverboard(UTV) != none)
		{
			UTV = none;
		}
	}

	if (Minimap != none)
	{
		//Minimap.Update(CurZoomf);
	}
	if (UTV != LastVehicle)
	{

        if (UTV == none)
			PlayerStatsMC.GotoAndStopI(2);
		else
			PlayerStatsMC.GotoAndStopI(3);

		LastVehicle = UTV;
		LastHealth = -101;
		LastArmor = -101;
		LastAmmoCount = -101;
		LastWeapon = none;
	}

	if (LastHealth != UTP.Health)
	{
		SetHealthBar(UTP.Health);
		
		if(UTP.Health < 0) HealthTF.SetText("0");
		else HealthTF.SetText(UTP.Health);
		
		DI.hasXScale = true;
		DI.XScale = (100.0 * float(UTP.Health)) / float(UTP.HealthMax);

		if (DI.XScale >= 100)
		{
			DI.XScale = 101;
		}
		LastHealth = UTP.Health;
	}

	TotalArmor = UTP.GetShieldStrength();
	if (TotalArmor != LastArmor)
	{
		if (TotalArmor > 0)
		{
			//if (ArmorMC != none)
			//{
			//	ArmorMC.SetVisible(true);
			//	ArmorMC.GotoAndStopI(TotalArmor >= 100 ? 100 : (1 + TotalArmor));
			//}
			//ArmorTF.SetText(TotalArmor);
			//ArmorPercTF.SetVisible(true);
		}
		else
		{
			//if (ArmorMC != none)
			//{
			//	ArmorMC.SetVisible(false);
			//}
			//ArmorTF.SetText("");
			//ArmorPercTF.SetVisible(false);
		}
		LastArmor = TotalArmor;
	}

	Weapon = UTWeapon(UTP.Weapon);
	if (Weapon != none && UTV == none)
	{
		if (Weapon != LastWeapon)
		{
			SwitchCrosshare(Weapon);
			SwitchLoadout(Weapon);
			if (Weapon.AmmoDisplayType == EAWDS_None)
				//AmmoCountTF.SetText("");
			i = (Weapon.MaxAmmoCount > 30 ? 30 : Weapon.MaxAmmoCount);
			if ( MaxAmmoMC != None ) MaxAmmoMC.GotoAndStopI(31 - i);
			LastWeapon = Weapon;
		}
		i = Weapon.GetAmmoCount();
		if (i != LastAmmoCount)
		{
			LastAmmoCount = i;
			ScaleAmmoBar(i, Weapon);
		}
	}
	else if (Weapon != LastWeapon)
	{
		//AmmoCountTF.SetText("");
		//AmmoBarMC.SetVisible(false);
		//WeaponMC.SetVisible(false);
	}

	if (UTV != none)
	{
		if (UTV.Health != LastVHealth)
		{
			DI.hasXScale = true;
			DI.XScale = (100.0 * float(UTV.Health)) / float(UTV.HealthMax);
			if (DI.XScale > 100)
				DI.XScale = 100;
			LastVHealth = UTV.Health;
		}
	}
}


function DisplayHit(vector HitDir, int Damage, class<DamageType> damageType)
{
	local Vector Loc;
	local Rotator Rot;
	local float DirOfHit;
	local vector AxisX, AxisY, AxisZ;
	local vector ShotDirection;
	local bool bIsInFront;
	local vector2D	AngularDist;

	if ( class<UTDamageType>(damagetype) != none && class<UTDamageType>(damageType).default.bLocationalHit )
	{
		// Figure out the directional based on the victims current view
		GetPC().GetPlayerViewPoint(Loc, Rot);
		GetAxes(Rot, AxisX, AxisY, AxisZ);

		ShotDirection = Normal(HitDir - Loc);
		bIsInFront = GetAngularDistance( AngularDist, ShotDirection, AxisX, AxisY, AxisZ);
		GetAngularDegreesFromRadians(AngularDist);
		DirOfHit = AngularDist.X;

		if( bIsInFront )
		{
			DirOfHit = AngularDist.X;
			if (DirOfHit < 0)
			DirOfHit += 360;
		}
		else
			DirOfHit = 180 + AngularDist.X;
	}
	else
		DirOfHit = 180;
	
	DamageTop.GotoAndPlay("on");
	DamageBottom.GotoAndPlay("on");
	DamageRight.GotoAndPlay("on");
	DamageLeft.GotoAndPlay("on");
}


// Written by Chris Burris
function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Killed, class<UTDamageType> Dmg)
{
	local string msg;
	local string personalDeathMsg;

	if (Killer != none)
	{
		if ( Killer.GetTeamNum() == 0 )
		{
			msg @= "<font color='#FFA800'>";
		}
		else
		{
			msg @= "<font color='#19FFFF'>";
		}
		msg @= Killer.PlayerName;
		msg @= "</font>";

		msg @= "<font color='#FFFFFF'>banned</font>";

		if ( Killed.GetTeamNum() == 0 )
		{
			msg @= "<font color='#FFA800'>";
		}
		else
		{
			msg @= "<font color='#19FFFF'>";
		}
		msg @= Killed.PlayerName;
		msg @= "</font>";

		AddMessage("htmlText", msg);
	}
	else
	{
        if ( Killed.GetTeamNum() == 0 )
		{
			msg @= "<font color='#FFA800'>";
		}
		else
		{
			msg @= "<font color='#19FFFF'>";
		}
		msg @= Killed.PlayerName;
		msg @= "</font>";

		msg @= "<font color='#FFFFFF'>banned  themselves</font>";

		AddMessage("htmlText", msg);
	}

	if(Killed.PlayerID == GetPC().PlayerReplicationInfo.PlayerID)
	{
		if(Killer == none)
		{
			SetCenterText("You banned yourself from the server!");
		}
		else
		{
			if ( Killer.GetTeamNum() == 0 )
			{
				personalDeathMsg @= "<font color='#FFA800'>";
			}
			else
			{
				personalDeathMsg @= "<font color='#19FFFF'>";
			}
			personalDeathMsg @= Killer.PlayerName;
			personalDeathMsg @= "</font>";

			personalDeathMsg @= "banned you from the server!";

			SetCenterText2("htmlText", personalDeathMsg);
		}
	}
}


defaultproperties
{
	bDisplayWithHudOff=FALSE
	MinZoomf=16
	MaxZoomf=128
	MessageHeight=38
	MovieInfo=SwfMovie'TT_HUD.TorrentHUD'
	bEnableGammaCorrection=false
	bDrawWeaponCrosshairs=true

	bAllowInput=FALSE;
	bAllowFocus=FALSE;
}
