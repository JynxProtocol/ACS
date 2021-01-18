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

string name="Small Healing";
integer acsChannel = -5824134;
string damage="atceaeda04";

default
{
    state_entry()
    {
        llVolumeDetect(TRUE);   
    }
    collision_start(integer num_detected)
    {

        llRegionSayTo(llDetectedKey(0), acsChannel, encrypt(damage));

    }
    

}
