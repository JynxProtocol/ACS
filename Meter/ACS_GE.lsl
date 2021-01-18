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
//////////////////////////////////////////////////////////////////////
//V0.2
// Avilion Combat System - Group effects
// 
// Created by Atzel Congrejo
// 
key OWNER_KEY;                  // Av key of the meter's owner
integer Amount;                 // Amount the detected effect is going to deal
string newCommand = "";
integer Team;
integer acsChannel = -5824134;    

integer intREDChannel = -100001;
integer intBLUEChannel = -100002;
integer intYELLOWChannel = -100003;
integer intWHITEChannel = -100004;
integer intPINKChannel = -100005;
integer intGREENChannel = -100006;
integer intTEALChannel = -100007;
string color = "<1,0,0>";
//string color;

RemoveAllListeners()
{
    llListenRemove(llListen(intREDChannel,"","",""));    
    llListenRemove(llListen(intBLUEChannel,"","",""));
    llListenRemove(llListen(intYELLOWChannel,"","",""));
    llListenRemove(llListen(intWHITEChannel,"","",""));
    llListenRemove(llListen(intPINKChannel,"","",""));
    llListenRemove(llListen(intGREENChannel,"","",""));
    llListenRemove(llListen(intTEALChannel,"","",""));
}


MoveTarget(vector Pos) //Userfunc
{
    do //Do-while loop.
    {
        llPushObject(OWNER_KEY,(Pos-llGetPos())*(llVecDist(llGetPos(),Pos)),ZERO_VECTOR,FALSE); //Pushes the avatar to the position.
        llMoveToTarget(Pos,0.05); //If your agent gets close to the avatar it will direct the path.
    }
    while(llVecDist(Pos,llGetPos()) > 40.0); //End of do-while loop.
    llMoveToTarget(Pos,0.05); //Movement
    llSleep(0.25); //Prevents you from flying.
    llStopMoveToTarget(); //Stops the movement
}

string zero_pad(integer number)
{
    if (number < 10) return "0" + (string)number;
    else return (string)number;
}
// Called from a listen or collision_start event. 
AnalyseCommand( string cmd, key owner )
{
    if(llGetSubString(cmd, 0, 5) == "color " && owner==OWNER_KEY)
    {
        color = llGetSubString(cmd, 6, -1);
        if( color == "<1.00000, 0.00000, 0.00000>") 
        {
            Team = 1;
        }
        else if( color == "<0.00000, 0.00000, 1.00000>") 
        {
            Team = 2;
        }
        else if( color == "<1.00000, 1.00000, 0.00000>") 
        {
            Team = 3;
        }
        else if( color == "<1.00000, 1.00000, 1.00000>") 
        {
            Team = 4;
        }
        else if( color == "<1.00000, 0.00000, 1.00000>") 
        {
            Team = 5;
        }
        else if( color == "<0.00000, 1.00000, 0.00000>") 
        {
            Team = 6;
        }
        else  if( color == "<0.00000, 1.00000, 1.00000>") 
        {
            Team = 7;
        }
        
    }
    else if(cmd=="atcsrqst") //requesting the colour of the meter
    {
        llRegionSay(acsChannel,"atcsteam0"+(string)Team);
    }
    else
    {
        string type = llGetSubString( cmd, 0, 3);               // first 4 digits of the command = type
        if (type != "acrd" && type != "acbu" && type != "acyw" && type != "acwt" && type != "acpk" && type != "acgn" && type!="actl") 
        {
            return;        
        }
        else
        {
            SFCommand(cmd, owner);
        }
    }
}

SFCommand( string cmd, key owner )
{

    string type = llGetSubString( cmd, 0, 3);               // first 4 digits of the command = type
    string effect = llGetSubString( cmd, 4, 7);             // digit 5 to 8 = effect
    integer Amount = (integer)llGetSubString( cmd, 8, 9);   // and last 2 digits are the amount
    

    if(type == "acrd" && Team == 1)
    {
        newCommand = "atce" + effect + zero_pad(Amount);             // add the detected amount
        llMessageLinked(LINK_THIS, 10, newCommand, owner);      // send the translated command to the ACS core for further calculation
        newCommand = "";
        //llOwnerSay("debug "+newCommand);
    }
    else if(type == "acbu" && Team == 2)
    {
        newCommand = "atce" + effect + zero_pad(Amount);             // add the detected amount
        llMessageLinked(LINK_THIS, 10, newCommand, owner);      // send the translated command to the ACS core for further calculation
        newCommand = "";
    }
    else if(type == "acyw" && Team == 3)
    {
        newCommand = "atce" + effect + zero_pad(Amount);            // add the detected amount
        llMessageLinked(LINK_THIS, 10, newCommand, owner);      // send the translated command to the ACS core for further calculation
        newCommand = "";
    }
    else if(type == "acwt" && Team == 4)
    {
        newCommand = "atce" + effect + zero_pad(Amount);             // add the detected amount
        llMessageLinked(LINK_THIS, 10, newCommand, owner);      // send the translated command to the ACS core for further calculation
        newCommand = "";
    }
    else if(type == "acpk" && Team == 5)
    {
        newCommand = "atce" + effect + zero_pad(Amount);           // add the detected amount
        llMessageLinked(LINK_THIS, 10, newCommand, owner);      // send the translated command to the ACS core for further calculation
        newCommand = "";
    }
    else if(type == "acgn" && Team == 6)
    {
        newCommand = "atce" + effect + zero_pad(Amount);            // add the detected amount
        llMessageLinked(LINK_THIS, 10, newCommand, owner);      // send the translated command to the ACS core for further calculation
        newCommand = "";
    } 
    else if(type == "actl" && Team == 7)
    {
        newCommand = "atce" + effect + zero_pad(Amount);            // add the detected amount
        llMessageLinked(LINK_THIS, 10, newCommand, owner);      // send the translated command to the ACS core for further calculation
        newCommand = "";
    }     
}
// Translates the effect, after checking it against the max allowed values for the effect.

default
{
    attach( key id )
    {
        if( ( id != NULL_KEY ) && ( id != OWNER_KEY ) )
        {
            llResetScript();
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }

    state_entry()
    {
        Team = 4; // standard is white
        OWNER_KEY = llGetOwner();                               // check out hte owner
    }

    listen( integer chan, string name, key id, string msg )
    {
        
        vector TempPos = (vector)msg; 
        if(TempPos!=ZERO_VECTOR)
        {           
            RemoveAllListeners();            
            MoveTarget(TempPos);
        }  
        
    }
    
    link_message(integer sender_number, integer number, string message, key id)
    {
        if(number == 45 && message == "dead")
        {
            if( Team == 1 )
            {
                llListen(intREDChannel,"","","");
                llSleep(0.1);
                llRegionSay(intREDChannel, "MOVEDEAD");
            }
            else if( Team == 2 ) 
            {
                llListen(intBLUEChannel,"","","");
                llSleep(0.1);
                llRegionSay(intBLUEChannel, "MOVEDEAD");
            }
            else if( Team == 3 ) 
            {
                llListen(intYELLOWChannel,"","","");
                llSleep(0.1);
                llRegionSay(intYELLOWChannel, "MOVEDEAD");
            }
            else if( Team == 4 ) 
            {
                llListen(intWHITEChannel,"","","");
                llSleep(0.1);
                llRegionSay(intWHITEChannel, "MOVEDEAD");
            }
            else if( Team == 5 ) 
            {
                llListen(intPINKChannel,"","","");
                llSleep(0.1);
                llRegionSay(intPINKChannel, "MOVEDEAD");
            }
            else if( Team == 6 ) 
            {
                llListen(intGREENChannel,"","","");
                llSleep(0.1);
                llRegionSay(intGREENChannel, "MOVEDEAD");
            }
            else if( Team == 7 ) 
            {
                llListen(intTEALChannel,"","","");
                llSleep(0.1);
                llRegionSay(intTEALChannel, "MOVEDEAD");
            }

        }
        else if(number==15 && (message=="reset" || message=="alive"))
        {
            RemoveAllListeners();
        }
        else if(number==500){
            string mesg;
            string decode;
            decode = (decrypt(message)) ;           
            mesg = llToLower(decode);
            //llSay(0,"Decode:"+decode);
            AnalyseCommand( mesg, llGetOwnerKey( id ) );
        } 
    }

}