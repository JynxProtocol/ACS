string TITLE="Sit here";            //This text will appear in the floating title above the ball
string ANIMATION="";             //Put the name of the pose/animation here!
vector offset=<0,-0.7,0>;            //You can play with these numbers to adjust how far the person sits from the ball. ( <X,Y,Z> )
integer use_voice = FALSE;

string  gNotecard = "Pose ball - CONFIGURATION";
integer gLine = 0;

integer listenHandle = -1;
integer masterswitch = TRUE;
integer visible = TRUE;
float base_alpha = 1.0;
key avatar;

key dataserver_key = NULL_KEY;

show()
{
    visible = TRUE;
    llSetText(TITLE, <1,1,1>,1);        
    //llSetAlpha(base_alpha, ALL_SIDES);
}

hide()
{
    visible = FALSE;
    llSetText("", <1,1,1>,1);        
    //llSetAlpha(0, ALL_SIDES);
}

next_line()
{
    gLine++;
    dataserver_key = llGetNotecardLine(gNotecard,gLine);
}

use_defaults()
{
    llSetSitText("Sit Here");
    if(visible == FALSE)
        llSetText("",<1,1,1>,1);
    else
        llSetText(TITLE,<1,1,1>,1);
}

init()
{

    if(llGetInventoryNumber(INVENTORY_ANIMATION) == 0)      //Make sure we actually got something to pose with.
    {
        llWhisper(0,"Error: No animation found. Cannot pose.");
        ANIMATION = "sit";
    }
    else
        ANIMATION = llGetInventoryName(INVENTORY_ANIMATION,0);

    if(llGetInventoryNumber(INVENTORY_NOTECARD) != 0)       //If the notecard is present, use it for configuration.
    {
        integer i;
        for(i=0;i<llGetInventoryNumber(INVENTORY_NOTECARD);i++)
            if(llGetInventoryName(INVENTORY_NOTECARD,i) == gNotecard)
            {
                gLine = 0;
                dataserver_key = llGetNotecardLine(gNotecard, 0);
                return;
            }
        use_defaults();
    }
    else            //No configuration notecard found... lets use the defaults.
        use_defaults();
}

default
{
    state_entry()
    {
        llSetText("Starting up", <1,1,1>,1);
        llSitTarget(offset,llEuler2Rot(<90,00,90>*DEG_TO_RAD));
        init();
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        if(num == 99)
        {
            if(str == "show")
            {
                masterswitch = FALSE;
                hide();
                return;
            }
            
            if(str == "hide");
            {
                masterswitch = TRUE;
                show();
            }
        }
    }
    
    touch_start(integer detected)
    {
        if(use_voice == FALSE)
        {
            if(visible == TRUE)
                hide();
            else
                show();
        }
        else
            llSay(0,llDetectedName(0)+", say '/1 Hide' to hide me, or '/1 Show' to make me show. Or just right-click and sit on me to use me.");
    }
    
    changed(integer change)
    {
        if(change == CHANGED_LINK)
        {
            avatar = llAvatarOnSitTarget();
            if(avatar != NULL_KEY)
            {
                hide();
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                if (llGetPermissionsKey() != NULL_KEY) 
                    llStopAnimation(ANIMATION);
                    llSetTimerEvent(0);
                if(masterswitch == TRUE)
                {
                    //llSetAlpha(base_alpha,ALL_SIDES);
                    llSetText(TITLE,<1,1,1>,1);
                }
            }
        }
        
        if(change == CHANGED_INVENTORY)
        {
            llSetText("Reloading configuration...",<1,1,1>,1);
            init();
        }
    }
    
    run_time_permissions(integer perm)
    {
        if(perm == PERMISSION_TRIGGER_ANIMATION)
        {
            llStopAnimation("sit");
            llStartAnimation(ANIMATION);
            if(visible == TRUE)
                base_alpha = llGetAlpha(ALL_SIDES);
            else
                base_alpha = 1.0;
            //llSetAlpha(0.0,ALL_SIDES);
            //llSetText("",<1,1,1>,1);
            llSetTimerEvent(5);
            }
        }

timer() 
{
    llSay(0,"Debug Line"); //debug line
llRezObject("<ACS>Stamina", llGetPos() + <0, 0, 2>, ZERO_VECTOR, ZERO_ROTATION, 42);
}
    listen(integer channel, string name, key id, string message)
    {
        if(llStringLength(message)!=4)
            return;
        
        message = llToLower(message);
        
        if(message == "show")
        {
            show();
            return;
        }
        if(message == "hide")
            hide();
    }
    
    dataserver(key queryid, string data)
    {
        if(queryid != dataserver_key)
            return;
        
        if(data != EOF)
        {
            if(llGetSubString(data,0,0) != ";")
            {
                if(llGetSubString(data,0,5) == "title:")
                {
                    TITLE = llGetSubString(data,7,-1);
                    next_line();
                    return;
                }
                if(llGetSubString(data,0,6) == "offset:")
                {
                    integer length = llStringLength(data);
                    if(llGetSubString(data,8,8) != "<" || llGetSubString(data,length - 1,length) != ">")
                    {
                        llSay(0,"Error: The numbers in the offset value lack the '<' and '>' signs. (Should be something like <3,1,6> )");
                        offset = <0,0,0.5>;
                    }
                    else
                        offset = (vector)llGetSubString(data,8,-1);
                    
                    if(offset == <0,0,0>)
                        offset = <0,0,0.01>;
                    llSitTarget(offset,ZERO_ROTATION);
                    next_line();
                    return;
                }
                if(llGetSubString(data,0,5) == "voice:")
                {
                    string value = llGetSubString(data,7,-1);
                    value = llToLower(value);
                
                    if(listenHandle != -1)
                    {
                        llListenRemove(listenHandle);
                        listenHandle = -1;
                    }
                    
                    if(value !="no" && value != "yes" && value != "true" && value != "false")
                        use_voice = FALSE;
                    else
                        if(value == "no" || value == "false")
                            use_voice = FALSE;
                        else
                        {
                            use_voice = TRUE;
                            listenHandle = llListen(1,"","","");
                        }
                    next_line();
                    return;
                }
                if(llGetSubString(data,0,10) == "sit_button:")
                {
                    llSetSitText(llGetSubString(data,12,-1));
                    next_line();
                    return;
                }
                next_line();
            }
        }
        else
        {
            if(visible == FALSE)
                llSetText("",<1,1,1>,1);
            else
                llSetText(TITLE,<1,1,1>,1);
        }
    }
}