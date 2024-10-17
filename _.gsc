#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm;
#include scripts\zm\buildables;
#include scripts\zm\functions;
#include scripts\zm\binds;
#include scripts\zm\utils;

/# self [[self.test_func]](arg1,arg2,arg3);
   self.test_func = ::test_func;
   self.[[key("test")]] = ::test_func ????
#/

main()
{
	replacefunc(maps\mp\zombies\_zm_blockers::blocker_trigger_think, ::blocker_trigger_think_o); // oom repairs
	replacefunc(maps\mp\zombies\_zm_weapons::weapon_give, ::weapon_give_o); // yeah aight bitch welcome to the meat show
}

init() // all var funcs are in utils.gsc
{
	level.db = true; // debug print update yeah 

	spawnpoints(level.script);
	announcer("sam");

	do_dvars();
	do_level_vars();
    do_zombie_vars();

    level thread on_player_connect();
    level thread new_hitmarkers();
    level thread cheap_box();
    level thread zombie_total();
	level thread open_seseme();
	level thread last_zombie();

	// wait before building craftables cause they can glitch out
    flag_wait( "start_zombie_round_logic" );
	wait 0.05;

	level thread buildbuildables();
	level thread buildcraftables();
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);
		player thread create_player(player);
    }
}

on_player_spawned()
{
    self endon("disconnect");
    level endon("game_ended");

	self.pers["in_barrier"] = false;

	center_text_init();
	create_notify();

    for(;;)
    {
        self waittill("spawned_player");

		// 10/13/24 - make sure everything is right
        if (!flag("initial_blackscreen_passed")) 
		{
            self thread send_message("setting up...");
            flag_wait("initial_blackscreen_passed");
        }

		thread setup_player();
    }
}

on_player_downed()
{
	self endon("disconnect");
	level endon("end_game");

	for(;;)
	{
		self waittill_any("player_downed", "fake_death", "entering_last_stand", "al_t");	
		self.statusicon = "hud_status_dead";
	}
}

on_player_revived()
{
    self endon("disconnect");
    level endon("end_game");

    for(;;)
    {
		if(getdvar("mapname") == "zm_prison") return; // motd crash fix possibly - EDIT: it doesnt fix shit
		self waittill("player_revived");
		self.statusicon = "";
		add_perks();
    }
}

setup_player()
{
	self.statusicon = "";
	add_score(8750);
	player_vars();
	new_origin(level.new_spawn); // set new spawn points (if any)
	thread host_checks();
	thread init_blackout();
	thread init_no_clip();
	thread auto_refill();
	thread disable_quotes();
	// watch_pos();
	thread binds();

	self thread rand_class();

	add_perks();
}

create_player(nigga) // 😂😂😂😂
{
	nigga thread on_player_spawned();
	nigga thread first_raise_watcher();
}