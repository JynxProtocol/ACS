
integer     pChannel  = 205;            // Chat channel on which draw and sheath commands
                                        // can be given by the owner
integer     hChannel  = -458238;        // Auto Sheath to be added to meter

key         owner;                      // 
integer     armed;                      // Indicates the state of the sword and sheath 
                                        // 0 = sheathed, 1 = unsheathed (or armed)


init()
{
    owner = llGetOwner();
    llListen(pChannel, "", NULL_KEY, "");
    llListen(hChannel, "", NULL_KEY, "");;
    armed       = FALSE;
    llWhisper(205, "daggersheath");
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
                llMessageLinked(LINK_SET, 0, "show", NULL_KEY);

            }
            else
            {
                
                // Draw the weapon
                armed = TRUE;
                llWhisper(205, "daggerdraw");
                llMessageLinked(LINK_SET, 0, "hide", NULL_KEY); 
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

                }
            } else if (msgLower == "daggersheath") {
                // only sheath if the sword wasn't sheated yet
                if (armed) {
                    armed = FALSE;
                    llMessageLinked(LINK_SET, 0, "show", NULL_KEY);

                }
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