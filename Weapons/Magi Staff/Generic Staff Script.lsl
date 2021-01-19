////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  ACD Magical Weapon Script
//
////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Global Constants and Parameters. List all bullets and sounds here
//
////////////////////////////////////////////////////////////////////////////////////////////////////

string BL_STANDARD = "Lightning";                   // Standard Spell
string SN_STANDARD = "Lightning Sound";             // Standard Sound
string BL_PSDMG_MED = "Flash Ball";                 // Physical Spell with medium effect
string SN_PSDMG_MED = "Lightning Sound";            // Medium Physical Spell Sound
string BL_PSDMG_HI = "Shockwave";                   // Physical Spell with high effect
string SN_PSDMG_HI = "Lightning Sound"; 
string BL_ASDMG_LOW = "Hail";                // Area Spell with low effect

string BL_ASDMG_MED = "Earthquake";                // Area Spell with med effect

string BL_ASDMG_HI = "Tornado";                // Area Spell with high effect

string BL_HS_EGO = "Selfheal";

string BL_HS_LOW = "Heal";                // Heal Spell with low effect

string BL_HS_AOE = "Groupheal";                // Owner Spell with med effect

string BL_SS_AOE = "Groupstamina";                // Owner Spell with high effect


string strAnim = "hold_R_handgun";
integer intGrip = ATTACH_RHAND;
string strGripMessage = "this weapon only fits in your right hand";
vector vecAimOffsetConstant = <0.0, 0.0, 0.84>;
list lstSpells = [BL_STANDARD,BL_PSDMG_MED,BL_PSDMG_HI//,
                  //BL_ASDMG_LOW,BL_ASDMG_MED,BL_ASDMG_HI,
                  //BL_HS_EGO,BL_HS_LOW,BL_HS_AOE,BL_SS_AOE,"DISARM"
                  ];
 
 

//**************************************************************************************************
//**************************************************************************************************
//**
//**                               ! ! ! ! W A R N I N G ! ! ! !
//**
//**        DO NOT CHANGE ANYTHING BELOW THIS POINT. OR HEAVEN WILL CRASH ON YOUR HEAD !!
//**
//**************************************************************************************************
//**************************************************************************************************



////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Global Variables
//
////////////////////////////////////////////////////////////////////////////////////////////////////

string strBulletName;                        // Name of the bullet that should be rezzed
string strShotSound;                         // Name of the shooting sound effect
float fltBulletSpeed;                        // Shooting speed of the rezzed bullet
integer intBulletMana;                         // Mana the selected speel uses
integer intEnableBullet;
integer intEnableSound;
integer intArmed;
vector vecAimOffset;
integer acsChannel = -5824134;
integer menuChannel = -999;
integer Handle;
string strUsedState;                        // State to be used by weapon



////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Global Functions
//
////////////////////////////////////////////////////////////////////////////////////////////////////

say(string message)
{
        llOwnerSay(message);
}

getPerms()
{
        integer perms = llGetPermissions()
            | PERMISSION_TAKE_CONTROLS
            | PERMISSION_TRIGGER_ANIMATION
            | PERMISSION_ATTACH;
        llRequestPermissions(llGetOwner(), perms);        
}

verifyInventory()
{
    if (llGetInventoryKey(strBulletName) != NULL_KEY)
    {
        intEnableBullet = TRUE;
    }
    else
    {
        intEnableBullet = FALSE;
        say("bullet not found: " + strBulletName);
    }
    if (llGetInventoryKey(strShotSound) != NULL_KEY)
    {
          intEnableSound = TRUE;
    }
    else
    {
            intEnableSound = FALSE;
            say("sound not found: " + strShotSound);
        }
}

arm()
{
    integer perm = PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION;
    if ((llGetPermissions() & perm) != perm )
    {
          getPerms();
    }
    else
    {
          llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation(strAnim);
            intArmed = TRUE;
        }
}

disarm()
    {
    if(llGetAgentSize(llGetPermissionsKey()) != ZERO_VECTOR)
    {
        llStopAnimation(strAnim);
        llReleaseControls();
        intArmed = FALSE;
    }
}

RemoveListen()
{
        llListenRemove(Handle);
        Handle = llListen(acsChannel,"", "","");
}

RemoveListenMenu()
{
        llListenRemove(Handle);
        Handle = llListen(menuChannel,"", llGetOwner(),"");
}


fire(string spell, string sound, float speed, integer mana)
{
    if (intEnableSound) llTriggerSound(sound, 1.0);
    rotation rot = llGetRot();
    vector aim = llRot2Fwd(rot);
    vector pos = llGetPos() + vecAimOffset + (aim * 2);
    pos.z  += 1.0;
    llRezObject(spell, pos, aim * speed, rot, mana);
}


default
{  
    state_entry()
        {
        llListen(acsChannel, "", "", "");
        fltBulletSpeed = 50.0;
        intBulletMana = 10;
        strBulletName = BL_STANDARD;
        strShotSound = SN_STANDARD;
        //strUsedState = BL_STANDARD;
        
        }
    
        touch_start(integer count)
        {
        if (llDetectedKey(0) != llGetOwner())
        {
                return;
        }
        else if (!llGetAttached())
        {
                getPerms();
        }
        else if (intArmed)
        {
                //disarm();
            llListen(menuChannel, "", "", "");
            Handle = llListen(menuChannel,"", llGetOwner(),"");
            llDialog(llGetOwner(),"Choose a Spell",lstSpells, menuChannel);
        }
        else
        {
                arm();
        }
    }
    
    run_time_permissions(integer perms)
    {
        if (perms & (PERMISSION_TAKE_CONTROLS
                    | PERMISSION_TRIGGER_ANIMATION
                    | PERMISSION_ATTACH))
        {
            if (!llGetAttached())
            {
                        llAttachToAvatar(intGrip);
            }
            else if (llGetAttached() != intGrip)
            {
                        say(strGripMessage);
                        llDetachFromAvatar();
            }
            else
            {
                        verifyInventory();
                        arm();
                }
        }
        else
        {
                say("insufficient permissions");
                if (llGetAttached()) llDetachFromAvatar();
            }   
        }
    
        attach(key avatar)
        {
        if (avatar != NULL_KEY)
        {
                // attaching
                vector size = llGetAgentSize(avatar);
                vecAimOffset = vecAimOffsetConstant;
                vecAimOffset.z *= size.z / 2.0;
                getPerms();
        }
        else
        {
                // detaching
                if (intArmed) disarm();
            }
        }
        
        control(key avatar, integer levels, integer edges)
        {
            // mouse press
        if ((levels & CONTROL_ML_LBUTTON) && (edges & CONTROL_ML_LBUTTON))
        {
            }

            // mouse release                
        if (!(levels & CONTROL_ML_LBUTTON) && (edges & CONTROL_ML_LBUTTON))
        {
            llWhisper(acsChannel, "atcogmsp" + (string)intBulletMana);
            //RemoveListen();
            //state strUsedState;
            }

        // mouse down
        if ((levels & CONTROL_ML_LBUTTON) && !(edges & CONTROL_ML_LBUTTON))
        {
            }
        }
    
        listen(integer channel, string name, key id, string message)
        {
        if(channel == menuChannel)
        {
            RemoveListenMenu();
            if (message == BL_STANDARD)
            {
                intBulletMana = 10;
                strBulletName = BL_STANDARD;
                strShotSound = SN_STANDARD;    
            }
            else if(message == BL_PSDMG_MED)
            {
                intBulletMana = 25;
                strBulletName = BL_PSDMG_MED;
                strShotSound = SN_PSDMG_MED;
            }
            else if(message == BL_PSDMG_HI)
            {
                intBulletMana = 90;
                strBulletName = BL_PSDMG_HI;
                strShotSound = SN_PSDMG_HI;
            }
            else if(message == BL_ASDMG_LOW)
            {
                intBulletMana = 10;
                strBulletName = BL_ASDMG_LOW;
                strShotSound = BL_ASDMG_LOW;
            }
            else if(message == BL_ASDMG_MED)
            {
                intBulletMana = 10;
                strBulletName = BL_ASDMG_MED;
                strShotSound = BL_ASDMG_MED;
            }
            else if(message == BL_ASDMG_HI)
            {
                intBulletMana = 10;
                strBulletName = BL_ASDMG_HI;
                strShotSound = BL_ASDMG_HI;
            }
            else if(message == BL_HS_EGO)
            {
                intBulletMana = 10;
                strBulletName = BL_HS_EGO;
                strShotSound = BL_HS_EGO;
            }
            else if(message == BL_HS_LOW)
            {
                intBulletMana = 10;
                strBulletName = BL_HS_LOW;
                strShotSound = BL_HS_LOW;
            }
            else if(message == BL_HS_AOE)
            {
                intBulletMana = 10;
                strBulletName = BL_HS_AOE;
                strShotSound = BL_HS_AOE;
            }
            else if(message == BL_SS_AOE)
            {
                intBulletMana = 10;
                strBulletName = BL_SS_AOE;
                strShotSound = BL_SS_AOE;
            }
            else if(message == "DISARM")
            {
                disarm();
            }
        }
        else if (channel == acsChannel)
        {
            if(message == "atcomtfm00")
            {
                say("Not enough mana!");
            }
            else if (message == "atcomtfm01")
            {
                fire(strBulletName, strShotSound, fltBulletSpeed, intBulletMana);
            }
        }
    }
}