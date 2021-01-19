// follow and attack / collide script
// 

string follow;          // who to follow, will be filled later...


startup()           // Initializing the Healing thingie
{
    llSensorRemove();           // remove any old sensor
    llSetPrimitiveParams([PRIM_PHYSICS, TRUE]);         //make prim not physical so it can not collide with the ground and die.. ;-)
    llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, TRUE);           //make the prim able to rotate itself on the x and y axis
    llSetStatus(STATUS_ROTATE_Z, TRUE);         //make the prim able to rotate itself on the z axis
    llSetStatus(STATUS_PHANTOM, FALSE);             //make the prim not phantom to let it be able to cause collisions
    llSetObjectName("atcsstrz08");
}


default
{
    state_entry()
    {
        startup();          //initialize
    }    
    on_rez(integer param)
    {
        startup();          //initialize
    }
    
    collision_start(integer total_number)
    {
        
        llDie();    // let the thingie die
        //llSay(0, "i would die now"); //debub line
    }




}