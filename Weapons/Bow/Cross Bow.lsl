//start_unprocessed_text

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
string FireRequest = "atcogasp02";

float velocity    = 60.0;
vector vecAimOffsetConstant = <0.0, 0.0,-1.4>;
vector vecAimOffset;
string stance      = "hold_r_rifle";
string snd_shoot   = "5cff4202-17c0-a1d2-25ba-26cd9a6c2f29";
rotation rot;
integer ready       = FALSE;
vector pos;
integer permissions;
integer pChannel    = 203;
key owner;
string name;
float last        = 0.0;
integer hChannel    = -458238;
vector fwd;
string fireanim    = "";
integer attached    = FALSE;
integer armed;
integer acsChannel = -5824134;
integer Stamina;
key OWNER_KEY;
integer MStamina  = 10;


init()
{
    last  = 0.0;
    owner = llGetOwner();
    name  = llKey2Name(owner);
    llListen(pChannel, "", NULL_KEY, "");
    llListen(hChannel, "", NULL_KEY, "");
    
    
    
    llListen(acsChannel, "", NULL_KEY, "" );
    
    
    permissions = FALSE;
    armed       = FALSE;
    
    ready = FALSE;
    if (llGetAttached() > 0) {
        llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
        if (llGetPermissions() & PERMISSION_TAKE_CONTROLS) {
            llRequestPermissions(owner, FALSE);
        }
        
        llWhisper(hChannel, "sheathed bow");
    } else {
        llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
    }
}
  
                                
                                

fire()
{
    
    
    
    last    = llGetTime() + 3.0;
    
    rot     = llGetRot();
    fwd     = llRot2Fwd(rot);
    pos     = llGetPos() + vecAimOffset + (fwd * 2);
    
    pos.z  += 1.5;                     
    fwd     = fwd * velocity;
    
    if (fireanim != "") {
        llStartAnimation(fireanim);
    } else {
        llStartAnimation("aim_r_rifle");
    }   
    
    if (snd_shoot != "") {
        llPlaySound(snd_shoot, 0.8);
    } else {
        llPlaySound("0d583b21-b130-8514-bdbe-59c61fbb4af4", 0.8);
    }
        if (Stamina < 0)
    {
         
         //llSay(acsChannel,"atcoaesd10");
         llSay(acsChannel,(encrypt(stamina)));
         
         Stamina = MStamina;
    }  
    
    
    
    
    Stamina = Stamina -1;
    llRezObject("bolt", pos, fwd, rot, 2);
    
    }



default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer rez)
    {
        init();
    }
    
    attach(key attached)
    {
        if (attached == NULL_KEY)  
        {
            
            
            llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
            llRequestPermissions(llGetOwner(),  FALSE);
            llReleaseControls();
            llSay(-1276679,"ShortBow");
            vector size = llGetAgentSize(attached);
            vecAimOffset = vecAimOffsetConstant;
            vecAimOffset.z *= size.z / 2.0;
            armed = FALSE;
            permissions = FALSE;
        }
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        
        
       
        OWNER_KEY = llGetOwner();
        if (llGetOwnerKey(id) == llGetOwner())
        {
        
        
            string msgLower = llToLower(msg);
            if(msgLower == "draw")
            {
                llSay(-1276679,"CrossBow");
                llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);
                Stamina = MStamina;
                armed = TRUE;
                attached = TRUE;
                permissions = TRUE; 
            
            } else if (msgLower == "sheath") {
                
                llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                if (stance != "") llStopAnimation(stance);
                llReleaseControls();
                llRequestPermissions(llGetOwner(),  FALSE);
                
                armed = FALSE;
                permissions = FALSE;
                
            } else if (msgLower == "recharge"){
                
                
                
                    
                    llWhisper (0, "/me reloaded."); 
                    
                    

                    if (armed ==TRUE) {
                        llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                        if (stance != "") {
                            llStopAnimation(stance);
                        }
                        llWhisper(203, "sheath");
                        llReleaseControls();
                        llRequestPermissions(llGetOwner(),  FALSE);
                
                        armed = FALSE;
                        permissions = FALSE;
                    }
                }
       
            
        
        
            
            
            if (msg == "atcoatfm00")
            {
                
                llOwnerSay("Not enough ammo!");
            }
           
            else if (msg == "atcoatfm01")
                {
                        if (armed ==TRUE)
                         {
                        
                        fire();
                }
            
                    
          // }
       // }

                    
                    
                    
        
 if (chan == hChannel) {
                if (msg == "atccshw") {
                    llSay(203,"sheath");
                    if (armed ==TRUE) {
                        if (stance != "") {
                          llStopAnimation(stance);
                        }
                  }
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
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            
            llStartAnimation(stance);
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

    control(key name, integer levels, integer edges) 
    {
        if (llGetTime() < last) return;
    
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            
            {
                 //llWhisper(acsChannel, "atcogasp02");
                 llWhisper(acsChannel,(encrypt(FireRequest)));
            } 
            
        }
    }
    
    touch_start(integer total_number)
    {
         
        if (llDetectedKey(0) == llGetOwner()) {
            if (armed ==TRUE) {
                llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                if (stance != "") llStopAnimation(stance);
                llWhisper(203, "sheath");
                llReleaseControls();
                llRequestPermissions(llGetOwner(),  FALSE);
            
                armed = FALSE;
                permissions = FALSE;
            }
            else
            {
                
                armed = TRUE;
                llWhisper(203, "draw");
                llSay(-1276679,"ShortBow");
                                
                llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);
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
    


    
       
       
   
    
