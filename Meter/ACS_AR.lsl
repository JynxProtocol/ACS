integer listen_handle;
integer acsResetChannel = -2408448;

default
{
    state_entry()
    {
        listen_handle = llListen(acsResetChannel,"","","");
    }

listen(integer chan, string name, key id, string msg)
    {    
        if(chan == acsResetChannel)
        {
            llOwnerSay(msg);

            if (msg == (string)llGetOwner()+":ArenaReset") 
            {
                    llResetOtherScript("ACS");
            }
        }
    }
}
