// Place 2 Animations into the inventory contents.
// Replace the default animations inside the ""s with the names of your animations.
// Change UseAnimations to integer UseAnimations = TRUE;

// Save the script.
// Wear or Re-Wear the Item.

integer UseAnimations = TRUE;

string rsv = ")<SF>( Dagger Sheath";      // Ready Stance Animation
string fav = ")<SF>( Dagger Draw";             // Forward Attack Animation






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
        if (UseAnimations==TRUE)
        {
        if (str == "draw")  {llStartAnimation(fav);}
        if (str == "sheath")  {llStartAnimation(rsv);}
        
    }
}
}
