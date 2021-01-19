integer recharge;
string usage;       // needed to store info about state of the potion
float tick = 1.8;

default
{
    // When script starts
    state_entry()
    {   
        // get info if potion has been used yet from the potion's cap prim description
        usage = llGetObjectDesc();
        if(usage == "unused")
        {
            llSetText("READY!", <0,1,0>, 1.0);
            llSetAlpha(1, ALL_SIDES);
        }
        else
        {
            llSetText("Recharging..." + (string)recharge , <1,0,0>, 1.0);
            llSetAlpha(0, ALL_SIDES);
            llSetTimerEvent(tick);
        }
    }
    
    // listen for link message
    link_message(integer sender_num, integer num, string str, key id)
    {
        // If the main script asks if the potion is still hot..
        if(num == 1 && str == "ready")
        {   
            // get info if potion has been used yet from the potion's cap prim description (double check)
            usage = llGetObjectDesc();
            // if the potion is still unused
            if(usage == "unused")
            {
                // send a link message with an ok and set the state to being used
                llMessageLinked(LINK_ALL_OTHERS, 1, "ok","");        
                llSetObjectDesc("used");
                recharge = 0;
                llSetTimerEvent(tick);
                llSetAlpha(0, ALL_SIDES);
                llSetText("Recharging..." + (string)recharge + "%", <1,0,0>, 1.0);
            }
            // if the potion has already been used
            else if(usage == "used")
            {   
                // don't send an ok and set state to used (double safety)
                llMessageLinked(LINK_ALL_OTHERS, 0, "void","");
                llSetObjectDesc("used");     
            }
        }
    }
    
    timer()
    {
        recharge++;
        // debug llSay(0, (string)recharge);
        if( recharge == 25)
        {
            llSetText("Recharging..." + (string)recharge + "%", <1,0.5,0>, 1.0);
        }
        else if(recharge == 50)
        {
            llSetText("Recharging..." + (string)recharge + "%", <1,1,0>, 1.0);
        }
        if(recharge == 75)
        {
            llSetText("Recharging..." + (string)recharge + "%", <0.5,1,0>, 1.0);
        }
        if(recharge == 100)
        {
            llSetText("READY!", <0,1,0>, 1.0);
            llSetObjectDesc("unused");
            llSetAlpha(1, ALL_SIDES);
            llSetTimerEvent(0);  
        }
    }
}
