

integer     pChannel  = 203;
integer     hChannel    = -458238; //Auto Sheath to be added to meter

key         owner;
integer     permissions;
integer     armed;

string  draw   = "dart_gun_draw-sheath-Kamala";
string  sheath  = "dart_gun_draw-sheath-Kamala";

string ssound = "e00c3ac1-c943-fd76-5360-3b5e264223f5"; //Quiver sound
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
        if (llDetectedKey(0) == llGetOwner())
        {
            if(armed)
            {
                // Sheath the weapon
                armed = FALSE;
                llWhisper(203, "sheath");
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                llMessageLinked(LINK_SET, 0, "show", NULL_KEY);
                llPlaySound(ssound, volume); 
                permissions = FALSE;
            }
            else
            {
                // Draw the weapon
                armed = TRUE;
                llWhisper(203, "draw");
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                llMessageLinked(LINK_SET, 0, "hide", NULL_KEY); 
                llPlaySound(ssound, volume); 
                permissions = TRUE;
            }
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            string msgLower = llToLower(msg);
            if(msgLower == "draw")
            {
                llMessageLinked(LINK_SET, 0, "hide", NULL_KEY);
                llPlaySound(ssound, volume); 
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                armed = TRUE; 
                permissions = TRUE;
            } 
            else if (msgLower == "sheath")
            {
                if (armed ==TRUE){
                   llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                    llMessageLinked(LINK_SET, 0, "show", NULL_KEY);
                    llPlaySound(ssound, volume);                
                    armed = FALSE;
                    permissions = FALSE;
                }
            }
        }
    }

    run_time_permissions(integer permissions)
    {
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
            llRequestPermissions(llGetOwner(),  FALSE);
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