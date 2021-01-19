////////////Encryption Start//////////
string feed="PutYourEncryptionKeyHere";
 
string encrypt(string text)
{
    text = llXorBase64StringsCorrect(llStringToBase64(text),llStringToBase64(pseudo_random(feed,0,4)));
    return text;
}


string pseudo_random(string text,  integer start, integer end)
{
    integer nonce=300 * ((integer)llGetGMTclock() / 300); //nonce changes every 5 minutes so if its decrypted its useless soon
    return llGetSubString(llMD5String(text, nonce), start, end);
}
///////////Encryption End//////////////


integer             iOwnerOnly  = TRUE;

string ReloadPrim = "atcoahxl10";
default
{
    collision_start(integer total_number)
    {
        string what = llDetectedName(0);
              if (llDetectedType(0) & AGENT)
    { 
            //Test here to see if we are OWNER ONLY
            if (iOwnerOnly && llDetectedKey(0) != llGetOwner()) { return;}
            string x = llKey2Name(llDetectedKey(0));
            string what = llDetectedKey(0);
            //llSay(-5824134,"atcoahxl10");
            llSetObjectName(encrypt(ReloadPrim));
            //llSay(0, "debug"); Debug Line
            llSleep(5);
    }
}
}