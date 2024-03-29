string AttackPrim = "atcsaeda06";
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

string Texture;
integer Interpolate_Scale;
vector Start_Scale;
vector End_Scale;
integer Interpolate_Colour;
vector Start_Colour;
vector End_Colour;
float Start_Alpha;
float End_Alpha;
integer Emissive;
float Age;
float Rate;
integer Count;
float Life;
integer Pattern;
float Radius;
float Begin_Angle;
float End_Angle;
vector Omega;
integer Follow_Source;
integer Follow_Velocity;
integer Wind;
integer Bounce;
float Minimum_Speed;
float Maximum_Speed;
vector Acceleration;
integer Target;
key Target_Key;


// BASIC FUNCTION ==============================

Particle_System ()
{
list Parameters = 
[
PSYS_PART_FLAGS,
(
(Emissive * PSYS_PART_EMISSIVE_MASK) |
(Bounce * PSYS_PART_BOUNCE_MASK) |
(Interpolate_Colour * PSYS_PART_INTERP_COLOR_MASK) |
(Interpolate_Scale * PSYS_PART_INTERP_SCALE_MASK) |
(Wind * PSYS_PART_WIND_MASK) |
(Follow_Source * PSYS_PART_FOLLOW_SRC_MASK) |
(Follow_Velocity * PSYS_PART_FOLLOW_VELOCITY_MASK) |
(Target * PSYS_PART_TARGET_POS_MASK)
),
PSYS_PART_START_COLOR, Start_Colour,
PSYS_PART_END_COLOR, End_Colour,
PSYS_PART_START_ALPHA, Start_Alpha,
PSYS_PART_END_ALPHA, End_Alpha,
PSYS_PART_START_SCALE, Start_Scale,
PSYS_PART_END_SCALE, End_Scale,
PSYS_SRC_PATTERN, Pattern,
PSYS_SRC_BURST_PART_COUNT, Count,
PSYS_SRC_BURST_RATE, Rate,
PSYS_PART_MAX_AGE, Age,
PSYS_SRC_ACCEL, Acceleration,
PSYS_SRC_BURST_RADIUS, Radius,
PSYS_SRC_BURST_SPEED_MIN, Minimum_Speed,
PSYS_SRC_BURST_SPEED_MAX, Maximum_Speed,
PSYS_SRC_TARGET_KEY, Target_Key,
PSYS_SRC_ANGLE_BEGIN, Begin_Angle,
PSYS_SRC_ANGLE_END, End_Angle,
PSYS_SRC_OMEGA, Omega,
PSYS_SRC_MAX_AGE, Life,
PSYS_SRC_TEXTURE, Texture
];
llParticleSystem (Parameters);

}



Sparks (){
Texture = "e1559baf-dbcf-3bbc-5107-77c2b6661f86";
Interpolate_Scale = TRUE;
Start_Scale = <0.13,0.13, 0>;
End_Scale = <0.04,0.04, 0>;
Interpolate_Colour = FALSE;
Start_Colour = < 1, 1, 0 >;
End_Colour = < 1, 1, 0 >;
Start_Alpha = 0.8;
End_Alpha =0.8;
Emissive = TRUE;
Age = 1.3;
Rate = 0.3;
Count = 10;
Life = 0;
Pattern = PSYS_SRC_PATTERN_EXPLODE;
Radius = 0;
Begin_Angle = 0;
End_Angle = 3.14159;
Omega = < 0, 0, 0 >;
Follow_Source = TRUE;
Follow_Velocity = FALSE;
Wind = FALSE;
Bounce = FALSE;
Minimum_Speed = 0.3;
Maximum_Speed = 0.4;
Acceleration = < 0, 0, -0.1 >;
Target = FALSE;
Target_Key = NULL_KEY;

Particle_System ();
}

//PARTICLE FUNCTIONS END


default
{
    state_entry()
    {
    llSetObjectName(encrypt(AttackPrim));
    llCollisionSprite("");
    llParticleSystem ([]);
    llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }
        on_rez(integer start_param)
    {
        llSetObjectName(encrypt(AttackPrim));
        llParticleSystem ([]);
        llSetTimerEvent(0.11);
    }
    //collision_end(integer total_number)
     collision_start(integer total_number)
    {
        Sparks();
        
        llTriggerSound("107e6046-89ef-954f-c160-86fe9588bca0",1.0);
        llDie();
    }
    timer()
    {
       llDie();
    }
}
