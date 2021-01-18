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

string name="Small Poison";
string damage="atceaesd04";

default
{
    
    collision_start(integer num_detected)
    {
        if(num_detected==1)
            name=llGetObjectName();
        llSetObjectName(encrypt(damage));
        llSleep(0.1);
        llSetObjectName(name);
        llSetTimerEvent(1.0);
    }
    collision_end(integer num_detected)
    {
        if(num_detected==1)
        llSetTimerEvent(0.0);
    }
    timer()
    {
        llSetObjectName(encrypt(damage));
        llSleep(0.1);
        llSetObjectName(name);
    }

}
