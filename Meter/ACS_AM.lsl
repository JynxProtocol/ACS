//Draft Armour Script
//Requires Armor Types to calculate Stamina Drain
//Stamin Drain to be Added
//Armour was never implmented

////////////Encryption Start//////////
//string feed="Alpha Testing Only";
string feed="PutYourEncryptionKeyHere";
 
string encrypt(string text)
{
    text = llXorBase64StringsCorrect(llStringToBase64(text),llStringToBase64(pseudo_random(feed,0,4)));
    return text;
}
 
string decrypt(string text){

    text = llXorBase64StringsCorrect(text,llStringToBase64(pseudo_random(feed,0,4)));
    return llBase64ToString(text);
}

string pseudo_random(string text,  integer start, integer end)
{
    integer nonce=300 * ((integer)llGetGMTclock() / 300); //nonce changes every 5 minutes so if its decrypted its useless soon
    return llGetSubString(llMD5String(text, nonce), start, end);
}
///////////Encryption End//////////////

integer acsChannel = -5824134;              

integer sf_update = 1176678;                


string TYPE_OWNER = "athp";         


integer SOURCE_LISTEN   =   1;
integer SOURCE_SF   =   3;    

string EF_ARMOR_ON="amfm";
string EF_ARMOR_OFF="amsp";
          

key OWNER_KEY;   

      


ACSCommand( string cmd, integer source, key owner)
{
    //llSay(0,"ACSCMD:"+cmd);
    string type = llGetSubString( cmd, 0, 3);               
    string effect = llGetSubString( cmd, 4, 7);             
    integer Amount = (integer)llGetSubString( cmd, 8, 9);   
    if (type != TYPE_OWNER)  //&& 
        //type != TYPE_AREA && 
        //type != TYPE_PHYSICAL &&
        //type != TYPE_EVERYONE) 
    {
        return;             
    }
    
    else if (owner != OWNER_KEY && type == TYPE_OWNER ) 
    {
        return;
    }
     
    llMessageLinked(LINK_THIS, Amount, effect,"HIT"); 


} 

default
{
    attach( key id )
    {
        
        if( ( id != NULL_KEY ) && ( id != OWNER_KEY ) )
        {
            llResetScript();
        }
    }
    
    state_entry()
    {      
        OWNER_KEY = llGetOwner();
    }    
    
    link_message(integer sender_number, integer number, string message, key id)
    {
       if (number == 10) 
       { 
            ACSCommand( message, SOURCE_SF, llGetOwnerKey( id ));  
       }
       else if(number == 500){
            ACSCommand( decrypt(message), SOURCE_LISTEN, llGetOwnerKey( id ));    
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
    
