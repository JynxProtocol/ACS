integer sf_update = 1176678;                        //key to secure the link message
string Title;                                       //Title the owner has chosen
string Race;                                        //Race the owner has chosen
string Alignment;                                   //Allignment the owner has chosen
string color;
string text;
key OWNER_KEY;

default
 {
    state_entry() 
    {
        OWNER_KEY=llGetOwner();
        color = "<1.0, 1.0, 1.0>";       // We want a white meter for starters
    }   
    
    // receive the actual status from the core script and transform it into 
    // readable information that is displayed as floating text above the meter
    link_message(integer sender_number, integer number, string message, key id)
    {
        // check if it's a valid update and not some rubbish from hacked items
        if(number == sf_update)
        {
            //string color = "<1.0, 1.0, 1.0>";       // We want a white meter for starters
            llSetText(Title + "\n } ACS 2{ "+ 
                      message, 
                      (vector)color, 1.0);
                      text=message;
        }
        else if(number==500){
            string mesg;
            mesg = llToLower(message);
            //if(chan == 1)
            //{
            if(llGetOwnerKey(id) == OWNER_KEY)
            {
                if(llGetSubString(mesg, 0, 5) == "title ")
                {
                    //llSay(0,"title debug");
                    Title = llGetSubString(message, 6, -1);
                    if(llToLower(Title) == "none")
                    {
                        Title = "";
        
                    }
                llSetText(Title + "\n } ACS 2{ "+ 
                          text, 
                          (vector)color, 1.0);
                }
                //else
                else if(llGetSubString(mesg, 0, 5) == "color ")
                {
                    color = llGetSubString(message, 6, -1);
                llSetText(Title + "\n } ACS 2{ "+ 
                          text, 
                          (vector)color, 1.0);
                }
              
            }
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }
}