////////////Encryption Start//////////
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


string TYPE_OWNER = "atco";         
string TYPE_PHYSICAL = "atcs";      
string TYPE_AREA = "atca";    
string TYPE_EVERYONE="atce";  

integer SOURCE_LISTEN   =   1;
integer SOURCE_COLLISION=   2;
integer SOURCE_SF   =   3;    

string EF_NDAM = "aeda";
string EF_NSDAM = "asda";
string EF_SNDAM = "sada";  
string EF_BLEEDDOT = "aebl";         
string EF_DOTFIRE = "aefi";         
string EF_DOTPOISON = "aepo";       
string EF_SDAM = "aesd";            
string EF_FOOD_D = "fdmg";          
string EF_MANA_D = "mdmg";          
string EF_NHEAL = "aehe";  
string EF_NHEALDOT = "aehd";         
string EF_SHEAL = "aesh";           
string EF_FOOD = "aefo";            
string EF_MANA_H = "mhxl";          
string EF_NAIR_H = "aeue";          
string EF_RES = "aere";             
string EF_MANA_M = "mtfm";          
string EF_MANA_W = "gmsp";          
string EF_COMMAND = "atcs";         
string EF_RESET ="rset";  

string EF_SILENCE="slnc";
string EF_STUN="stun";
string EF_BIND="bind";
string EF_SLOW="slow";

//string EF_ARMOR_ON="amfm";
//string EF_ARMOR_OFF="amsp";
          

key OWNER_KEY;   

      


ACSCommand( string cmd, integer source, key owner)
{
    //llSay(0,"ACSCMD:"+cmd);
    string type = llGetSubString( cmd, 0, 3);               
    string effect = llGetSubString( cmd, 4, 7);             
    integer Amount = (integer)llGetSubString( cmd, 8, 9);   
    if (type != TYPE_OWNER  && 
        type != TYPE_AREA && 
        type != TYPE_PHYSICAL &&
        type != TYPE_EVERYONE) 
    {
        return;             
    }
    
    else if (owner == OWNER_KEY && type == TYPE_AREA) 
    {
        
        return;
        
    }
    else if (owner == OWNER_KEY && (type == TYPE_OWNER || type == TYPE_EVERYONE))
    {
        if (effect == EF_RES)
        {
            return;
        }
    }
    else if (owner == OWNER_KEY && type == TYPE_PHYSICAL ) 
    {
        return;
    }
    else if (owner != OWNER_KEY && type == TYPE_OWNER ) 
    {
        return;
    }
    else if(type==TYPE_PHYSICAL && source!=SOURCE_COLLISION && source !=SOURCE_SF)
    {
        return;
    }
    else if(type==TYPE_AREA && source!=SOURCE_LISTEN && source !=SOURCE_SF)
    {
        return;
    }
     
    llMessageLinked(LINK_THIS, Amount, effect,"HIT");
    //llOwnerSay("Debug:"+(string)Amount+effect); 


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
    
    collision_start(integer num_detected)
    {
        if(llDetectedType(0) & ACTIVE){
            ACSCommand( decrypt(llDetectedName( 0 )), SOURCE_COLLISION, llDetectedOwner( 0 ));
        }        
        
    }
    
    collision(integer num_detected)
    {
         if(llDetectedType(0) & PASSIVE){
            ACSCommand( decrypt(llDetectedName( 0 )), SOURCE_COLLISION, llDetectedOwner( 0 ));
        }   
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
    
