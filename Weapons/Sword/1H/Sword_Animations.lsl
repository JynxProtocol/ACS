// Place 5 Animations into the root prim
// Replace the default animations inside the ""s with the names of your animations.
// Save the script.
// Wear or Re-Wear the Item.

string rsa = "basic_ready";      // Ready Stance Animation
string faa = "basic_sup";             // Forward Attack Animation
string baa = "basic_sdown";      // Back Attack Animation
string laa = "basic_sleft";           // Left Attack Animation
string raa = "basic_sright";             // Right Attack Animation


//  DO NOT MODIFY ANYTHING BELOW THIS LINE  //
//------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
        if (str == "startbackattack")  {llStartAnimation(baa);}
        if (str == "startreadystance")  {llStartAnimation(rsa);} 
        if (str == "stopreadystance")  {llStopAnimation(rsa);}
    }
}
