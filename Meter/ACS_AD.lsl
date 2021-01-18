//Stores cooldown timers for spells. 
//Storing is done by the category of spell.
//Request the last cooldown time  with command atccWARD00
//Update the last cooldown time with command atccWARD99
//stores time with llGetUnixTime


list CD_CAT=["WARD","AURA","CHWD","ICWL","RASD","CRPN","WOFT","NTRG","TOFL","RBTH","TDRS","TNDO"];//letter codes for the spell/category
list curCD=[0,0];//stores unixtime of last used spell
integer acsChannel=-5824134;//channel for acs commands

default
{
        changed(integer change)
        {
                if(change&CHANGED_OWNER)
                {
                        llResetScript();
                }
        }
        state_entry()
        {
                llListen(acsChannel,"",NULL_KEY,"");
        }
        link_message(integer sender_number, integer number, string msg, key id)
        {
            if(number==500){
                if(llGetOwnerKey(id)==llGetOwner())
                {
                        string command=llGetSubString(msg,0,3);
                        string spell=llGetSubString(msg,4,7);
                        string num=llGetSubString(msg, 8,-1);
                        if(command=="atcc")
                        {
                            integer index=llListFindList(CD_CAT,[spell]);
                            if(index!=-1)
                            {
                                
                                if(num=="00")
                                {
                                    llWhisper(acsChannel,"atcc"+llList2String(CD_CAT,index)+llList2String(curCD,index));
                                }
                                else if(num=="99")
                                {
                                    
                                    curCD=llListReplaceList(curCD,[(string)llGetUnixTime()],index,index);
                                    
                                }
                            }
                                
                        }
                }
            }
        }

}