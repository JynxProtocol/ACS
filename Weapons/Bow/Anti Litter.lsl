string ownerName;
integer CHANNEL = 42; // dialog channel
//integer CHANNEL = 0; // dialog channel
list MENU_MAIN = ["OK"]; // the main menu
list TEXT_MAIN = ["ON", "OFF"]; // the main menu

integer hChannel    = -22360;
integer aChannel    = -322360;
float time = 5400; // timer interval
default
{
    on_rez(integer rezzed)
    {   
        //llResetScript();
    llDialog(llGetOwner(), "This Reloader will Self Destruct in 90 minutes\nIf you finish using it before the 90 minutes please use the Clean Reloaders from the Hud", MENU_MAIN, CHANNEL); // present dialog on click
    llSetTimerEvent(0.0);
    llSetTimerEvent(time);
    //llSay(0, "I will self destruct in 60 minutes");
    }

    state_entry()
    {
    //llSay(0, "I will self destruct in 60 minutes");

    //llListen(hChannel,"",llGetOwner(),""); 
    llListen(hChannel, "", NULL_KEY, "" );
    llListen(aChannel, "", NULL_KEY, "" );
    llListen(CHANNEL,"","","");
    }
    
        touch_start(integer total_number)
    {
        llDialog(llGetOwner(), "Hover Text", TEXT_MAIN, CHANNEL); // present dialog on click
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        {
            string x = (llGetOwner());
            ownerName = llKey2Name(x);
            //if (msg == x+"BlinkingLitterBugs")
             //{
                //llDie();
                
                
                //if (channel == CHANNEL)
        //{
            if (msg == x+"BlinkingLitterBugs")
            {
               
                llDie();
                //llSay(0,"Die Debug line");
            }
            else if(msg == "ON")
            {
                
                llSetText(ownerName+"\n<DD>Multi Bow Reloader", <1,1,1>, 1.5);
                //llSay(0,"On Debug Line");
            }
            else if(msg == "OFF")
            {
                llSetText("", <1,1,1>, 1.5);
                //llSay(0,"Off Debug Line");
            }

 
            }
        }
    //}
    
        timer()
    {
     llDie();   
    } 
}
