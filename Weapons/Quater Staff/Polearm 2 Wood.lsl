string AttackPrim = "Blocker";
default
{
    state_entry()
    {
    llCollisionSprite("");
    llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }
        on_rez(integer start_param)
    {
        llSetObjectName(AttackPrim);
        llSetTimerEvent(0.2);
    }
    collision_start(integer total_number)
    {
        llDie();
    }
    timer()
    {
       llDie();
    }
}