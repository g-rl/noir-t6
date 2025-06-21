#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm;
#include scripts\zm\buildables;
#include scripts\zm\functions;
#include scripts\zm\binds;
#include scripts\zm\utils;

main()
{
	replacefunc(maps\mp\zombies\_zm_blockers::blocker_trigger_think, ::blocker_trigger_think_o); // oom repairs
	replacefunc(maps\mp\zombies\_zm_weapons::weapon_give, ::weapon_give_o); // yeah aight bitch welcome to the meat show
}

init() // all var funcs are in utils.gsc
{
	level.db = true; // debug print update yeah 

	spawnpoints();
	announcer("sam");
	do_dvars();
	do_level_vars();
	do_zombie_vars();

	level thread on_player_connect();
	level thread cheap_box();
	level thread zombie_total();
	level thread open_seseme();
	level thread last_zombie();
	level thread remove_sky_barriers();
	setdvar( "player_lastStandBleedoutTime", 99999 );
	// wait before building craftables cause they can glitch out
	flag_wait( "start_zombie_round_logic" );
	wait 0.05;

	level thread buildbuildables();
	level thread buildcraftables();

	level.shader_weapons_list = strtok( "zom_hud_trample_steam_complete lui_loader_no_offset waypoint_revive_zm ks_menu_minigun_64 xenon_controller_top menu_zm_weapons_shield_big zm_riotshield_tomb_icon zm_riotshield_hellcatraz_icon xenon_stick_move minigun_alcatraz_zm scorebar_zom_1 menu_zm_popup hud_obit_death_suicide killiconheadshot hud_obit_death_suicide hud_tomahawk_zombies_dlc2 waypoint_revive_afterlife loadscreen_zm_transit_dr_zcleansed_diner loadscreen_zm_nuked_zstandard_nuked loadscreen_zm_highrise_zclassic_rooftop loadscreen_zm_prison_zclassic_prison loadscreen_zm_transit_zclassic_transit loadscreen_zm_transit_zstandard_farm loadscreen_zm_transit_zstandard_transit loadscreen_zm_buried_zclassic_processing loadscreen_zm_tomb_zclassic_tomb loadscreen_zm_transit_zstandard_farm specialty_fastreload_zombies_pro damage_feedback xenon_stick_turn xenon_stick_move zm_al_wth_zombie zm_tm_wth_dog xenon_stick_move_look xenon_stick_move_turn specialty_quickrevive_zombies_pro voice_off voice_off_xboxlive voice_on_xboxlive menu_zm_weapons_ballista menu_mp_weapons_m14 hud_python zm_hud_icon_oneinch_clean hud_cymbal_monkey zom_hud_craftable_element_water zom_hud_craftable_element_lightning zom_hud_craftable_element_fire zom_hud_craftable_element_wind hud_obit_grenade_launcher_attach hud_obit_death_grenade_round menu_mp_weapons_knife menu_mp_weapons_1911 menu_mp_weapons_judge menu_mp_weapons_kard menu_mp_weapons_five_seven menu_mp_weapons_dual57s menu_mp_weapons_ak74u menu_mp_weapons_mp5 menu_mp_weapons_qcw menu_mp_weapons_870mcs menu_mp_weapons_rottweil72 menu_mp_weapons_saiga12 menu_mp_weapons_srm menu_mp_weapons_m16 menu_mp_weapons_saritch menu_mp_weapons_xm8 menu_mp_weapons_type95 menu_mp_weapons_tar21 menu_mp_weapons_galil menu_mp_weapons_fal menu_mp_weapons_rpd menu_mp_weapons_hamr menu_mp_weapons_dsr1 menu_mp_weapons_m82a menu_mp_weapons_rpg menu_mp_weapons_m32gl menu_zm_weapons_raygun menu_zm_weapons_jetgun menu_zm_weapons_shield menu_mp_weapons_ballistic_80 menu_mp_weapons_hk416 menu_mp_weapons_lsat menu_mp_weapons_an94 menu_mp_weapons_ar57 menu_mp_weapons_svu menu_zm_weapons_slipgun menu_zm_weapons_hell_shield menu_mp_weapons_minigun menu_zm_weapons_blundergat menu_zm_weapons_acidgat menu_mp_weapons_ak47 menu_mp_weapons_uzi menu_zm_weapons_thompson menu_zm_weapons_rnma voice_off_mute_xboxlive menu_zm_weapons_raygun_mark2 menu_zm_weapons_mc96 menu_zm_weapons_mg08 menu_zm_weapons_stg44 menu_mp_weapons_scar menu_mp_weapons_ksg menu_zm_weapons_mp40 menu_mp_weapons_evoskorpion menu_mp_weapons_ballista menu_zm_weapons_staff_air menu_zm_weapons_staff_fire menu_zm_weapons_staff_lightning menu_zm_weapons_staff_water menu_zm_weapons_tomb_shield hud_icon_claymore_256 hud_grenadeicon hud_icon_sticky_grenade hud_obit_knife hud_obit_ballistic_knife menu_mp_weapons_baretta menu_zm_weapons_taser menu_mp_weapons_baretta93r menu_mp_weapons_olympia hud_obit_death_crush menu_zm_weapons_bowie hud_icon_sticky_grenade ui_arrow_right specialty_juggernaut_zombies_pro specialty_fastreload_zombies_pro emblem_bg_default zombies_rank_1 loadscreen_zm_meat zombies_rank_2 zombies_rank_3 zombies_rank_4 zombies_rank_5 zombies_rank_3_ded zombies_rank_4_ded zombies_rank_5_ded menu_zm_toomany_backing", " " );

	foreach ( shader in level.shader_weapons_list )
		precacheshader( shader );

	level ui_killfeed_setup();
}

on_player_connect()
{
	for(;;)
	{
		level waittill("connected", player);

		if ( isdefined( level.player_out_of_playable_area_monitor ) && level.player_out_of_playable_area_monitor )
			level.player_out_of_playable_area_monitor = 0;

		if ( isdefined( level.player_too_many_weapons_monitor ) && level.player_too_many_weapons_monitor )
			level.player_too_many_weapons_monitor = 0;

		if ( isdefined( level.player_in_screecher_zone ) && level.player_in_screecher_zone )
			level.player_in_screecher_zone = 1;

		player thread create_player(player);
		player thread ui_killfeed_get_num();
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
			self thread send_message("setting up...", 2.5);
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
		self waittill("player_revived");
		self.statusicon = "";
		thread add_perks();
	}
}

setup_player()
{
	self.statusicon = "";
	// watch_pos();
	add_score(8750);
	player_vars();
	// new_origin(spawnpoint()); // set new spawn points (if any)

	if(level.script == "zm_prison") wait 11; // motd crash temp fix
	thread host_checks();
	thread init_blackout();
	thread init_no_clip();
	thread auto_refill();
	thread disable_quotes();
	thread binds();
	thread rand_class();
	thread damagehitmarker();
	thread zombiesaimbot();
	thread add_perks(); // keep this last

	self iprintln("noir by ^3@nyli2b");
}

create_player(nigga) // 😂😂😂😂
{
	nigga thread on_player_spawned();
	nigga thread first_raise_watcher();
}