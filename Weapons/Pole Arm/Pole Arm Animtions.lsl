// Place 4 Animations into the inventory contents.
// Replace the default animations inside the ""s with the names of your animations.
// Save the script.
// Wear or Re-Wear the Item.

string rsv = ")<SF>(  Polearn Ready Stance";      // Ready Stance Animation
string fav = ")<SF>(  Polearm Forward Thrust";             // Forward Attack Animation
string lav = ")<SF>(  Polearm Left Attack";           // Left Attack Animation
string rav = ")<SF>(  Polearm Right Attack";             // Right Attack Animation
string bav = ")<SF>(  Polearm Block";             // Block


    //  DO NOT MODIFY ANYTHING BELOW THIS LINE  //
// _____________________________________________________________________________ //


default
{

attach(key on)
       {
        if (on != NULL_KEY)
        {
            integer perm = llGetPermissions();
            
            if (perm != (PERMISSION_TRIGGER_ANIMATION))
            {
                llRequestPermissions(on, PERMISSION_TRIGGER_ANIMATION);
            }
        }
        else
        {
            llResetScript();
        }
    } 
    
    link_message (integer link_num, integer num, string str, key id)
    {
        if (str == "startforwardattack")  {llStartAnimation(fav);}
        if (str == "startleftattack")  {llStartAnimation(lav);}
        if (str == "startrightattack")  {llStartAnimation(rav);}
        if (str == "startblock")  {llStartAnimation(bav);}
        if (str == "startreadystance")  {llStartAnimation(rsv);}

        
        if (str == "stopreadystance")  {llStopAnimation(rsv);}
    }
}
