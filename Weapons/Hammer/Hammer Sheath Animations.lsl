// Place 2 Animations into the inventory contents.
// Replace the default animations inside the ""s with the names of your animations.
// Change UseAnimations to integer UseAnimations = TRUE;

// Save the script.
// Wear or Re-Wear the Item.

integer UseAnimations = FALSE;

string rsv = ")<SF>( Sword Sheath";      // Ready Stance Animation
string fav = ")<SF>( Sword Draw";             // Forward Attack Animation






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
        if (str == "hammer draw")  {llStartAnimation(fav);}
        if (str == "hammer sheath")  {llStartAnimation(rsv);}
        
    }
}
}
