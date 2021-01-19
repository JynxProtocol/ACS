integer     permissions;
vector vecAimOffsetConstant = <0.0, 0.0, 0.5>;      
vector vecAimOffset;   
float       last    = 0.0;   
key         owner;
string      name;
string  stance      = ")<SF>(  Sword Ready Stance";

rotation rot;
vector fwd;
vector pos;
float velocity    = 20.0;

init()
{
    llSay(0,"Init Debug");
    llRequestPermissions(llGetOwner(),  PERMISSION_TAKE_CONTROLS);
    //llReleaseControls();
    vector size = llGetAgentSize(llGetOwner());
    vecAimOffset = vecAimOffsetConstant;
    vecAimOffset.z += size.z / 2.0;
    permissions = TRUE;
    last  = 0.0;
    owner = llGetOwner();
    name  = llKey2Name(owner);
    
}

fire()
{
    
    
    
    last    = llGetTime() + 1.0;
    
    rot     = llGetRot();
    fwd     = llRot2Fwd(rot);
    pos     = llGetPos() + vecAimOffset + (fwd * 1.2);
    
    pos.z  -= 1;                     
    fwd     = fwd * velocity;
    
    //}  

    
    
    //Stamina = Stamina -1;
    llMessageLinked(LINK_THIS, 0, "startbackattack", NULL_KEY);
    llRezObject("Block", pos, fwd*1.25, rot, 2);
    
    }




default
{
    state_entry()
    {
        init();
        
    }
    
    on_rez(integer rez)
    {
        llResetScript();
    }
    
    attach(key attached)
    {
        if (attached == NULL_KEY)  
        {
            llResetScript();
        }
    }


    
    run_time_permissions(integer permissions)
        {
        if (permissions > 0)
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON |CONTROL_DOWN, TRUE, TRUE); // take down controls
            permissions = TRUE;
            owner = llGetOwner();
            last  = 0.0;
        }
    //}

    
    control(key id, integer held, integer change) 
    {
        
        if (llGetTime() < last) return;
        
        integer pressed = held & change;
        integer down = held & ~change;
        integer released = ~held & change;
        integer inactive = ~held & ~change;
        
        
        if (held & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
        {
            //llMessageLinked(LINK_THIS, 0, "startreadystance", NULL_KEY);
            
            if (pressed  & CONTROL_DOWN) 
            {
                //hit("Sword 2", "startforwardattack", "");
                //llSay(0,"Block Debug");
                fire();
            }            
}
    
        if (released & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
        {
            //if (stance != "") llStopAnimation(stance);
            if (stance != "")  llMessageLinked(LINK_THIS, 0, "stopreadystance", NULL_KEY);
        }
    }
}