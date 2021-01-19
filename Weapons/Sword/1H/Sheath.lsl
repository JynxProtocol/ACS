


integer     pChannel  = 205;            // Chat channel on which draw and sheath commands
                                        // can be given by the owner
integer     hChannel  = -458238;        // Auto Sheath to be added to meter

key         owner;                      // 
integer     permissions;                //
integer     armed;                      // Indicates the state of the sword and sheath 
                                        // 0 = sheathed, 1 = unsheathed (or armed)

//string  draw   = ")<SF>( Sword Draw";
//string  sheath  = ")<SF>( Sword Sheath";
//string  draw;
//string  sheath;

string ssound = "c3645183-3601-30fa-5955-2eb90d6d7451"; //Scabbard Sound
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
                armed = FALSE;
                llWhisper(205, "sheath");
                //llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                llMessageLinked(LINK_THIS, 0, "sheath", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "show", NULL_KEY);
                llPlaySound(ssound, volume); 
                permissions = FALSE;
            }
            else
            {
                armed = TRUE;
                llWhisper(205, "draw");
                //llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                llMessageLinked(LINK_THIS, 0, "draw", NULL_KEY);
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
            if(msgLower == "draw"){
                if (!armed) {   
                    llMessageLinked(LINK_SET, 0, "hide", NULL_KEY);
                    llPlaySound(ssound, volume); 
                    //llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                    llMessageLinked(LINK_THIS, 0, "draw", NULL_KEY);
                    armed = TRUE; 
                    permissions = TRUE;
                }
            } else if (msgLower == "sheath") {
                if (armed) {
                    //llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
                    llMessageLinked(LINK_THIS, 0, "sheath", NULL_KEY);
                    llMessageLinked(LINK_SET, 0, "show", NULL_KEY);
                    llPlaySound(ssound, volume);                
                    armed = FALSE;
                    permissions = FALSE;
                }
            }
        }
    }

    //run_time_permissions(integer permissions)
    //{
       // if (permissions > 0)
       // {
           // llStartAnimation(draw);
          //  permissions = TRUE;
           // owner = llGetOwner();
       // } 
        //else 
        //{
           // llStartAnimation(sheath);
           // permissions = TRUE;
           // owner = llGetOwner();
           // llRequestPermissions(llGetOwner(),  FALSE);
       // }
    //}
   

                    
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }
}