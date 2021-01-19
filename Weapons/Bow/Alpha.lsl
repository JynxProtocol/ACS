default
{
    // Waits for another script to send a link message
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if (msg ==  "hide") {
            llSetAlpha(0.0, ALL_SIDES);
        } else if (msg == "show") {
            llSetAlpha(1.0, ALL_SIDES);
        }
    }
}