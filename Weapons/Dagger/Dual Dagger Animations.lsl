// Place 5 Animations into the inventory contents.
// Replace the default animations inside the ""s with the names of your animations.
// Save the script.
// Wear or Re-Wear the Item.

string rsv = ")<SF>(  Dagger Ready Stance";      // Ready Stance Animation
string fav = ")<SF>(  Dagger Forward Attack";             // Forward Attack Animation
string bav = ")<SF>(  Dagger Block";      // Back Attack Animation
string lav = ")<SF>(  Dagger Left Attack";           // Left Attack Animation
string rav = ")<SF>(  Dagger Right Attack";             // Right Attack Animation


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
        if (str == "startbackattack")  {llStartAnimation(bav);}
        if (str == "startreadystance")  {llStartAnimation(rsv);}
        
        if (str == "stopreadystance")  {llStopAnimation(rsv);}
    }
}
