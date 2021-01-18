integer listen_handle;
integer acsChannel = -5824134;

// String
string result;
string type;
string effect;

key OWNER_KEY;


default
{
    state_entry()
    {
         listen_handle = llListen(acsChannel,"","","");

    }

    listen(integer chan, string name, key id, string msg)
    {    
        //OWNER_KEY = llGetOwnerKey(id);
        result = llGetSubString(msg, 0, 1);
        type = llGetSubString(msg, 2, 5);
        effect = llGetSubString(msg, 6, 9);
        if(chan == acsChannel)
        {
            llMessageLinked(LINK_THIS, 500,msg,id);                           
                    
            if (llGetOwnerKey(id) == llGetOwner())
            //if ( id == OWNER_KEY );
            {
                if (type == "sfco") 
                {
                    if( effect == "race" )
                    {
                        //Race = llGetSubString( cmd, 10, -1 );
                    }
                    else if( effect == "colo" )
                    {
                        //Color = llList2Vector( Colors, Amount );
                    }
                    else if( effect == "alig" )
                    {    
                        //Alignment = llList2String( Align, Amount );
                    }
                    else if( effect == "titl" )
                    {
                        //Title = llGetSubString( cmd, 10, -1 );
                    }
                    else if(effect == "snds" )
                    {
                        if(result=="00")
                        {
                            llMessageLinked(LINK_ALL_OTHERS,45,"soundset","NONE");
                        }
                        else if(result=="01")
                        {
                            llMessageLinked(LINK_ALL_OTHERS,45,"soundset","MORC");
                        }
                        else if(result=="02")
                        {
                            llMessageLinked(LINK_ALL_OTHERS,45,"soundset","FORC");
                        }
                        else if(result=="03")
                        {
                            llMessageLinked(LINK_ALL_OTHERS,45,"soundset","MHUMAN");
                        }
                        else if(result=="04")
                        {
                            llMessageLinked(LINK_ALL_OTHERS,45,"soundset","FHUMAN");
                        }
                        else if(result=="05")
                        {
                            llMessageLinked(LINK_ALL_OTHERS,45,"soundset","MIMP");
                        }
                        else if(result=="06")
                        {
                            llMessageLinked(LINK_ALL_OTHERS,45,"soundset","FIMP");
                        }
                        
                    //
                    }
                    else if( effect == "rset" )
                    {
                        llShout(0,llKey2Name( llGetOwner() ) + " Has Reset Their Meter" );
                        llMessageLinked(LINK_THIS, 15, "reset", NULL_KEY);
                        llResetOtherScript("ACS");
                    }
                    else if( effect == "tmfm" )
                    {
                        llMessageLinked(LINK_THIS, 15, effect,"HIT");
                    }
                    else if( effect == "tmsp" )
                    {
                        llMessageLinked(LINK_THIS, 15, effect,"HIT");
                        
                    }
                    
                        
                }
            }
        }
    }
}


