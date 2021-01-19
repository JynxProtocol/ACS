// Place 5 Animations into the inventory contents.
// Replace the default animations inside the ""s with the names of your animations.
// Save the script.
// Wear or Re-Wear the Item.

string rsv = "basic_ready";      // Ready Stance Animation
string fav = "basic_sup";             // Forward Attack Animation
string bav = "basic_sdown";      // Back Attack Animation
string lav = "basic_sleft";           // Left Attack Animation
string rav = "basic_sright";             // Right Attack Animation


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
