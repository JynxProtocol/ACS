key owner;
string EF_NDAM = "aeda"; 
string newCommand;
integer Amount;

letAvatarFall() 
{
    if ((llGetAgentInfo(owner) & AGENT_FLYING) == 0) 
    {
        float Speed = llVecMag(llGetVel());
        vector pos=llGetPos();
        
        if (Speed > 16.0 && pos.z>llWater(ZERO_VECTOR)) 
        {
            if (Speed > 20) 
            {
               Speed = Speed * 2;
            }
            integer T =llRound(Speed / 5);
            Amount = (T * 2);
            llMessageLinked(LINK_THIS, Amount, EF_NDAM, "HIT");
         }
    }
}

string zero_pad(integer number)
{
    if (number < 10)
    {
        return "0" + (string)number;
    }
    else 
    {
        return (string)number;
    }
} //End of zero_pad

default
{
    attach(key attached)
    {
        llResetScript();
    }
    
    state_entry()
    {
        owner = llGetOwner();
    }

    collision_start(integer num_detected)
    {           
        if(llGetAnimation(owner)=="Standing Up")
        {        
            letAvatarFall();
        }
    }
    
    land_collision_start(vector position)
    {           
        if(llGetAnimation(owner)=="Standing Up")
        {        
            letAvatarFall();
        }
    }
}
