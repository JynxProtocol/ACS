castMeteor()
{
    integer velocity=65;
    
    rotation rot=llGetRot();
    vector fwd=llRot2Fwd(rot);
    
    //vector offset=<0.3,0,0>;
    //offset*=rot;
    //pos+=offset;
    vector pos=llGetPos() + fwd*1.5;
    pos.z  += (agentSize.z/2)-0.1;
    fwd     = fwd * velocity;
    llPointAt(pos);
    llResetTime();
    llStartAnimation("StaffAttack");
    llRezObject("MeteorSeed",pos,fwd,rot,0);
    llPlaySound("fb1de42c-b920-240e-649d-2db9ae1cadc7",1.0);
}

castBVortex()
{
    integer velocity=55;
    
    rotation rot=llGetRot();
    vector fwd=llRot2Fwd(rot);
    
    //vector offset=<0.3,0,0>;
    //offset*=rot;
    //pos+=offset;
    vector pos=llGetPos() + fwd*0.5;
    pos.z  += (agentSize.z/2)-0.1;
    fwd     = fwd * velocity;
    llPointAt(pos);
    llResetTime();
    llStartAnimation("StaffAttack");
    llRezObject("vortex",pos,fwd,rot,0);

}

castIceShards()
{
    llResetTime();
    integer velocity=35;
    rotation rot=llGetRot();
    vector fwd=llRot2Fwd(rot);
    
    //vector offset=<0.3,0,0>
    //offset*=rot;
    //pos+=offset;
    vector pos=llGetPos() + fwd*0.5;
    pos.z  += (agentSize.z/2)-0.1;
    fwd     = fwd * velocity;
    llPointAt(pos); 
    llStartAnimation("StaffAttack");   
    llRezAtRoot("IceShard",pos,fwd,rot,llFloor(llFrand(100.99)));
    llSleep(0.2);
    rot=llGetRot();
    fwd=llRot2Fwd(rot);
    pos=llGetPos() + fwd*0.5;
     pos.z  += (agentSize.z/2)-0.1;
    fwd     = fwd * velocity;
    llPointAt(pos);
    llRezAtRoot("IceShard",pos,fwd,rot,llFloor(llFrand(100.99)));
    llSleep(0.2);
    rot=llGetRot();
    fwd=llRot2Fwd(rot);
    pos=llGetPos() + fwd*0.5;
     pos.z  += (agentSize.z/2)-0.1;
    fwd     = fwd * velocity;
    llPointAt(pos);    
    llRezAtRoot("IceShard",pos,fwd,rot,llFloor(llFrand(100.99)));
    

}

castDrainLife()
{
    integer velocity=40;
    
    rotation rot=llGetRot();
    vector fwd=llRot2Fwd(rot);
    
    //vector offset=<0.3,0,0>;
    //offset*=rot;
    //pos+=offset;
    vector pos=llGetPos() + fwd*0.5;
    pos.z  += (agentSize.z/2)-0.1;
    fwd     = fwd * velocity;
    llPointAt(pos);
    llResetTime();
    llStartAnimation("StaffAttack");
    llPlaySound("1e745208-5b87-a795-462f-3775b96b75f4",0.4);
    llRezAtRoot("DrainLife",pos,fwd,rot,0);
    

}

castManaLeech()
{
    integer velocity=40;
    
    rotation rot=llGetRot();
    vector fwd=llRot2Fwd(rot);
    
    //vector offset=<0.3,0,0>;
    //offset*=rot;
    //pos+=offset;
    vector pos=llGetPos() + fwd*0.5;
    pos.z  += (agentSize.z/2)-0.1;
    fwd     = fwd * velocity;
    llPointAt(pos);
    llResetTime();
    llStartAnimation("StaffAttack");
    llTriggerSound("01c4ff58-5f66-1dfc-6db3-e4065c8be7cb",1.0);
    llRezAtRoot("manaleech",pos,fwd,rot,0);
    

}

////////////Encryption Start//////////
string feed="PutYourEncryptionKeyHere";
 
string encrypt(string text)
{
    text = llXorBase64StringsCorrect(llStringToBase64(text),llStringToBase64(pseudo_random(feed,0,4)));
    return text;
}
 

string pseudo_random(string text,  integer start, integer end)
{
    integer nonce=300 * ((integer)llGetGMTclock() / 300); //nonce changes every 5 minutes so if its decrypted its useless soon
    return llGetSubString(llMD5String(text, nonce), start, end);
}
///////////Encryption End//////////////

key owner;
integer dialogChan=-5678944;
integer acsChannel = -5824134;
integer dialogListen;
integer acsListen;
string currentSpell;
integer raised;
vector agentSize;
integer lastAttack;
string casting;

integer vortexManaCost=14;
integer iceShardsManaCost=6;
integer meteorManaCost=32;
integer drainLifeManaCost=14;
integer manaLeechManaCost=5;


default
{

    on_rez(integer start_param)
    {
        owner=llGetOwner();
        llRequestPermissions(owner, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        raised=FALSE;
        llStopAnimation("StaffHoldLeft");        
        agentSize=llGetAgentSize(owner);
    }
    state_entry()
    {
        owner=llGetOwner();
        llSetText("Demo",<1,1,1>,1.0);
        llRequestPermissions(owner, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        raised=FALSE;
        llStopAnimation("StaffHoldLeft");        
        agentSize=llGetAgentSize(owner);
    }
    touch_start(integer total_number)
    {
        if(llDetectedKey(0)==owner)
        {
            if(raised==TRUE)
            {
                llDialog(owner, "Select a spell to cast",["Vortex","Meteor","Ice Shards","Drain Life","Mana Leech","Lower Staff"],dialogChan);
                dialogListen=llListen(dialogChan,"",owner,"");
                llSetTimerEvent(15);
            }
            else
            {
                raised=TRUE;
                llStartAnimation("StaffHoldLeft");
            }
        }
    }
    timer()
    {
        llSetTimerEvent(0.0);
        llListenRemove(dialogListen);
        llListenRemove(acsListen);
    }
    control(key owner, integer held, integer change)
    {
        
        integer pressed = held & change;
        integer down = held & ~change;
        integer released = ~held & change;
        integer inactive = ~held & ~change;
        if (pressed & CONTROL_ML_LBUTTON  && casting!="busy")
        {
            if(llGetUnixTime()-lastAttack>1)
            {
                lastAttack=llGetUnixTime();
                if(currentSpell=="Blazing Vortex")
                {
                    llWhisper(acsChannel,encrypt("atcogmsp"+(string)vortexManaCost));
                }
                else if(currentSpell=="Meteor")
                {
                    llWhisper(acsChannel,encrypt("atcogmsp"+(string)meteorManaCost));
                }
                else if(currentSpell=="Ice Shards")
                {
                    llWhisper(acsChannel,encrypt("atcogmsp"+(string)iceShardsManaCost));
                }
                else if(currentSpell=="Drain Life")
                {
                    llWhisper(acsChannel,encrypt("atcogmsp"+(string)drainLifeManaCost));
                }
                else if(currentSpell=="Mana Leech")
                {
                    llWhisper(acsChannel,encrypt("atcogmsp"+(string)manaLeechManaCost));
                }
                acsListen=llListen(acsChannel,"","","");
                llSetTimerEvent(5.0);
                
            }
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(chan==acsChannel)
        {
            if(llGetOwnerKey(id)==owner && msg=="atcomtfm01")
            {
                llSetTimerEvent(0.0);
                llListenRemove(acsListen);
                if(currentSpell=="Blazing Vortex")
                {
                    castBVortex();
                }
                else if(currentSpell=="Meteor")
                {
                    castMeteor();
                }
                else if(currentSpell=="Ice Shards")
                {
                    castIceShards();
                }
                else if(currentSpell=="Drain Life")
                {
                    castDrainLife();
                }
                else if(currentSpell=="Mana Leech")
                {
                    castManaLeech();
                }
            }
        }
        else
        {
            if(msg=="Vortex")
            {
                currentSpell="Blazing Vortex";
                llOwnerSay("Current Spell: "+currentSpell);
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            }
            else if(msg=="Meteor")
            {
                currentSpell="Meteor";
                llOwnerSay("Current Spell: "+currentSpell);
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            }
            else if(msg=="Ice Shards")
            {
                currentSpell="Ice Shards";
                llOwnerSay("Current Spell: "+currentSpell);
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            }
            else if(msg=="Drain Life")
            {
                currentSpell="Drain Life";
                llOwnerSay("Current Spell: "+currentSpell);
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            }
            else if(msg=="Mana Leech")
            {
                currentSpell="Mana Leech";
                llOwnerSay("Current Spell: "+currentSpell);
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            }
            else if(msg=="Lower Staff")
            {
                llTakeControls(CONTROL_ML_LBUTTON,FALSE,TRUE); 
                raised=FALSE;
                llStopAnimation("StaffHoldLeft");  
            }
            llSetTimerEvent(0.0);
            llListenRemove(dialogListen);
        }
         
    }
}
