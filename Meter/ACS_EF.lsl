// ******************* Sounds 

string ssound = "a0d467f5-f852-b9cc-fb5d-e40cacd5f9cf"; //Start Up Sound
//string dsound = "0959db8f-6518-2a18-6537-98e2c3f2fb12"; //Damage Sound Male
//string hsound = "f2ea51ec-17ef-73fe-b13e-e1cb8462b1fc"; //Heal Sound Male
//string fsound = "2278c284-d92a-5084-360f-619d43cc07e0"; //Falling Damage Male
//string fisound = "2278c284-d92a-5084-360f-619d43cc07e0"; //Fire Damage Male
string usound = "3c9430b1-9525-ea52-bd66-405d7ef72f42"; //Uncon Sound Male

list mOrcDmgSounds=["4d769e78-91c7-b370-8498-6b087ea638fd","0c803301-4e0d-71ee-54d4-582929db60a2","a22d8ce6-89fa-759d-ff61-869e87151926"];
string mOrcHealSound="33e1077a-a730-d70d-9f01-044dd6e2880f";
list fOrcDmgSounds=["7b7e5a6a-b2b1-dcb8-9b97-0f1d19823a42","7acaaae6-7f5e-2c68-1e56-ffec3f9fe9c5","58ed0801-5a37-3832-6c65-b22dd48a8ffb"];
string fOrcHealSound="a5bc4872-9508-25f7-23da-9500083f804e";

list mHumanDmgSounds=["27de3db5-76eb-2251-82c2-45e75ff33d68","b3ee6607-d661-6b90-663b-a7c89e91474a","2b1daa87-a822-f0a8-0bd4-981cf8d33d06"];
string mHumanHealSound="9f9c932c-9f71-d8cc-7c64-334234316f6d";
list fHumanDmgSounds=["733e31a9-e347-6549-735a-8544d26bba6c","0dac8764-2796-0017-9272-24fcc0953eb9","f6f88e47-7cc2-bcca-7d17-37d16c30b014"];
string fHumanHealSound="2ba25d86-09dd-f88d-eab4-adeeba686ef8";

list mImpDmgSounds=["426de18e-a1b9-3408-08be-47373650bf45","74702e8b-8056-3062-1412-f6d781061c22","d600f77c-a057-d42c-4ed8-b270449c8a27"];
string mImpHealSound="9567da26-67c2-8453-82fe-2665bd90e564";
list fImpDmgSounds=["42dac763-517c-04d7-ed51-9de4116cc565","afc3d630-8f11-f94e-f82f-be83150e3e4b","b6d443c5-2d34-87ca-589b-5f6bf43d6aad"];
string fImpHealSound="fab3914c-6534-36fd-182b-538ff668e87a";

string soundset="NONE";


integer volume = 1;

integer length=0; //How long the dots last;



effect(string meter_effect)
{
    llParticleSystem([7,1.100000,0,259,1,
                      <1.00000, 1.00000, 1.00000>,3,
                      <1.00000, 1.00000, 1.00000>,5,
                      <0.50000, 0.50000, 0.00000>,6,
                      <0.50000, 0.50000, 0.00000>,9,
                      2,13,5.750997,8,
                      <0.00000, 0.00000,0.00000>,15,
                      1,16,0.000000,17,0.100000,18,
                      0.200000,10,3.141593,11,6.283185,21,
                      <0.00000, 0.00000, 0.00000>,19,
                      1.000000,2,1.000000,4,1.000000,12, 
                      meter_effect,20,
                      (key)"" ]);
    llSleep(2.5);
    llParticleSystem([]);
                      
}

playSound()
{
    integer rand=(integer)llFrand(2.999);
    if(llGetTime()<3)
    {
        return;
    }
    llResetTime();
    if(soundset=="NONE")
    {
        return;
    }
    else if(soundset=="MORC")
    {
        llPlaySound(llList2String(mOrcDmgSounds,rand),volume);
    }
    else if(soundset=="FORC")
    {
        llPlaySound(llList2String(fOrcDmgSounds,rand),volume);
    }
    else if(soundset=="MHUMAN")
    {
        llPlaySound(llList2String(mHumanDmgSounds,rand),volume);
    }
    else if(soundset=="FHUMAN")
    {
        llPlaySound(llList2String(fHumanDmgSounds,rand),volume);
    }
    else if(soundset=="MIMP")
    {
        llPlaySound(llList2String(mImpDmgSounds,rand),volume);
    }
    else if(soundset=="FIMP")
    {
        llPlaySound(llList2String(fImpDmgSounds,rand),volume);
    }
        
}


default
{
    on_rez(integer start_param)
    {
        llParticleSystem([]);
        
    }
    
    state_entry()
    {
        llSetTimerEvent(length+0.1);
    }
    timer()
    {
        length=0;
        llSetTimerEvent(0);
        llParticleSystem([]);
    }
    link_message(integer sender_number, integer number, string m, key id)
    {
        if (number == 45) 
        { 
            if(m=="soundset")
            {
                soundset=(string)id;
            }
            else if(m == "fire")
            {
                length=(((integer)((string)id))/2)+5;
                state fire;
            }
            else if(m == "poison")
            {
                length=(((integer)((string)id))/2)+5;
                state poison;
            }
            else if(m == "air")
            {
                state air;
            }
            else if(m == "blood")
            {
                state blood;
            }
            else if(m == "ghost")
            {
                state ghost;
            }
            else if(m=="heal")
            {
                state heal;
            }
            else if(m == "dead")
            {
                effect("68e15111-a5f8-c036-3e78-747a40c6e0ab");
            }
            else if(m == "sleep")
            {
                state sleep;
            }
            else if (m == "awake")
            {
                state awake;
            }
        }
    }

}

state fire
{
    state_entry()
    {
        
         llParticleSystem([  PSYS_PART_MAX_AGE,1.2,
                        PSYS_PART_FLAGS,PSYS_PART_EMISSIVE_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK,
                        PSYS_PART_START_COLOR, <1,1,1>,
                        PSYS_PART_END_COLOR, <1,1,1>,
                        PSYS_PART_START_SCALE,<1.2,1.2,0>,
                        PSYS_PART_END_SCALE,<.5,.5,0>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE,0.1,
                        PSYS_SRC_ACCEL, <0,0,1>,
                        PSYS_SRC_BURST_PART_COUNT,2,
                        PSYS_SRC_BURST_RADIUS,0,
                        PSYS_SRC_BURST_SPEED_MIN,0.1,
                        PSYS_SRC_BURST_SPEED_MAX,0.2,
                        PSYS_SRC_INNERANGLE,1.54, 
                        PSYS_SRC_OUTERANGLE,1.55,
                        PSYS_SRC_OMEGA, <0,0,10>,
                        PSYS_SRC_MAX_AGE, length+5,
                        PSYS_SRC_TEXTURE, "e38dc2ff-941d-f7e1-ad76-8b69d53568d8",
                        PSYS_PART_START_ALPHA, 0.7,
                        PSYS_PART_END_ALPHA, 0.3
                            ]);
        playSound();
        llSleep(0.01);
        state default;
    }
}

state poison
{
    state_entry()
    {
        
        llParticleSystem([  PSYS_PART_MAX_AGE,1.2,
                        PSYS_PART_FLAGS,PSYS_PART_EMISSIVE_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_FOLLOW_SRC_MASK,
                        PSYS_PART_START_COLOR, <1,1,1>,
                        PSYS_PART_END_COLOR, <1,1,1>,
                        PSYS_PART_START_SCALE,<0.6,0.6,0>,
                        PSYS_PART_END_SCALE,<0.3,0.26,0>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE,1,
                        PSYS_SRC_ACCEL, <0,0,-0.5>,
                        PSYS_SRC_BURST_PART_COUNT,7,
                        PSYS_SRC_BURST_RADIUS,0,
                        PSYS_SRC_BURST_SPEED_MIN,0.9,
                        PSYS_SRC_BURST_SPEED_MAX,1.2,
                        PSYS_SRC_INNERANGLE,0, 
                        PSYS_SRC_OUTERANGLE,PI/2,
                        PSYS_SRC_MAX_AGE, length+5,
                        PSYS_SRC_TEXTURE, "abf10a19-8af1-bd93-820d-3868cec115dc",
                        PSYS_PART_START_ALPHA, 0.7,
                        PSYS_PART_END_ALPHA, 0.5
                            ]);
        
        playSound();
        llSleep(0.01);
        state default;
    }
}

state air
{
    state_entry()
    {
        effect("fda6b800-b2c5-e859-5c1a-27a88457f7df");
        llSleep(0.01);
        state default;
    }
}
state heal
{
    state_entry()
    {
        if(length==0)
        {
         llParticleSystem([  PSYS_PART_MAX_AGE,1.2,
                        PSYS_PART_FLAGS,PSYS_PART_EMISSIVE_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK,
                        PSYS_PART_START_COLOR, <1,1,1>,
                        PSYS_PART_END_COLOR, <0.2,0.3,1>,
                        PSYS_PART_START_SCALE,<0.1,1.2,0>,
                        PSYS_PART_END_SCALE,<0.1,1.3,0>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
                        PSYS_SRC_BURST_RATE,0.2,
                        PSYS_SRC_ACCEL, <0,0,0>,
                        PSYS_SRC_BURST_PART_COUNT,9,
                        PSYS_SRC_BURST_RADIUS,0.5,
                        PSYS_SRC_BURST_SPEED_MIN,0.1,
                        PSYS_SRC_BURST_SPEED_MAX,0.2,
                        PSYS_SRC_INNERANGLE,0, 
                        PSYS_SRC_OUTERANGLE,PI,
                        PSYS_SRC_OMEGA, <0,0,0>,
                        PSYS_SRC_MAX_AGE, 1.5,
                        PSYS_PART_START_ALPHA, 0.7,
                        PSYS_PART_END_ALPHA, 0.8
                            ]);}
        if(llGetTime()>=3)
        {
            llResetTime();
            if(soundset=="MORC")
            {
                llPlaySound(mOrcHealSound,volume);
            }
            else if(soundset=="FORC")
            {
                llPlaySound(fOrcHealSound,volume);
            }
            else if(soundset=="MHUMAN")
            {
                llPlaySound(mHumanHealSound,volume);
            }
            else if(soundset=="FHUMAN")
            {
                llPlaySound(fHumanHealSound,volume);
            }
            else if(soundset=="MIMP")
            {
                llPlaySound(mImpHealSound,volume);
            }
            else if(soundset=="FIMP")
            {
                llPlaySound(fImpHealSound,volume);
            }
        }
        length=2;
        llSleep(0.01);
        state default;
    }
}

state blood
{
    state_entry()
    {
        if(length==0)
        {
        llParticleSystem([  PSYS_PART_MAX_AGE,1.2,
                        PSYS_PART_FLAGS,PSYS_PART_EMISSIVE_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_FOLLOW_SRC_MASK,
                        PSYS_PART_START_COLOR, <1,1,1>,
                        PSYS_PART_END_COLOR, <1,1,1>,
                        PSYS_PART_START_SCALE,<0.6,0.6,0>,
                        PSYS_PART_END_SCALE,<0.3,0.26,0>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE,1,
                        PSYS_SRC_ACCEL, <0,0,-0.5>,
                        PSYS_SRC_BURST_PART_COUNT,8,
                        PSYS_SRC_BURST_RADIUS,0,
                        PSYS_SRC_BURST_SPEED_MIN,0.9,
                        PSYS_SRC_BURST_SPEED_MAX,1.2,
                        PSYS_SRC_INNERANGLE,0, 
                        PSYS_SRC_OUTERANGLE,PI/2,
                        PSYS_SRC_MAX_AGE, 0.5,
                        PSYS_SRC_TEXTURE, "d2465880-51f4-739e-c359-028003bfc5fa",
                        PSYS_PART_START_ALPHA, 0.7,
                        PSYS_PART_END_ALPHA, 0.5
                            ]);}
        
        
        playSound();
        llSleep(0.01);
        state default;
    }
}

state ghost
{
    state_entry()
    {
        effect("8f4930c2-a070-056c-6151-1ab2f11cd942");
        llSleep(0.01);
        state default;
    }
}

state sleep
{
    state_entry()
    {
        llPlaySound(usound, volume);
        llSleep(0.01);
        state default;
    }
}

state awake
{
    state_entry()
    {
        if(soundset=="MORC")
        {
            llPlaySound(mOrcHealSound,volume);
        }
        else if(soundset=="FORC")
        {
            llPlaySound(fOrcHealSound,volume);
        }
        else if(soundset=="MHUMAN")
        {
            llPlaySound(mHumanHealSound,volume);
        }
        else if(soundset=="FHUMAN")
        {
            llPlaySound(fHumanHealSound,volume);
        }
        else if(soundset=="MIMP")
        {
            llPlaySound(mImpHealSound,volume);
        }
        else if(soundset=="FIMP")
        {
            llPlaySound(fImpHealSound,volume);
        }
        llSleep(0.01);
        state default;
    }
}