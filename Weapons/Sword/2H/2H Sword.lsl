////////////Encryption Start//////////
string feed="PutYourEncryptionKeyHere";
 
string encrypt(string text)
{
    text = llXorBase64StringsCorrect(llStringToBase64(text),llStringToBase64(pseudo_random(feed,0,4)));
    return text;
}

string pseudo_random(string text,  integer start, integer end)
{
    integer nonce=300 * ((integer)llGetGMTclock() / 300); //nonce changes every 5 minutes so if its decrypted its useless soon
    return llGetSubString(llMD5String(text, nonce), start, end);
}
///////////Encryption End//////////////

string stamina = "atcoaesd02";

// Advanced Combat System - Sword script
// 
// Created by Harm Gulick
//
// This script contains the Advanced Combat System Sword Script
//
integer pChannel  = 205;            
                                    
integer hChannel  = -458238;        
integer acsChannel = -5824134;      

integer Stamina;                    
                                    
                                    
                                    
integer MStamina  = 10;             


string  stance      = "2408fe9e-df1d-1d7d-f4ff-1384fa7b350f";

string  drawanim    = "";
float   drawdelay   = 1.0;

string  sheathanim  = "";
float   sheathdelay = 1.0;

string  readyanim   = "";

float   velocity    = 8.0;
float gfAVVelMulti = 0.12; 


vector      fwd;                
vector      pos;                
rotation    rot;                

vector vecAimOffsetConstant = <0.0, 0.0, 0.5>;      
vector vecAimOffset;                         

vector RezAimOffset; 

string      strike  = "";
key         owner;
string      name;
integer     ready   = FALSE;
float       last    = 0.0;      
                                
                                
float       durationType1and2 =  0.4;   
float       durationOther =  0.95;      
integer     permissions;
integer     armed;                      
                                        
integer     attached    = FALSE;


hit(string type, string anim, string sound)
{
    
    strike = type;
    vector size = llGetAgentSize(llGetOwner());
    

    rot     = llGetRot();
    fwd     = llRot2Fwd(rot);
    
    
    
    pos     = llGetPos() + vecAimOffset + fwd*1.2;
    
    pos.z  -= 1;
    
    
    fwd     = fwd * velocity;
    
    
    Stamina = Stamina -1; 
    float   range;
    if (anim != "")
    {     
        //llStartAnimation(anim);
        llMessageLinked(LINK_THIS, 0, anim, NULL_KEY);
        llRezObject(strike, pos, fwd*1.125, rot, 2);
    }
    if (sound != "") 
    {
        
        llPlaySound(sound, 1);
    }
    else
    {
        
        llTriggerSound("e3a3e3ae-150f-9720-7c7b-8457ad2d743f", 1);
    }
    if (Stamina < 0)
    {
         
         llSay(acsChannel,encrypt(stamina));
         Stamina = MStamina;
    }   
    
    
    if (strike == "Two Hand Sword 2" || strike == "Two Hand Sword 1")  
    {
        last  = llGetTime() + durationType1and2;
    } 
    else 
    {
        //last  = llGetTime() + durationOther;
    }
}


StopAllAnims() 
{
    string  null    = (string)NULL_KEY;
    list    a       = llGetAnimationList(llGetOwner());
    integer y       = llGetListLength(a);
    integer i;
    
    for (i; i < y; i++) 
    { 
        if (llList2String(a, i) != null) 
        {
           if (llList2String(a, i) != "2408fe9e-df1d-1d7d-f4ff-1384fa7b350f") {
               llStopAnimation(llList2String(a, i));
            }
        }
    }
}

init()
{
    llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
    llRequestPermissions(llGetOwner(),  FALSE);
    llReleaseControls();
    vector size = llGetAgentSize(llGetOwner());
    vecAimOffset = vecAimOffsetConstant;
    vecAimOffset.z += size.z / 2.0;
    armed = FALSE;
    permissions = FALSE;
    last  = 0.0;
    owner = llGetOwner();
    name  = llKey2Name(owner);
    
    llListen(pChannel, "", NULL_KEY, "");
    llListen(hChannel, "", NULL_KEY, "");
    
    permissions = FALSE;
    armed       = FALSE;

    ready = FALSE;
    if (llGetAttached() > 0) 
    {
        llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
        if (llGetPermissions() & PERMISSION_TAKE_CONTROLS)  llRequestPermissions(owner, FALSE); 
    } 
    else 
    {
        llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
    }
}



default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer rez)
    {
        llResetScript();
    }
    
    attach(key attached)
    {
        if (attached == NULL_KEY)  
        {
            llResetScript();
        }
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        
        
        
        if (llGetOwnerKey(id) == llGetOwner())
        {
            string msgLower = llToLower(msg);
            if( msgLower == "two handed sword draw")
            {
                llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
                Stamina = MStamina;
                armed = TRUE; 
                attached = TRUE;
                permissions = TRUE;
                
            }   

            else if (msgLower == "two handed sword sheath")
            {
                if (armed ==TRUE)
                {
                    
                    llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                    //if (stance != "") llStopAnimation(stance);
                    if (stance != "")  llMessageLinked(LINK_THIS, 0, "stopreadystance", NULL_KEY);
                    llReleaseControls();
                    llRequestPermissions(llGetOwner(),  FALSE);
                    
                    armed = FALSE;
                    permissions = FALSE;
                }
            }
            else if (chan == hChannel) 
            {
                if (msgLower == "atccshw")
                {
                    llSay(205,"two handed sword sheath");
                    if (armed ==TRUE)
                    {
                        //if (stance != "") llStopAnimation(stance);
                        if (stance != "")  llMessageLinked(LINK_THIS, 0, "stopreadystance", NULL_KEY);
                        llReleaseControls();
                        llRequestPermissions(owner,  FALSE);
                        armed = FALSE;
                        permissions = FALSE;
                    }
                }
            }
        }
    }

    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_FWD |
                CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT |
                CONTROL_RIGHT | CONTROL_ROT_RIGHT, TRUE, TRUE);
            
            attached = TRUE;
            permissions = TRUE;
            owner = llGetOwner();
            llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
            ready = TRUE;
            last  = 0.0;
            
        } 
        else 
        {
            llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
            ready = FALSE;
            last  = 0.0;
            
        }
    }
    
    control(key id, integer held, integer change) 
    {
        
        if (llGetTime() < last) return;
        
        integer pressed = held & change;
        integer down = held & ~change;
        integer released = ~held & change;
        integer inactive = ~held & ~change;
        
        
        if (held & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
        {
            //llStartAnimation(stance);
            llMessageLinked(LINK_THIS, 0, "startreadystance", NULL_KEY);
            
            
            
            
            if (pressed  & CONTROL_FWD) 
            {
                hit("Two Hand Sword 1", "startforwardattack", "");
            }
            else if (pressed  & (CONTROL_LEFT | CONTROL_ROT_LEFT)) 
            {
                hit("Two Hand Sword 2", "startleftattack", "");
            }
            else if (pressed  & (CONTROL_RIGHT | CONTROL_ROT_RIGHT))
            {
                 hit("Two Hand Sword 2", "startrightattack", "");
            }
            
        }
        if (released & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
        {
            //if (stance != "") llStopAnimation(stance);
            if (stance != "")  llMessageLinked(LINK_THIS, 0, "stopreadystance", NULL_KEY);
        }
    }

    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            if (armed)
            {
                llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                //if (stance != "") llStopAnimation(stance);
                if (stance != "")  llMessageLinked(LINK_THIS, 0, "stopreadystance", NULL_KEY);
                llWhisper(205, "two handed sword sheath");
                llReleaseControls();
                llRequestPermissions(llGetOwner(),  FALSE);
                    
                armed = FALSE;
                permissions = FALSE;
            }
            else
            {
                
                armed = TRUE;
                llWhisper(205, "two handed sword draw");
                llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                llRequestPermissions(llGetOwner(),  PERMISSION_TAKE_CONTROLS);
                Stamina = MStamina;
                armed = TRUE; 
                attached = TRUE;
                permissions = TRUE;
            }
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }
}

