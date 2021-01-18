string url = "http://www.yourwebserver/s_data.php";
string url2 = "http://www.yourwebserver/data.php";
string Name;

// This is the secret passphrase defined in your config.php 
string password = "PutYourEncryptionKeyHere";

key get_id;
key put_id;
key query_id;

GetData(key id, list column){
    string args;
    args+="?action=retrieve";
    args+="&key="+llEscapeURL(id);
    args+="&column="+llEscapeURL(llList2CSV(column));
    args+="&password="+llEscapeURL(password);
    get_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}

AddData(key id, list columns, list values){
    if(llGetListLength(columns)!=llGetListLength(values)){
        return;
    }
    string args;
    args+="?action=input";
    args+="&key="+llEscapeURL(id);
    args+="&column="+llEscapeURL(llList2CSV(columns));
    args+="&values="+llEscapeURL(llList2CSV(values));
    args+="&password="+llEscapeURL(password);
    put_id = llHTTPRequest(url2+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
    
}

QueryData(list columns, list parameters, list operators, list values){
    if(llGetListLength(parameters)!=llGetListLength(values) && llGetListLength(parameters)!=llGetListLength(operators)){
        return;
    }
    
    string args;
    args+="?action=query";
    args+="&key="+llEscapeURL(llList2CSV(parameters));
    args+="&column="+llEscapeURL(llList2CSV(columns));
    args+="&operators="+llEscapeURL(llList2CSV(operators));
    args+="&values="+llEscapeURL(llList2CSV(values));
    args+="&password="+llEscapeURL(password);
    query_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}

GetAVData(key id, list column){
    string args;
    args+="?action=retrieve";
    args+="&key="+llEscapeURL(id);
    args+="&column="+llEscapeURL(llList2CSV(column));
    args+="&password="+llEscapeURL(password);
    get_id = llHTTPRequest(url2+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}

integer AClass;
integer ACMax = 90;
float DA;
float AClassp;
integer Base;        // Max health the user can have currently - Base Health
integer HMax;
integer MMax;      // Max mana the user can have currently
integer MCap;      // Max mana the user can have overall
integer AMMax;       // Ammo Counter
integer AMCap;

integer SMax;
integer SCap;      // Max stamina the user can have
integer DMax;      // The Max Death count the user can have
integer FMax;      // The max Food the user can have
integer BMax;       // the Max FireDOT that can be placed on the user at one time
integer BLMax;
integer PMax;       // The Max PoisonDOT that can be placed on the user at one time
integer AMax;      // The Max Air the user can have
integer ACap ;      // The Max Air the user can have overall
integer NDmgMax;       // The Max amount of normal damage that can be done with one command
integer SDmgMax;       // The Max amount of stamina damage that can be done with one command
integer ADmgMax;       // The Max Air Damge / Restore that can be doen in one comand
integer FAmtMax;       // The max amount of food that can be applied in one command
integer MDmgMax;       // The max amount of mana that can be stolen in one command
integer FDmgMax;       // max food to be stolen in one command

// Ticks that determin he gain and loss of points for health, mana, stamina etc.
// These could be replaced by a sim server as well
integer HTick;      // the number of seconds it takes to recover one health point
integer MTick;       // the number of seconds it takes to recover one mana point
integer STick;     // the number of seconds it takes to lose one stamina point
integer RSTick;       // the number of seconds it takes to lose one stamina point while running or flying
integer FTick;     // The number of seconds it takes to lose one food point
//integer FTick;                  //Set in sim check for combat and non combat enviroments
integer ATick;       // The number of seconds it takes to gain one air point
integer RTick;       // The number of seconds it takes to recover one stamina point / mana point while resting
// Damage Values for DOT 
// These also could be replaced by a sim server
integer BDmg        = 1;       // The amount of damage done my fire per second while burning
                               // (can be set to 0 for dragons, to make them immune)
integer PDmg        = 1;       // The amount of poison damage done per second
integer ADmg        = 5;       // The amount of damage done per second while drowning
integer BLDmg        = 1;
integer HDmg        =1;

integer MWounded;
integer Ressurections;
integer Deaths;
//////////////////////////////////////////////////////////////////////////////////////////
// ******************* Sounds 
string ssound = "a0d467f5-f852-b9cc-fb5d-e40cacd5f9cf"; //Start Up Sound
// other sounds handled in ACS_EF

// ******************* Channels
integer acsChannel = -5824134;              // Channel for meter communications (ACS only)
// ******************* Misc variables
float volume;                               // Volume of sounds to be played when healed/taking damage etc.
float Water;                                // Holds the sim wide water height to be used for deciding  if the bearer of the meter is under water.                        
// ******************* Constants
integer sf_update = 1176678;
integer TMode = 0;
// ******************* Types and Effects
// Types
string TYPE_OWNER = "atco";         // Owner
// Effects
string EF_NDAM = "aeda";            // Normal damage
string EF_NSDAM = "asda";           //Normal and Stamina
string EF_SNDAM = "sada";           // Stamina Damage Normal
string EF_DOTFIRE = "aefi";         // DOT Fire damage
string EF_DOTPOISON = "aepo";       // DOT Poison damage
string EF_BLEEDDOT = "aebl";        // DOT Bleed
string EF_SDAM = "aesd";            // Stamina damage
string EF_FOOD_D = "fdmg";          // Food damage (can be a feature of the rogues (thiefs))
string EF_MANA_D = "mdmg";          // mana damage (can be a feature of the clerics)
string EF_AMMO_H = "ahxl";
string EF_NHEAL = "aehe";           // normal healing 
string EF_NHEALDOT = "aehd";
string EF_SHEAL = "aesh";           // Stamina healing 
string EF_FOOD = "aefo";            // Food healing (simply eat)
string EF_MANA_H = "mhxl";          // mana healing (can be a feature of the clerics)
string EF_NAIR_H = "aeue";          // Air restore
string EF_RES = "aere";             // Resurrection

string EF_MANA_M = "mtfm";          // Meter reply on mana request. Fixed: "sfcomtfm01" = you got mana and "sfcomtfm00" = there is not enough mana
string EF_MANA_W = "gmsp";          // Weapon request for Mana. Example: "sfcogmsp20" = give me 20 mana please if you have

string EF_AMMO_M = "atfm";
string EF_AMMO_W = "gasp";

string EF_SILENCE="slnc";
string EF_STUN="stun"; 
string EF_BIND="bind";
string EF_SLOW="slow";

//string EF_ARMOR_ON="amfm";
//string EF_ARMOR_OFF="amsp";

string EF_TOURN_ON="tmfm";
string EF_TOURN_OFF="tmsp";


string EF_COMMAND = "atcs";         // String that Meter commands will use such as reset   
string EF_RESET ="rset";            // Reset String

key OWNER_KEY;                      // Av key of the meter's owner


list ACSRegions;

// Stats
integer Health;                     // Current health
integer Stamina;                    // Current stamina
integer Mana;                       // Current mana
integer Ammo;
integer Death;                      // Death counter. This is set to DMax at startup. Then...when the Health parameter reaches 0 AND this parameter is still equal to DMax..the meter is put into state Dead.  
integer Food;                       // Current food
integer Air;                        // Current air
integer Burn;                       // Current fireDOT (Damage over time)
integer DOT;                        // DOT Damage 
integer HDOT;
integer DOTHeal;
integer Bleed;                      //Bleed Damage
integer BOT;                        //Bleed over time
integer Poison;                     // Current poisonDOT
integer POT;                        // Well. not what you think.. it's the poison dot damage
integer State;                      // The state of the user     -1 = dead, 0 = alive, 1 = asleep
integer Time;                       // Used to keep track of ticks DO NOT EDIT

integer slowTime;
integer resurrecting;               //Boolean true if in the process of ressurecting to prevent from a meter reset
integer reset;                      //Boolean FALSE if owner has disconnected rather than removed the meter to prevent reset on a crash

integer silenceTime;
integer stunTime;
integer bindTime;

string lastMeter;

string Race;
string Class;

// ******************* Functions

string zero_pad(integer number)
{
    if (number < 10)
    {
        return "0" + (string)number;
    }
    else 
    {
        return (string)number;
    }
} 

string format_time(integer seconds)
{
    integer secs = seconds % 60;
    seconds /= 60;
    integer mins = seconds % 60;
    integer hrs = seconds / 60;
    return ((string)mins + ":" + zero_pad(secs));
} 

Init()
{
    //llSay(0,"Init Called");
    integer TMode = 0;
    AClassp = (float)AClass / 100;
    DA = Base / (1-AClassp);
    Health = (integer)DA; 
    HMax = (integer)DA;                  
    Mana = MMax;
    Ammo = AMMax;                   
    MCap = MMax;                    
    Stamina = SMax;                 
    Death = DMax;                   
    Food = FMax;                    
    Air = AMax;                     
    Burn = 0;                       
    Poison = 0;
    Bleed = 0;                     
    State = 1;
    silenceTime=0;
    stunTime=0;
    //FTick = 9999999; 
    
    llMessageLinked(LINK_SET , 20, "start", NULL_KEY);                     
    llPlaySound(ssound, volume); 
}

LoadAVData(string CSVList)
{
    list Settings = llParseString2List(CSVList,["|"],[]);
    Name = llList2String(Settings,0);
    Race = llList2String(Settings,1);
    Class = llList2String(Settings,2);
    //Level = llList2Integer(Settings,3);
    AClass = llList2Integer(Settings,4);
    MWounded = llList2Integer(Settings,5);
    Ressurections = llList2Integer(Settings,6);
    Deaths = llList2Integer(Settings,7);
    if (llList2String(Settings, 0) ==llKey2Name(OWNER_KEY))
        Init();
    else
        AddData(OWNER_KEY,["Name"], [llKey2Name(OWNER_KEY)]);
}


 LoadSimServer(string CSVList)
{
    list Settings = llParseString2List(CSVList,[","],[]);
    Base = llList2Integer(Settings,0);
    MMax  = llList2Integer(Settings,1);
    MCap  = llList2Integer(Settings,2);
    AMMax  = llList2Integer(Settings,3);
    AMCap  = llList2Integer(Settings,4);
    SMax = llList2Integer(Settings,5);
    SCap  = llList2Integer(Settings,6);
    DMax = llList2Integer(Settings,7);
    FMax = llList2Integer(Settings,8);
    BMax = llList2Integer(Settings,9);
    BLMax = llList2Integer(Settings,10);
    PMax = llList2Integer(Settings,11);
    AMax = llList2Integer(Settings,12);
    ACap = llList2Integer(Settings,13);
    NDmgMax = llList2Integer(Settings,14);
    SDmgMax = llList2Integer(Settings,15);
    ADmgMax =  llList2Integer(Settings,16);
    FAmtMax = llList2Integer(Settings,17);
    FDmgMax = llList2Integer(Settings,18);
    MDmgMax = llList2Integer(Settings,19);
    HTick = llList2Integer(Settings,20);
    MTick = llList2Integer(Settings,21);
    STick = llList2Integer(Settings,22);
    RSTick = llList2Integer(Settings,23);
    FTick = llList2Integer(Settings,24);
    ATick = llList2Integer(Settings,25);
    RTick = llList2Integer(Settings,26);
   // BDmg = llList2Integer(Settings,25);
   // PDmg = llList2Integer(Settings,26);
   // ADmg = llList2Integer(Settings,27);
    Init();
} 

 

Rest()
{
    State = 1;                              
    llTakeControls( 0, FALSE, FALSE );     
    llStartAnimation( "dead" );             
    Burn = 0;                               
    Poison = 0; 
    Bleed = 0;                            
    if( ( llGetPos() * < 0, 0, 1 > ) < Water )
    {
        llSay(0, llKey2Name(OWNER_KEY)+ " Has drowned while sleeping" );
        state DEAD;                         // good bye cruel world...
    }
} 

Live( integer Amount )
{
    Ressurections = Ressurections + 1;
    AddData(OWNER_KEY,["Ressurections"], [Ressurections]);
    llTakeControls( CONTROL_ROT_LEFT | 
                    CONTROL_ROT_RIGHT | 
                    CONTROL_UP | 
                    CONTROL_DOWN | 
                    CONTROL_LEFT | 
                    CONTROL_RIGHT | 
                    CONTROL_FWD | 
                    CONTROL_BACK | 
                    CONTROL_LBUTTON | 
                    CONTROL_ML_LBUTTON, TRUE, TRUE );                   
    volume = 1;                             
    llStopAnimation( "dead" );             
    llSetTimerEvent( 1 );                   
    Health = Amount;                     
    Stamina = Amount;                       
    Mana = Amount; 
    Ammo = Amount;                         
    Food = FMax;                            
    Air = AMax;                             
    Poison = 0;                             
    Burn = 0;
    silenceTime=0;
    stunTime=0; 
    Bleed =0;                              
    Death = DMax;                                                      
    MMax = MCap;                            
    if( Health > HMax )
    {
        Health = HMax;
    }
    if( Air > AMax )
    {
        Air = AMax;
    }
    if( Stamina > SMax )
    {    
        Stamina = SMax;
    }
    if( Mana > MMax )
    {    
        Mana = MMax;
    }
    if ( Ammo > AMMax )
    {   
        Ammo = AMMax;
}
    
    State = 0; 
    resurrecting=FALSE; 
} 

Awake()
{
    llTakeControls( CONTROL_ROT_LEFT | 
                    CONTROL_ROT_RIGHT | 
                    CONTROL_UP | 
                    CONTROL_DOWN | 
                    CONTROL_LEFT | 
                    CONTROL_RIGHT | 
                    CONTROL_FWD | 
                    CONTROL_BACK | 
                    CONTROL_LBUTTON | 
                    CONTROL_ML_LBUTTON, TRUE, TRUE );
    llStopAnimation( "dead" );                  
    State = 0;                                
} 

handleEffect(string effect, integer Amount) 
{
    //if (effect == EF_ARMOR_ON) 
    //{
      //  armor_on(Amount);
    //} 
    //else if (effect == EF_ARMOR_OFF) 
    //{
     //   armor_off(Amount);
    //}
    if (effect == EF_TOURN_ON)
    {
        TMode = 1;
        llSay(0,"Tournament Mode Activated");
    }
        else if (effect == EF_TOURN_OFF)
    {
        TMode = 0;
        llSay(0,"Tournament Mode Deactivated");
    }
    else if (effect == EF_NDAM) 
    {
        damage(Amount);
    }
    else if (effect == EF_NSDAM) 
    {
        ns_damage(Amount);
    }
     else if (effect == EF_SNDAM) 
    {
        sn_damage(Amount);
    } 
    else if (effect == EF_DOTFIRE) 
    {
        dot_fire(Amount);
    } 
    else if (effect == EF_DOTPOISON) 
    {
        dot_poison(Amount);        
    }
    else if (effect == EF_BLEEDDOT)
    {
        dot_bleed(Amount);
    } 
    else if (effect == EF_NHEAL) 
    {
        heal(Amount);    
    } 
    else if (effect == EF_NHEALDOT )
    {
        dot_heal(Amount);
    }
    else if (effect == EF_NAIR_H) 
    {
        air(Amount);    
    }
    else if (effect == EF_SDAM) 
    {
        stamina_damage(Amount);    
    } 
    else if (effect == EF_SHEAL) 
    {
        stamina_heal(Amount);    
    } 
    else if (effect == EF_FOOD) 
    {
        food(Amount);   
    }
    else if (effect == EF_FOOD_D)
    {
        food_damage(Amount);
    }     
    else if (effect == EF_RES) 
    { 
        resurrect(Amount);
        resurrecting=TRUE;
        llMessageLinked(LINK_THIS, 15, "alive", NULL_KEY);
    }
    else if (effect == EF_MANA_W)
    {
        giveMana(Amount);
    }
    else if (effect == EF_MANA_D)
    {
        mana_damage(Amount);
    }   
    else if (effect == EF_MANA_H)
    {
        mana_heal(Amount);
    }
    else if( effect== EF_SLOW )
    {
        slow(Amount);   
    } 
    else if ( effect == EF_AMMO_W)
    {
        giveAmmo(Amount);
    }  
    else if ( effect == EF_AMMO_H )
    {
        ammo_heal(Amount);               
    }
    else if ( effect == EF_SILENCE )
    {
        silence(Amount);              
    }
    else if ( effect == EF_STUN )
    {
        stun(Amount);               
    }
    else if ( effect == EF_BIND )
    {
        bind(Amount);               
    }
}
 
silence(integer Amount)
{
    if(Amount>silenceTime)
    {
        silenceTime=Amount;
    }
}

bind(integer Amount)
{
    if(State==0 && Amount>bindTime && stunTime==0)
    {
        llTakeControls( CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_LBUTTON |CONTROL_ML_LBUTTON, FALSE, FALSE );
        bindTime=Amount;
    }
}


stun(integer Amount)
{
    if(State==0 && Amount>stunTime && bindTime==0)
    {
        llTakeControls( 0, FALSE, FALSE );
        stunTime=Amount;
    }
}

slow(integer Amount)
{
    if(Amount>slowTime)
    {
        slowTime=Amount;
        llSetVehicleType(VEHICLE_TYPE_SLED);
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <0.05, 0.05, 1>);
    }
}

food_damage(integer Amount)
{
    if( Amount > FDmgMax )
    {
        Amount = FDmgMax;
    }
    if(Food > 0 && Amount < Food)
    {
        Food -= Amount;   
    }
    else 
    {
        Food = 0;
    }
}

mana_damage(integer Amount)
{
    if( Amount > MDmgMax )
    {
        Amount = MDmgMax;
    }
    if(Mana > 0 && Amount < Mana)
    {
        Mana -= Amount;   
    }
    else if(Mana > 0 && Amount > Mana)
    {
        Mana = 0;   
    }
    else if (Mana <= 0)
    {
        Mana = 0;
    }
}

mana_heal(integer Amount)
{
    Mana += Amount;    
} 

giveMana(integer Amount) 
{
    if(silenceTime>0)
    {
        llOwnerSay("Cannot cast spells while silenced.");
    }
    else if( Amount > Mana )
    {
        llSay(acsChannel, TYPE_OWNER + EF_MANA_M + "00");
        llOwnerSay("Not enough mana!");
    }
    else if ( Amount <= Mana )
    {
        llSay(acsChannel, TYPE_OWNER + EF_MANA_M + "01");
        Mana -= Amount;
        llMessageLinked(LINK_ALL_CHILDREN, Mana, "mtfm", NULL_KEY);
    }       
} 

//armor_on(integer Amount)
//{
//    if (AClass < ACMax)
//    {
//    AClass += Amount;
//    AClassp = (float)AClass / 100;
//    DA = Base / (1-AClassp);
//    HMax = (integer)DA;
//    integer Modify = Health - (integer)DA;
//    //llSay(0,"Modify:"+(string)Modify);
    //llSay(0,"Debug AClass:"+(string)AClass);
//    Health -= Modify;
  //      }
//    }

//armor_off(integer Amount)
//{
//    
//    if (AClass > 0 )
//    {
//    llSay(0,"AOff");
//    AClass -= Amount;
//    AClassp = (float)AClass / 100;
//    DA = Base * (1-AClassp);
//    HMax = (integer)DA;
//    integer Modify = Health - (integer)DA;
    //llSay(0,"Modify:"+(string)Modify);
    //llSay(0,"Debug AClass:"+(string)AClass);
//    Health -= Modify;
    //llSay(0,"Debug Health"+(string)Health);
    
//    }
//    if (AClass  < 0)
//    {
//    AClass = 0;
//    AClassp = (float)AClass / 100;
//    DA = Base * (1-AClassp);
//    HMax = (integer)DA;
//    integer Modify = Health - (integer)DA;
    //llSay(0,"Modify:"+(string)Modify);
    //llSay(0,"Debug AClass:"+(string)AClass);
//    Health -= Modify;
    //llSay(0,"Debug Health"+(string)Health);
//    }
//}


ammo_heal(integer Amount)
{
    Ammo = AMMax;
    llSay(-5824134,"recharge");    
} 
giveAmmo(integer Amount)
{
    if ( Amount > Ammo )
    {
        llSay(acsChannel, TYPE_OWNER + EF_AMMO_M + "00");
        llOwnerSay("Not enough ammo!");
    }
    else if ( Amount <=Ammo )
    {
        llSay(acsChannel, TYPE_OWNER + EF_AMMO_M +"01");
        Ammo -= Amount;
        llMessageLinked(LINK_ALL_CHILDREN, Ammo, "atfm", NULL_KEY);
    }       
} 
        

resurrect(integer Amount) 
{
    if( State == -1 )
    {
        
        Live( Amount );
        
        state combat;
    }
}
 
damage(integer Amount) 
{
    if( Amount > NDmgMax )
    {
        Amount = NDmgMax;
    }
    if(llGetTime()>=1.0)
    {
        llMessageLinked(LINK_SET,45,"blood",NULL_KEY);
        llResetTime();
    }
    Health -= Amount;
    if (TMode == 1)
    {
    llSay(0,llKey2Name(OWNER_KEY)+",Has Been Hit,"+"("+(string)Amount+")"+"("+(string)Health+")");;
    }   
}

ns_damage(integer Amount) 
{
    if( Amount > NDmgMax )
    {
        Amount = NDmgMax;
    }
    if(llGetTime()>=1.0)
    {
        llMessageLinked(LINK_SET,45,"blood",NULL_KEY);
        llResetTime();
    }
    Health -= Amount;
    
    
    if(Stamina > 0 && Amount < Stamina)
    {
      Stamina -= Amount/2;
        }
        else
        {
            Stamina = 0;
        }
    
    if (TMode == 1)
    {
    llSay(0,llKey2Name(OWNER_KEY)+",Has Been Hit,"+"("+(string)Amount+")"+"("+(string)Health+")");;
    }   
}
        
sn_damage(integer Amount) 
{
    if( Amount > NDmgMax )
    {
        Amount = NDmgMax;
    }
    if(llGetTime()>=1.0)
    {
        llMessageLinked(LINK_SET,45,"blood",NULL_KEY);
        llResetTime();
    }
    Stamina -= Amount;
    
    
    if(Health > 0 && Amount < Health)
    {
      Health -= Amount/2;
        }
        else
        {
            Health = 0;
        }
    
    if (TMode == 1)
    {
    llSay(0,llKey2Name(OWNER_KEY)+",Has Been Hit,"+"("+(string)Amount+")"+"("+(string)Health+")");;
    }      
}
     
heal(integer Amount) 
{
   if (Amount > NDmgMax) 
    {
        Amount = NDmgMax;    
    }
    if (Health > 0 )
    {
       if(llGetTime()>=1.0)
    {
        llMessageLinked(LINK_SET,45,"heal",NULL_KEY);
        llResetTime();
    }
        Health += Amount;
    }
    if( Health > HMax )
    {
        Health = HMax;
    }
}

dot_heal(integer Amount) 
{
   if (Amount >= NDmgMax) 
    {
        DOTHeal >= NDmgMax;    
    }
    else if (Amount  > DOTHeal )
    {
       if(llGetTime()>=1.0)
    {
        llMessageLinked(LINK_SET,45,"heal",NULL_KEY);
        llResetTime();
    }
        Health += Amount;
        HDOT = Amount / 2;
        DOTHeal += HDOT;
        
    }

}    
        

air(integer Amount) 
{
    if (Amount > ADmgMax) 
    {
        Amount = ADmgMax;    
    }
    if ( Air > 0)
    {
        Air+= Amount;
    }
    else
    {
        Air = 0;
    }

    if( Air > ACap )
    {
        Air = ACap;
    }
}

stamina_damage(integer Amount) 
{
    if( !State )
    {
        if( Amount > SDmgMax )
        {
            Amount = SDmgMax;
        }
        if(llGetTime()>=1.0)
        {
            llMessageLinked(LINK_SET,45,"stamina",NULL_KEY);
            llResetTime();
        }
        if(Stamina > 0 && Amount < Stamina)
        {
            Stamina -= Amount;
        }
        else
        {
            Stamina = 0;
        }
    }
}

stamina_heal(integer Amount) 
{
    if (Amount >SDmgMax)
    {
        Amount = SDmgMax;
    }
    Stamina += Amount;
    if (Stamina >SCap)
    {  
        Stamina = SCap;
    }
}

dot_fire(integer Amount) 
{        
    if( Amount >= BMax )
    {
        Burn = BMax;
    }
    else if( Amount > Burn )
    {
        if(llGetTime()>=1.0)
        {
            llMessageLinked(LINK_SET,45,"fire",(string)Amount);
            llResetTime();
        } 
        Health -= Amount;
        DOT = Amount / 2;
        Burn += DOT;
    }
}

dot_poison(integer Amount) 
{
    if( Amount >= PMax )
    {
        Poison = PMax;
    }
    else if( Amount > Poison )
    {
        if(llGetTime()>=1.0)
        {
            llMessageLinked(LINK_SET,45,"poison",(string)Amount);
            llResetTime();
        }
        Health -= Amount;
        POT = Amount / 2;
        Poison += POT;
    }
}

dot_bleed(integer Amount) 
{
    if( Amount >= BLMax )
    {
        Bleed = BLMax;
    }
    else if( Amount > Bleed )
    {
        if(llGetTime()>=1.0)
        {
            llMessageLinked(LINK_SET,45,"blood",NULL_KEY);
            llResetTime();
        }
        Health -= Amount;
        BOT = Amount / 2;
        Bleed += BOT;
    }
}
    
food(integer Amount) 
{
   if (Amount > FAmtMax) 
    {
        Amount = FAmtMax;    
    }
    Food += Amount;
    if( Food > FMax )
    {
        Food = FMax;
    }
}

string timerTickElapsed() 
{
    string result = "normal";
    ++Time;
    integer agentInfo=llGetAgentInfo(OWNER_KEY);
    if( !State )
    {
        if (agentInfo & AGENT_ALWAYS_RUN) 
        {
            float RSpeed = llVecMag(llGetVel());
            if (RSpeed > 1) 
            {
                Stamina -= !( Time % RSTick );   
            }
        }
        if (agentInfo & AGENT_IN_AIR) 
        {
            Stamina -= !( Time % (RSTick*2) );   
        }
        if (agentInfo & AGENT_FLYING) 
        {
            float RSpeed = llVecMag(llGetVel());
            if (RSpeed > 1) 
            {
                Stamina -= !( Time % RSTick );   
            }
        }
            if (agentInfo & AGENT_SITTING ) 
        {
            Stamina += !( Time % RTick );
            Mana += !( Time % RTick );
            llOwnerSay((string)Stamina);
            llOwnerSay((string)Mana);
            llMessageLinked(LINK_ALL_CHILDREN, Mana, "mtfm", NULL_KEY);
        }
        if( ( llGetPos() * < 0, 0, 1 > ) < Water )
        {
            Burn = 0;
            if( Air > 0 )
            {
                --Air;
            }
            else
            {
                Health -= ADmg;
            }
        }
        else if( !( Time % ATick ) && ( Air < AMax ) )
        {
            ++Air;
        }
        if( Burn > 0 )
        {

            Health -= BDmg;
            --Burn;
            
        }
        if (DOTHeal > 0)
        {
        Health += HDmg;
        --DOTHeal;
        }
        if( Poison > 0 )
        {
            Health -= PDmg;
            --Poison;
        }
        if( Bleed > 0 )
        {
            Health -= BLDmg;
            --Bleed;
        }
        if(silenceTime > 0)
        {
            silenceTime--;

        }
        if(stunTime > 0)
        {
            stunTime--;
            if(stunTime==0)
            {
                llTakeControls( CONTROL_ROT_LEFT | 
                    CONTROL_ROT_RIGHT | 
                    CONTROL_UP | 
                    CONTROL_DOWN | 
                    CONTROL_LEFT | 
                    CONTROL_RIGHT | 
                    CONTROL_FWD | 
                    CONTROL_BACK | 
                    CONTROL_LBUTTON | 
                    CONTROL_ML_LBUTTON, TRUE, TRUE );
            }
        }
        if(bindTime > 0)
        {
            bindTime--;
            if(bindTime==0)
            {
                llTakeControls( CONTROL_ROT_LEFT | 
                    CONTROL_ROT_RIGHT | 
                    CONTROL_UP | 
                    CONTROL_DOWN | 
                    CONTROL_LEFT | 
                    CONTROL_RIGHT | 
                    CONTROL_FWD | 
                    CONTROL_BACK | 
                    CONTROL_LBUTTON | 
                    CONTROL_ML_LBUTTON, TRUE, TRUE );
            }
        }
         if(slowTime>0)
        {
            slowTime--;
            if(slowTime==0)
            {
                  llSetVehicleType(VEHICLE_TYPE_NONE);  
            }   
        }
        if( Health > 0 )
        {
            Health += !( Time % HTick );
        }
        else if( Death == DMax )
        {
            --Death;
            result = "DIE"; 
            return result;
        }
        if( !( Time % FTick ) )
        {
            if( Food > 0 )
            {
                --Food;
            }
            else
            {
                if( Health > 0 )
                {
                   Health = Health -7;
                }
            }
        }
        if( Stamina > 0 )
        {
            Stamina -= !( Time % STick );
        }
        else
        {
            llMessageLinked(LINK_THIS, 15, "unconscious", NULL_KEY); 
            llSay(0, llKey2Name(OWNER_KEY)+ " Has fallen Unconscious " );
            Rest();
        }
        if( Mana < MMax )
        {
            Mana += !( Time % MTick );
            llMessageLinked(LINK_ALL_CHILDREN, Mana, "mtfm", NULL_KEY);
        }
        if( Health > HMax )
        {
            Health = HMax;
        }
        if( Air > ACap )
        {
            Air = ACap;
        }
        if( Stamina > SCap )
        {
            Stamina = SCap;
        }
        if( Food > FMax )
        {
            Food = FMax;
        }
        if(Mana > MMax)
        {
            Mana = MMax;
        }
    } 
    else if( ~State )
    {            
        if( Stamina < 10 )
        {
            Stamina += !( Time % RTick );
        }
        else
        {
            Awake();
        }
        if( Health > HMax )
        {
            Health = HMax;
        }
        else if( Health > 0 )
        {
            Health += !( Time % HTick );
        }
        else if( Death > 0 )
        {
            --Health;
        }
        else
        {
             llSay(0, llKey2Name(OWNER_KEY)+ " Has died while sleeping" );
            result = "DIE";
            return result;
        }
    }  
    UpdateStatus(); 
    return result;
} 

UpdateStatus()
{
    //string Meter ="\nH:" + (string)Health + " S:" + (string)Stamina + " M:" + (string)Mana + 
      //            "\nA:" + (string)Air + " F:" + (string)Food;
         string Meter ="\nH:" + (string)Health + " S:" + (string)Stamina + " M:" + (string)Mana + 
                  "\nA:" + (string)Air+" AC:"+(string)AClass + "\nF:" + (string)Food+"\n"+Race+"\n"+Class;
    if( State == -1 )
    {
        Meter = "*Dead: " + (string)Death +"*\n" + Meter;
    }    
    else if( State )
    {
        Meter = "*Unconsious*\n" + Meter;
    }
    if(Meter!=lastMeter)
    {
        llMessageLinked(LINK_SET, sf_update, Meter,NULL_KEY);
        lastMeter=Meter;
        llSay(-1176678,Meter);
    }
    llSay(-1176679,(string)Ammo);
}

default
{
    attach( key id )
    {
        if( ( id != NULL_KEY ) && ( id != OWNER_KEY ) )
        {
            llResetScript();
            
        }
        else if(id==NULL_KEY)
        {  
            reset=TRUE;
        }
        else
        {
            if(reset==TRUE) 
            {
                reset=FALSE;
                llPlaySound(ssound, volume);
                llMessageLinked(LINK_SET , 20, "start", NULL_KEY);
                state RegionList;
            }
        }
    } 
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
    }
    
    state_entry()
    {
        OWNER_KEY = llGetOwner();
        state RegionList;
    }
}

state combat 
{
    attach( key id )
    {
        
        if( ( id != NULL_KEY ) && ( id != OWNER_KEY ) )
        {
            llResetScript();

        }
        else if(id==NULL_KEY) //detached object
        {
            reset=TRUE;
        }
        else
        {

            if(reset==TRUE)
            {

                reset=FALSE;
                llPlaySound(ssound, volume);
                llMessageLinked(LINK_SET , 20, "start", NULL_KEY);
                state RegionList;
            }
        }
    } 
        
    changed(integer change) 
    {
        if (change & CHANGED_OWNER) llResetScript();
        if (change & CHANGED_REGION) state RegionList;

    }
    
    state_entry()
    {
        OWNER_KEY = llGetOwner();
        llRequestPermissions( OWNER_KEY, 
                              PERMISSION_TAKE_CONTROLS | 
                              PERMISSION_TRIGGER_ANIMATION );
    }

    run_time_permissions( integer perms )
    {
        if( perms & ( PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION ) )
        {            
            volume = 1;
            Water = llWater(<0,0,2.5>); 
            
            if (resurrecting==FALSE)
            {
                GetAVData(OWNER_KEY,["Name","Race","Class","Level","AClass","MWounded","Ressurections","Deaths"]);
                //Init();
            }
        
            //GetAVData(OWNER_KEY,["Name","Race","Class","Level","AClass"]);
            llSetTimerEvent( 1 );
        }
        else
        {
            llOwnerSay( "Failed to get the required permissions!" );
        }
    } 

    timer()
    {
        string result = timerTickElapsed();
        if (result == "DIE") 
        {
            state DEAD;   
        }
    }
    
    
        http_response(key id, integer status, list metadata, string body)
    {
       
        if(id != get_id) return;
        
        if(status != 200) body = "ERROR: CANNOT CONNECT TO SERVER";

        LoadAVData(body);

    }



    link_message(integer sender_number, integer number, string message, key id)
    {
        if((string)id == "HIT")
        {
            handleEffect(message, number);
        }
    }
}


state DEAD 
{
    state_entry() 
    {
        MWounded = MWounded +1;
        AddData(OWNER_KEY,["MWounded"], [MWounded]);
        //OWNER_KEY = llGetOwner();
        State = -1;
        DMax = 60;
        
        llRequestPermissions( OWNER_KEY, 
                              PERMISSION_TAKE_CONTROLS | 
                              PERMISSION_TRIGGER_ANIMATION );
        llSetTimerEvent( 0 );
        llSetTimerEvent( 1 );
        llTakeControls( 0, FALSE, FALSE );
        llStartAnimation( "dead" );
        llMessageLinked(LINK_THIS, 15, "mortaly", NULL_KEY);
        llShout(0, llKey2Name(OWNER_KEY)+" Has Been Mortally Wounded" );
        llSay(-458238,"atccshw");
    }

    timer()
    {
        string Meter;
        Meter = "*Mortally Wounded: " + format_time(--DMax) +"*\n" + Meter;
        llSay(-1176678,Meter);
        llMessageLinked(LINK_SET, sf_update, Meter,NULL_KEY);
        
        if(llGetTime()>=1.0)
        {
            llMessageLinked(LINK_SET,45,"ghost",NULL_KEY);
            llResetTime();
        }
        if(DMax == 30)
        {
            llShout(0,llKey2Name(OWNER_KEY)+" HAS 30 SECONDS LEFT!");
        }
        else if(DMax == 10)
        {
            llShout(0,llKey2Name(OWNER_KEY)+" HAS 10 SECONDS LEFT!");
        }
        else if (DMax == 0) 
        {
            llSetTimerEvent(0.0);
            state GHOST;
        }
    }
    
    link_message(integer sender_number, integer number, string message, key id)
    {
        if((string)id == "HIT")
        {
            if(message == EF_RES || message == EF_COMMAND || message == EF_RESET)
            {
                handleEffect(message, number);
            }
        }
    }
}

state GHOST
{
    state_entry() 
    {
          Deaths = Deaths + 1;
          AddData(OWNER_KEY,["Deaths"], [Deaths]);
          llMessageLinked(LINK_THIS, 15, "death", NULL_KEY); 
          llMessageLinked(LINK_SET, 45, "dead", NULL_KEY);
          llShout(0, llKey2Name(OWNER_KEY)+" Has Died" );
          llMessageLinked(LINK_SET, sf_update, "Died",NULL_KEY);
          llSay(-1176678,"Died");    
    }
} 

state NotACS
{
    state_entry() 
    {
        llMessageLinked(LINK_SET, sf_update, "Non ACS Region",NULL_KEY);
        //integer FTick       = 30; // to be activated later date
        llSay(-1176678,"Non ACS Region");
    }
    
    changed(integer change) 
    {
        if (change & CHANGED_OWNER) llResetScript();
        if (change & CHANGED_REGION) state RegionCheck;
    }

    attach(key attached) 
    {
        if (attached != NULL_KEY) state RegionCheck;
    }
}

state RegionList
{
        state_entry()
        {
            QueryData(["Region"],["Region"],["like"],["%"]);
        }

        
         http_response(key id, integer status, list metadata, string body)
    {
       
         if(id!=query_id) return;
        
        if(status != 200) body = "ERROR: CANNOT CONNECT TO SERVER";

        ACSRegions = llParseString2List(body,["^"],[]);
        //llSay(0, body);
        state RegionCheck;

    }
}


        
state RegionCheck
{
    state_entry()
    {
        string params = llGetRegionName();
        integer index = llListFindList(ACSRegions, [params]);
        if ( index != -1 )
        {
        GetData(llGetRegionName(),["Base","MMax","MCap ","AMMax","AMCap","SMax","SCap","DMax","FMax","BMax","BLMax",
        "PMax","AMax","ACap","NDmgMax","SDmgMax","ADmgMax","FAmtMax","FDmgMax","MDmgMax","HTick","MTick","STick","RSTick","FTick","ATick","RTick"]);
        }
        else state NotACS;
    }

    http_response(key id, integer status, list metadata, string body)
    {
       
        if(id != get_id) return;
        
        if(status != 200) body = "ERROR: CANNOT CONNECT TO SERVER";

        LoadSimServer(body);
        state combat;

    }
}

