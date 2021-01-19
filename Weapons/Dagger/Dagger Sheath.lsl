

integer     pChannel  = 205;            // Chat channel on which draw and sheath commands
                                        // can be given by the owner
integer     hChannel  = -458238;        // Auto Sheath to be added to meter

key         owner;                      // 
integer     permissions;                //
integer     armed;                      // Indicates the state of the sword and sheath 
                                        // 0 = sheathed, 1 = unsheathed (or armed)

string  draw   = ")<SF>(  Dagger Draw";
string  sheath  = ")<SF>(  Dagger Sheath";

string ssound = "9908aaf8-f793-1fe3-c7d9-935e81c32272"; //Scabbard Sound
float volume;

init()
{
    owner = llGetOwner();
    llListen(pChannel, "", NULL_KEY, "");
    llListen(hChannel, "", NULL_KEY, "");
    permissions = FALSE;
    armed       = FALSE;
    volume = 1;

    if (llGetAttached() > 0) {
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
        init();
    }

    touch_start(integer total_number)
    {
        
        if (llDetectedKey(0) == owner)
        {
            if(armed)
            {
                // Sheath the weapon
                
                armed = FALSE;
                llWhisper(205, "daggersheath");
                llRequestPermissions(owner,  PERMISSION_TRIGGER_ANIMATION);
                llMessageLinked(LINK_SET, 0, "show", NULL_KEY);
                llPlaySound(ssound, volume); 
                permissions = FALSE;
            }
            else
            {
                
                // Draw the weapon
                armed = TRUE;
                llWhisper(205, "daggerdraw");
                llRequestPermissions(owner,  PERMISSION_TRIGGER_ANIMATION);
                llMessageLinked(LINK_SET, 0, "hide", NULL_KEY); 
                llPlaySound(ssound, volume); 
                permissions = TRUE;
            }
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (llGetOwnerKey(id) == owner)
        {
            string msgLower = llToLower(msg);
            if(msgLower == "daggerdraw"){
                // only arm if the sword wasn't armed yet
                if (!armed) {  
                    armed = TRUE;  
                    llMessageLinked(LINK_SET, 0, "hide", NULL_KEY);
                    llPlaySound(ssound, volume); 
                    llRequestPermissions(owner,  PERMISSION_TRIGGER_ANIMATION);
                    
                    //permissions = TRUE;
                }
            } else if (msgLower == "daggersheath") {
                // only sheath if the sword wasn't sheated yet
                if (armed) {
                    armed = FALSE;
                    llRequestPermissions(owner,  PERMISSION_TRIGGER_ANIMATION);
                    llMessageLinked(LINK_SET, 0, "show", NULL_KEY);
                    llPlaySound(ssound, volume);                
                    
                   // permissions = FALSE;
                }
            }
        }
    }

    run_time_permissions(integer permissions)
    {
        /*
        if (permissions > 0)
        {
            llStartAnimation(draw);
            permissions = TRUE;
            owner = llGetOwner();
        } 
        else 
        {
            llStartAnimation(sheath);
            permissions = TRUE;
            owner = llGetOwner();
            llRequestPermissions(owner,  FALSE);
        }
        */
        if(permissions & PERMISSION_TRIGGER_ANIMATION)
        {
            if(armed==TRUE)
            {
                llStartAnimation(draw);
            }
            else if(armed==FALSE)
            {
                llStartAnimation(sheath);
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