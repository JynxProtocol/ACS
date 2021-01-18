integer intAmmo;



default
{
    state_entry()
    {
        intAmmo = (integer)llGetObjectDesc();
        llMessageLinked(LINK_SET, intAmmo, "AStore", NULL_KEY);
    }

    link_message( integer sibling, integer num, string mesg, key target_key ) 
    {
        if(mesg == "atfm")
        {
            intAmmo = num;
            llSetObjectDesc((string)intAmmo);
        }
        else if(mesg == "GiveAmmo")
        {
            llMessageLinked(LINK_SET, intAmmo, "AStore", NULL_KEY);
        }
        
    }
    
}
