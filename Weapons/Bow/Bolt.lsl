
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


string  snd_hit = "d4eb4f5d-e93c-3800-579f-2beef5a6b476";       // The Sound to play when the arrow hits.
float   TIMEOUT = 3.0;                                          // The timeout for which to wait before auto-deleting itself when hit.

string AttackPrim = "atcsaebl08";

default
{
    state_entry()
    {
        // This buyoancy value sets the arrow's general weight to allow for physical weight. 
        // The lower this number is from 1.0, the faster it will sink.
        // Please make sure you test your projectiles carefully when changing this value.
        llSetBuoyancy(0.10);
        llCollisionSound(snd_hit, 1);
        llCollisionSprite("");
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }

    on_rez(integer rezzed)
    {
        if (rezzed) {
            llSetObjectName(encrypt(AttackPrim));
            llSetTimerEvent(20);
        } else {
            llSetPrimitiveParams([PRIM_PHYSICS, FALSE, PRIM_PHANTOM, TRUE]);
        }
    }
    
    collision_start(integer detected)
    {
        llSetPrimitiveParams([PRIM_PHYSICS, FALSE, PRIM_PHANTOM, TRUE]);
        llDie();
    }
    
    land_collision_start(vector pos)
    {
        llSetPrimitiveParams([PRIM_PHYSICS, FALSE, PRIM_PHANTOM, TRUE]);
        llSleep(TIMEOUT);
        llDie();
    }
    
    timer()
    {
        llDie();
    }
}
