
key OWNER_KEY;   

integer ammo_update = -1176679;             

key owner;

string color = "<1.0, 1.0, 1.0>";

integer ammo;
integer factor = 2;

default
{
    attach( key id )
    {
        
        if( ( id != NULL_KEY ) && ( id != OWNER_KEY ) )
        {
            llResetScript();
            llSetText("0", (vector)color, 1.0);
        }
    }
    
    state_entry()
    {
        owner = llGetOwner();
        llListen(ammo_update, "", NULL_KEY, "");
    }
    
    listen(integer sender_number, string name, key id,string message )
    {
                        {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            
            if(sender_number == ammo_update)
            {
                       
                ammo = (integer)message / factor;
                llSetText((string)ammo, (vector)color, 1.0);
            }
        }
    }
}
}

