integer pChannel  = 205;            
                                    
integer hChannel  = -458238;        
integer acsChannel = -5824134;      


key         owner;
string      name;
integer     armed;                      
                                        
integer     attached    = FALSE;

integer     leftAttached=FALSE;


init()
{
    llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
    owner = llGetOwner();
    name  = llKey2Name(owner);
    
    llListen(pChannel, "", NULL_KEY, "");
    llListen(hChannel, "", NULL_KEY, "");
    
    armed       = FALSE;
    llWhisper(205, "daggersheath");

    if (llGetAttached() > 0) 
    {
        llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                
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
    
    attach(key attached)
    {
        if (attached == NULL_KEY)  
        {
            llWhisper(pChannel, "leftduals0"+(string)owner);
            //llResetScript();
        }
        else
        {
            llWhisper(pChannel, "leftduals1"+(string)owner);
        }
    }
    
    listen(integer chan, string name, key id, string msg)
    {     
        
        
        if (llGetOwnerKey(id) == owner)
        {
            string msgLower = llToLower(msg);
            if( msgLower == "daggerdraw")
            {
                llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                armed = TRUE; 
                attached = TRUE;
                
            }   
            
            
            
            else if (msgLower == "daggersheath")
            {
                if (armed ==TRUE)
                {
                    
                    llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                    armed = FALSE;
                }
            }
            else if(msg=="rightdual1")
            {
                llWhisper(pChannel, "leftduals1"+(string)owner);
            }
            else if (chan == hChannel) 
            {
                if (msgLower == "atccshw")
                {
                    llSay(205,"daggersheath");
                    if (armed ==TRUE)
                    {
                        armed = FALSE;
                    }
                }
            }
        }
    }

   
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == owner)
        {
            if (armed)
            {
                llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                llWhisper(205, "daggersheath");            
                armed = FALSE;

            }
            else
            {
                armed = TRUE;
                llWhisper(205, "daggerdraw");
                llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                armed = TRUE; 
                attached = TRUE;

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

