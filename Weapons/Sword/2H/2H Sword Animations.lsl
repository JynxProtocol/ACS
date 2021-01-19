// Place 4 Animations into the inventory contents.
// Replace the default animations inside the ""s with the names of your animations.
// Save the script.
// Wear or Re-Wear the Item.

string rsa = "basic_ready";      // Ready Stance Animation
string faa = "basic_sup";             // Forward Attack Animation
string laa = "basic_sleft";           // Left Attack Animation
string raa = "basic_sright";             // Right Attack Animation


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
        if (str == "startforwardattack")  {llStartAnimation(faa);}
        if (str == "startleftattack")  {llStartAnimation(laa);}
        if (str == "startrightattack")  {llStartAnimation(raa);}
        if (str == "startreadystance")  {llStartAnimation(rsa);}
        
        if (str == "stopreadystance")  {llStopAnimation(rsv);}
    }
}
