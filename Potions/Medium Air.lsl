integer used;                       // needed to store info about the state of the potion
integer ACS_CHANNEL = -5824134;     // ACS communication channel
key id;                             // id of touching person
key owner;                          // owner key
integer attached;                   // needed to store info about attachment point of potion


default
{
    // When script starts...
    // permissions to detach potion if needed
    
    attach(key attached)
    {
        llResetScript();
        owner = llGetOwner();    
        llRequestPermissions(owner,PERMISSION_ATTACH);  
    }
    
    
    state_entry()
    {   //  determin the owner
        owner = llGetOwner();
        // if the potion is worn as an attachment
        llRequestPermissions(owner,PERMISSION_ATTACH);  
    }

    // If potion is being touched
    touch_start(integer total_number)
    {   // If the potion is not attached or attached to HUD
        
        if(attached == 31 || 
           attached == 32 || 
           attached == 33 || 
           attached == 34 || 
           attached == 35 || 
           attached == 36 || 
           attached == 37 || 
           attached == 38)  
        {   // tell the owner to attach it at an allowed spot and detach
            llOwnerSay("You have to wear this potion in your right hand to use it!");
            llDetachFromAvatar();
        }
        // If attached to the right spot (right hand)
        else
        {   // see who touched the potion 
            id = llDetectedKey(0);
            // If touching person is the owner
            if(id == owner)
            {   // ask the potion cap prim (stores info in description
                llMessageLinked(LINK_ALL_OTHERS, 1, "ready","");
            }
            // If not the owner is touching
            else
            {   // ignore it
                return;
            }
        }
    }
    
    // Listen for link message
    link_message(integer sender_num, integer num, string str, key id)
    {   
        // If there is an OK from the potion's cap prim
        if(num == 1 && str == "ok")
        {   // heal the owner for 50 H in total
            llWhisper(ACS_CHANNEL, "atcoaeue25");
            llSleep(0.1);    
            llWhisper(ACS_CHANNEL, "atcoaeue25");    
        }
        // If there is a veto
        else if (num == 0 && str == "void")
        {   // Tell the owner that this is a one time potion and do nothing
            llOwnerSay("Potion is not ready yet...");    
        }
    }
    
    // If the owner granted the required permissions
    run_time_permissions(integer permissions)
    {   
        // determin the attachment point of the potion
        attached = llGetAttached();
    }
}
