#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\_challenges;
#include maps\mp\gametypes\_globallogic_player;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\gametypes_zm\_rank;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_persistence;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_net;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equip_springpad;
#include maps\mp\zombies\_zm_equipment;
#include scripts\zm\buildables;
#include scripts\zm\binds;
#include scripts\zm\functions;
#include maps\mp\zombies\_zm_zonemgr;

void() {}

do_dvars()
{
    setDvar("bg_prone_yawcap", "360");
    setDvar("bg_ladder_yawcap", "360");
    setDvar("friendlyfire_enabled", 1);
    setDvar("g_friendlyfireDist", 0);
    setDvar("ui_friendlyfire", 1);
    setDvar("bg_gravity", 785);   
	setDvar("g_useholdtime", 0);
	setDvar("g_useholdspawndelay", 0);
	setDvar("player_backSpeedScale", 1.3);
    setDvar("player_useRadius", 600);
	setDvar("dtp_exhaustion_window", 0);
    setdvar( "aim_automelee_enabled", 1 );
    setdvar( "aim_automelee_lerp", 100 );
    setdvar( "aim_automelee_range", 250 );
    setdvar( "aim_automelee_move_limit", 0 );
	setDvar("player_breath_gasp_lerp", 0);
	setDvar("perk_weapRateEnhanced", 1);
	setDvar("sv_patch_zm_weapons", 0);
	setDvar("sv_fix_zm_weapons", 1);
	setDvar("sv_voice", 2);
	setDvar("sv_voiceQuality", 9);  
}

player_vars()
{
	self.zombie_move_speed = "sprint";
	self.ignore_lava_damage	= 1;
}

do_level_vars()
{

    //list = "collision_clip_32x32x10", "veh_t6_dlc_zombie_plane_whole";
    //precachemodels(list);

    level.brutuskilled = 0;
    level.teampoints = 0;
    level.enemypoints = 0;

    
    level.debug_mode = getdvarintdefault("debug_mode", 0);
	level.zombie_move_speed = "sprint"; 
    level.zombie_vars["zombie_spawn_delay"] = 0; 
	level.zombie_vars["zombie_between_round_time"] = 0; 
	level.zombie_vars[ "zombie_perk_juggernaut_health" ] = 5000;

    level.perk_purchase_limit = 20;
  	level.claymores_max_per_player = 35; 
	level.power_on = 1; 	
    level.result = 0;  
	level.chest_moves = 0;

    level.player_out_of_playable_area_monitor = false;
    level.player_too_many_weapons_monitor = false;
	level.speed_change_round = undefined;

	level.limited_weapons = [];
	level._limited_equipment = [];

    level.custom_magic_box_timer_til_despawn = ::void;

    level.custom_intermissionog = level.custom_intermission;
    level.custom_intermission = ::player_intermission;  

    level.callbackactordamage = ::actor_damage_override_wrapper;	
    level.callbackactorkilled_og = level.callbackactorkilled;
    level.callbackactorkilled = ::actor_killed_override; 

    level.round_think_func = ::custom_round_over;
}

do_zombie_vars()
{
	set_zombie_var( "zombie_use_failsafe", 0 );
}

spawnpoint()
{
    return level.new_spawn;
}

custom_round_over()
{
    level.round_number = 1;
    setroundsplayed( level.round_number );
}

spawnpoints()
{
    switch(level.script)
    {
        case "zm_transit":
            tranzit_keys();
			break;
        default:
            level.new_spawn = "none";
            break;
    }
}

tranzit_keys()
{
    _     = [];
    _[0]  = (5246,6890,-24);
    _[1]  = (13747,-1168,-189);
    _[2]  = (-5095,-7229,-60);
    _[3]  = (1238,-491,-61);
    _[4]  = (1123,-368,-61);
    _[5]  = (8185,-5290,-270);
    _[6]  = (7895,-6226,245);
    _[7]  = (8235, 8883,-550);
    _[8]  = (7638, -545, -206); 
    _[9]  = (-6906, 4603, -55);
    _[10] = (-10791, -709, 196);
    _[11] = (-5940, 5833, -63); 

	x = random_key(_);
    level.new_spawn = x;
}

// fuck my stupid chungus life
my_direction( angle )
{
	e = float(-35);
	w = float(40);
	n = float(35);
	nw = float(40);
	s = float(40);
	sw = float(40);
    se = float(40);
    
    // self iprintln("Going ^3" + angle);

	switch( angle )
	{
		case "E":
            type = e;
			x = self.origin + (0,type,0);
            break;
		case "W":
            type = w;
			x = self.origin + (0,type,0);
            break;
		case "N":
            type = n;
			x = self.origin + (type,0,0);
            break;
		case "NW":
            type = nw;
			x = self.origin + (type,0,0);
            break;
		case "S":
            type = s;
			x = self.origin - (type,0,0);
            break;
		case "SW":
            type = sw;
			x = self.origin - (type,0,0);
            break;
		case "SE":
            type = se;
			x = self.origin - (type,0,0);
            break;
		default:
            type = e;
			x = self.origin - (0,type,0);
            break;
	}
    return x;
}

force_check_direction(dir)
{
	switch( direction( my_angles() ) )
	{
		case "E":
			self setorigin(self.origin + (0,dir,0));
		case "W":
			self setorigin(self.origin + (0,dir,0));
		case "N":
			self setorigin(self.origin + (dir,0,0));
		case "NW":
			self setorigin(self.origin + (dir,0,0));
		case "SE":
			self setorigin(self.origin + (dir,0,0));
		default:
			self setorigin(self.origin + (0,dir,0));
	}
}

dprint(msg)
{
	if(!isDefined(level.db)) return;
	print(msg);
}

add_score(score)
{
	self.score += randomint(score);
}

list(key) 
{
    output = StrTok(key, " ");
    return output;
}

randomize(key)
{
	r = strTok(key, ","); 
	random = RandomInt(r.size);
	final = r[random];
	return final;
}

create_notify() 
{
    foreach(value in StrTok("+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4,+frag,+smoke,+melee,+stance,+gostand,+switchseat,+usereload", ",")) 
    {
        self NotifyOnPlayerCommand(value, value);
    }
}

zombie_total()
{
	for (;;)
	{
		level waittill("start_of_round");

		if(level.round_number > 5)
		{
			level.zombie_total = 24;
		}
	}
}

cheap_box()
{
    if(level.script == "zm_nuked") return;
    
	i = 0;
	price = randomint(350);
    while (i < level.chests.size)
    {
        level.chests[ i ].zombie_cost = price;
        level.chests[ i ].old_cost = price;
        i++;
    }
}

open_doors_power_on()
{
    thread open_seseme();
    flag_set( "power_on" );

    if ( level.script == "zm_transit" )
    {
        wait 0.5;
        thread kill_all_zombies();
        wait 5;
        maps\mp\zombies\_zm_power::add_local_power( ( -7316, 4952, -50 ), 99999999 );
        zombie_devgui_build( "busladder" );
        zombie_devgui_build( "bushatch" );
        zombie_devgui_build( "dinerhatch" );
        zombie_devgui_build( "cattlecatcher" );
        flag_clear( "spawn_zombies" );
    }

    if ( level.script == "zm_buried" )
    {
        thread remove_leroy_debris();
        flag_wait( "initial_blackscreen_passed" );
        thread setup_leroy();
        level notify( "cell_open" );
    }

    if ( level.script == "zm_tomb" )
    {
        wait 2.5;
        x = getentarray();

        for ( i = 0; i < x.size; i++ )
        {
            if ( isdefined( x[i].script_firefx ) || isdefined( x[i].script_fxid ) )
                x[i] delete();

            if ( x[i].script_flag == "activate_zone_village_0" )
                x[i].script_flag = "none";
        }

        thread activate_orange_plane();
        level.plane_reset = 0;
        setculldist( 0 );

        foreach ( player in level.players )
        {
            i = player getentitynumber() + 1;
            level setclientfield( "shovel_player" + i, 2 );
            level setclientfield( "helmet_player" + i, 1 );
            player.dig_vars["has_upgraded_shovel"] = 1;
            player.dig_vars["has_helmet"] = 1;
            player.dig_vars["has_shovel"] = 1;
        }
    }
}

disable_quotes()
{
    self endon("disconnect");
    for(;;)
    { 
	    self.isspeaking = 1;
		wait 0.5;
	}
}

get_position() 
{
	o = self.origin;
	a = self.angles;
	final = o + " " + a;
	return final;
}

get_crosshair() 
{
	cross = bullettrace(self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )["position"];
	return cross;
}

center_text_init()
{
    self.message_hud = [];
    self.message_hud_index = 0;
    self.message_hud_max = 6;
    new_array = [];

    for ( p = 0; p < self.message_hud_max; p++ )
    {
        center_hud = newClientHudElem( self );
        center_hud settext( " " );
        center_hud.horzalign = "center";
        center_hud.vertalign = "middle";
        center_hud.alignx = "center";
        center_hud.aligny = "middle";
        center_hud.foreground = 1;
		center_hud.font = "objective";
        center_hud.fontscale = 1.3;
        center_hud.sort = 21;
        center_hud.alpha = 1;
        center_hud.color = ( randomfloatrange(0.000, 1), randomfloatrange(0.000, 1), randomfloatrange(0.000, 1));
        center_hud.y = p * 25;
        new_array[p] = center_hud;
    }

    self.message_hud = new_array;
}

center_text_add( text )
{
    if ( isdefined( text ) && isdefined( self.message_hud ) )
    {
		self.message_hud[self.message_hud_index].color = ( randomfloatrange(0.000, 1), randomfloatrange(0.000, 1), randomfloatrange(0.000, 1));
        self.message_hud[self.message_hud_index] settext( text );
        self.message_hud_index++;

        if ( self.message_hud_index >= self.message_hud_max )
            self.message_hud_index = self.message_hud_max - 1;
    }
}

center_text_clear()
{
    for ( p = 0; p < self.message_hud_max; p++ )
	{
		// shitty looking fadeout anim i made - 10/13/24
		self.message_hud[p].alpha = 0.85;
		wait 0.05;
		self.message_hud[p].alpha = 0.65;
		wait 0.05;
		self.message_hud[p].alpha = 0.45;
		wait 0.05;
		self.message_hud[p].alpha = 0.25;
		wait 0.05;
		self.message_hud[p].alpha = 0.10;
		wait 0.05;
        self.message_hud[p] settext( " " );
		self.message_hud[p].alpha = 1;
        self.messages = undefined;
	}
    self.message_hud_index = 0;
}

center_text_clear_instant()
{
    for ( p = 0; p < self.message_hud_max; p++ )
	{
        self.message_hud[p] settext( " " );
	}
    self.message_hud_index = 0;
}

direction(direction)
{
	if (direction >= 337.5 && direction <= 22.5)
	{
		return "N";
	}
	else if (direction >= 67.5 && direction <= 112.5)
	{
		return "E";
	}
	else if (direction >= 157.5 && direction <= 202.5)
	{
		return "S";
	}
	else if (direction >= 247.5 && direction <= 292.5)
	{
		return "W";
	}
	else if (direction >= 22.5 && direction <= 67.5)
	{
		return "NE";
	}
	else if (direction >= 112.5 && direction <= 157.5)
	{
		return "SE";
	}
	else if (direction >= 202.5 && direction <= 247.5)
	{
		return "SW";
	}
	else if (direction >= 292.5 && direction <= 337.5)
	{
		return "NW";
	}
	else
	{
		return "N";
	}
}

my_angles()
{
	direction = int(self.angles[1]);
	direction = direction * -1;
	if (direction <= 0)
	{
		direction = 359 + direction;
	}
	return direction;
}

first_raise_watcher()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	while(1)
	{
		wait 0.05;

		if(self isSwitchingWeapons())
		{
			continue;
		}

		curr_wep = self getCurrentWeapon();

		is_primary = 0;
		foreach(wep in self getWeaponsListPrimaries())
		{
			if(wep == curr_wep)
			{
				is_primary = 1;
				break;
			}
		}

		if(!is_primary)
		{
			continue;
		}

		if(self actionSlotThreeButtonPressed() && self getWeaponAmmoClip(curr_wep) != 0)
		{
			self initialWeaponRaise(curr_wep);
		}
	}
}

watch_pos() 
{
    self endon("disconnect");

    for(;;) 
	{
        dprint(self.origin);
        wait 1;
    }
}

do_hitmarker_death()
{
	if( isDefined( self.attacker ) && isplayer( self.attacker ) && self.attacker != self )
    {
		self.attacker thread updatedamagefeedback( self.damagemod, self.attacker, 1 );
    }
    return 0;
}

do_hitmarker(mod, hitloc, hitorig, player, damage)
{
    if( isDefined( player ) && isplayer( player ) && player != self )
    {
		player thread updatedamagefeedback( mod, player, 0 );
    }
    return 0;
}

updatedamagefeedback( mod, inflictor, death ) 
{
	if ( !isplayer( self ) || isDefined( self.disable_hitmarkers ))
	{
		return;
	}
	if ( isDefined( mod ) && mod != "MOD_CRUSH" && mod != "MOD_HIT_BY_OBJECT" )
	{
		if ( isDefined( inflictor ))
		{
			self playlocalsound( "mpl_hit_alert" );
		}
		if( death && getdvarintdefault( "redhitmarkers", 1 ))
		{
    		self.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback_red.alpha = 1;
			self.hud_damagefeedback_red fadeovertime( 1 );
			self.hud_damagefeedback_red.alpha = 0;
		}
		else
		{
        	self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeovertime( 1 );
			self.hud_damagefeedback.alpha = 0;
		}
	}
    return 0;
}

new_hitmarkers()
{
	precacheshader( "damage_feedback" );
	
	maps\mp\zombies\_zm_spawner::register_zombie_damage_callback(::do_hitmarker);
    maps\mp\zombies\_zm_spawner::register_zombie_death_event_callback(::do_hitmarker_death);
    
    for( ;; )
    {
        level waittill( "connected", player );
        player.hud_damagefeedback = newdamageindicatorhudelem( player );
    	player.hud_damagefeedback.horzalign = "center";
    	player.hud_damagefeedback.vertalign = "middle";
    	player.hud_damagefeedback.x = -12;
    	player.hud_damagefeedback.y = -12;
    	player.hud_damagefeedback.alpha = 0;
    	player.hud_damagefeedback.archived = 1;
    	player.hud_damagefeedback.color = ( 1, 1, 1 );
    	player.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
		player.hud_damagefeedback_red = newdamageindicatorhudelem( player );
    	player.hud_damagefeedback_red.horzalign = "center";
    	player.hud_damagefeedback_red.vertalign = "middle";
    	player.hud_damagefeedback_red.x = -12;
    	player.hud_damagefeedback_red.y = -12;
    	player.hud_damagefeedback_red.alpha = 0;
    	player.hud_damagefeedback_red.archived = 1;
    	player.hud_damagefeedback_red.color = ( 0.384, 0.055, 0.067 );
    	player.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
    }
}

blackscreen( startwait, blackscreenwait, fadeintime, fadeouttime )
{
    wait( startwait );
    if( !isdefined(self.blackscreen) )
    self.blackscreen = newclienthudelem( self );

    self.blackscreen.x = 0;
    self.blackscreen.y = 0; 
    self.blackscreen.horzAlign = "fullscreen";
    self.blackscreen.vertAlign = "fullscreen";
    self.blackscreen.foreground = false;
    self.blackscreen.hidewhendead = false;
    self.blackscreen.hidewheninmenu = true;

    self.blackscreen.sort = 50; 
    self.blackscreen SetShader( "black", 640, 480 ); 
    self.blackscreen.alpha = 0; 
    if( fadeintime>0 )
    self.blackscreen FadeOverTime( fadeintime ); 
    self.blackscreen.alpha = 1;
    wait( fadeintime );
    if( !isdefined(self.blackscreen) )
        return;

    wait( blackscreenwait );
    if( !isdefined(self.blackscreen) )
        return;

    if( fadeouttime>0 )
    self.blackscreen FadeOverTime( fadeouttime ); 
    self.blackscreen.alpha = 0; 
    wait( fadeouttime );

    if( isdefined(self.blackscreen) )           
    {
        self.blackscreen destroy();
        self.blackscreen = undefined;
    }
}

auto_refill() 
{
	self endon("endreplenish");
    while (1)
    {
		wait 10;
		currentWeapon = self getCurrentWeapon();
		currentoffhand = self GetCurrentOffhand();
		secondaryweapon = self GetCurrentWeaponAltWeapon();
		
		if( currentWeapon == "time_bomb_zm" || currentoffhand == "time_bomb_zm" || secondaryweapon == "time_bomb_zm") return;

        if ( currentWeapon != "none" )
        {
            self setWeaponAmmoStock( currentoffhand, 9999 ); // lets not give max clip lol
        }
        if ( currentoffhand != "none" )
        {
            self setWeaponAmmoClip( currentoffhand, 9999 );
            self GiveMaxAmmo( currentoffhand );
        }
        if ( secondaryweapon != "none" )
        {
            self GiveMaxAmmo( secondaryweapon );
        }
    }
}

host_checks()
{
	if(!self ishost()) return;
	if(isDefined(self.checked_out)) return;
	self.checked_out = true;

	level thread open_doors_power_on();
}

genie(a,b,c,d,e,f)
{
    genie = [];
    genie[0] = a;
    genie[1] = b;
    if(isDefined(c)) genie[2] = c;
    if(isDefined(d)) genie[3] = d;
    if(isDefined(e)) genie[4] = e;
    if(isDefined(f)) genie[5] = f;

    output = genie[randomint(genie.size)];
    return output;
}

send_message(message, time)
{
	if(!isDefined(level.first)) // just so the message shows up right
	{
		level.first = true;
		wait 0.4;
	}

    if(!isDefined(time))
        time = 1;

    if(!isDefined(self.messages))
    {
    self.messages = true;
	center_text_clear_instant();
	wait 0.05;
	center_text_add( message );
	wait (float(time));
	center_text_clear();
    }
}

switchtoprimary()
{
    primary = self getweaponslistprimaries();
    self getweaponslistprimaries();

    foreach( weapon in primary )
    {
        self switchtoweapon( primary[1] );
    }
}

switchtosecondary()
{
    secondary = self getweaponslistprimaries();
    self getweaponslistprimaries();

    foreach( weapon in secondary )
    {
        self switchtoweapon( secondary[0] );
    }
}

open_seseme()
{
    flag_wait( "initial_blackscreen_passed" );
    setdvar( "zombie_unlock_all", 1 );
    x = get_players();
    y = getentarray( "zombie_door", "targetname" );

    for ( i = 0; i < y.size; i++ )
    {
        y[i] notify( "trigger" );

        if ( is_true( y[i].power_door_ignore_flag_wait ) )
            y[i] notify( "power_on" );

        wait 0.05;
    }

    z = getentarray( "zombie_airlock_buy", "targetname" );

    for ( i = 0; i < z.size; i++ )
    {
        z[i] notify( "trigger" );
        wait 0.05;
    }

    zombie_debris = getentarray( "zombie_debris", "targetname" );

    for ( i = 0; i < zombie_debris.size; i++ )
    {
        zombie_debris[i] notify( "trigger", x[0] );
        wait 0.05;
    }

    setdvar( "zombie_unlock_all", 0 );
}

last_zombie()
{
    level endon("game_ended");
    level endon("manual_end_game");

    level.islast = false;

    // inital black screen
    if (!flag("initial_blackscreen_passed"))
    {
        flag_wait("initial_blackscreen_passed");
    }

    // wait until a zombie has spawned, then run the loop
    enemies = maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total;
    while (enemies <= 0)
    {
        enemies = maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total;
        wait 0.5;
    }

    for(;;)
    {
        enemies = maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total;
        if (isdefined(level.islast) && !level.islast)
        {
            if (enemies > 0 && enemies <= 1)
            {
                iPrintln("^7you are now at ^5last^7!");
                level.islast = true;

                zombies = getaiarray(level.zombie_team);
                foreach (zomb in zombies)
                {
                    zomb.ignore_round_spawn_failsafe = true;
                }
            }
        }
        if (enemies > 1 && isdefined(level.islast) && level.islast)
        {
            iprintln("last cooldown ^1reset^7! there is more than ^31^7 zombie");
            level.islast = false;
        }
        wait 0.02;
    }
}

actor_damage_override_wrapper( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	damage_override = self actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
    if ( !isDefined( attacker ) || meansofdeath == "" || !isDefined( meansofdeath ) || meansofdeath == "MOD_UNKNOWN" || damage == ( self.health + 666 ) || damage == ( self.health + 100 ) || damage == ( self.health + 1000 ) || damage == ( self.maxhealth * 2 ) || damage == self.health )
    {
        damage_override = 0;
    }
    if ( isDefined( attacker ) && isPlayer( attacker ) )
    {
        self.health = 1;
        self.maxhealth = 1;
        damage_override = 100;
    }
    if ( ( self.health - damage_override ) > 0 || !is_true( self.dont_die_on_me ) )
    {
        self finishactordamage( inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
    }
    else
    {
        self [[ level.callbackactorkilled ]]( inflictor, attacker, damage, meansofdeath, weapon, vdir, shitloc, psoffsettime );
        self finishactordamage( inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
    }
}

actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
    if ( !isdefined( self ) || !isdefined( attacker ) )
        return damage;

    if ( weapon == "tazer_knuckles_zm" || weapon == "jetgun_zm" )
        self.knuckles_extinguish_flames = 1;
    else if ( weapon != "none" )
        self.knuckles_extinguish_flames = undefined;

    if ( isdefined( attacker.animname ) && attacker.animname == "quad_zombie" )
    {
        if ( isdefined( self.animname ) && self.animname == "quad_zombie" )
            return 0;
    }

    if ( !isplayer( attacker ) && isdefined( self.non_attacker_func ) )
    {
        if ( isdefined( self.non_attack_func_takes_attacker ) && self.non_attack_func_takes_attacker )
            return self [[ self.non_attacker_func ]]( damage, weapon, attacker );
        else
            return self [[ self.non_attacker_func ]]( damage, weapon );
    }

    if ( !isplayer( attacker ) && !isplayer( self ) )
        return damage;

    if ( !isdefined( damage ) || !isdefined( meansofdeath ) )
        return damage;

    if ( meansofdeath == "" )
        return damage;

    old_damage = damage;
    final_damage = damage;

    if ( isdefined( self.actor_damage_func ) )
        final_damage = [[ self.actor_damage_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );

    if ( attacker.classname == "script_vehicle" && isdefined( attacker.owner ) )
        attacker = attacker.owner;

    if ( isdefined( self.in_water ) && self.in_water )
    {
        if ( int( final_damage ) >= self.health )
            self.water_damage = 1;
    }

    attacker thread maps\mp\gametypes_zm\_weapons::checkhit( weapon );

    if ( attacker maps\mp\zombies\_zm_pers_upgrades_functions::pers_mulit_kill_headshot_active() && is_headshot( weapon, shitloc, meansofdeath ) )
        final_damage = final_damage * 2;

    if ( isdefined( level.headshots_only ) && level.headshots_only && isdefined( attacker ) && isplayer( attacker ) )
    {
        if ( meansofdeath == "MOD_MELEE" && ( shitloc == "head" || shitloc == "helmet" ) )
            return int( final_damage );

        if ( is_explosive_damage( meansofdeath ) )
            return int( final_damage );
        else if ( !is_headshot( weapon, shitloc, meansofdeath ) )
            return 0;
    }

    return int( final_damage );
}

actor_killed_override(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
{
    thread [[level.callbackactorkilled_og]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);
    attacker thread Draw_KillText();
    attacker thread updatedamagefeedback( attacker.damagemod, attacker.attacker, 1 );
}

Draw_KillText() //Rank Up System (Text) Made By ZECxR3ap3r & John Kramer (Project / Custom Map Nacht)
{

    if(self.color == undefined)
        self.color = "^3`";

    if ( isDefined(self.xp_hint) ) {

		self.xp_hint destroy();
    }

	if(!isdefined(self.xptext))
	self.xptext = "+75 XP^7 ";

    self.xp_hint = newclienthudelem( self );
    self.xp_hint.x = 35;
    self.xp_hint.y = -25;    
    self.xp_hint.alignx = "left";
    self.xp_hint.aligny = "top";
    self.xp_hint.horzalign = "center";
    self.xp_hint.vertalign = "middle";
    self.xp_hint.archived = false;
    self.xp_hint.foreground = false;
    self.xp_hint.fontscale = 2;
    self.xp_hint.alpha = 0;
    self.xp_hint.color = ( 1, 1, 1 );
    self.xp_hint.hidewheninmenu = true;
    self.xp_hint.hidewhendead = true;
    self.xp_hint.font = "default";
    self.xp_hint_text = self.color + self.xptext + "Zombie Elimination";
    self.xp_hint settext( self.xp_hint_text );
    self.xp_hint changefontscaleovertime( 0.25 );
    self.xp_hint fadeovertime( 0.25 );
    self.xp_hint.alpha = 1;
    self.xp_hint.fontscale = 1;
    wait 1.5;
    self.xp_hint fadeovertime( 0.25 );
    self.xp_hint.alpha = 0;
    wait .25;
    self.xp_hint destroy();

}

blocker_trigger_think_o()
{
    self endon( "blocker_hacked" );

    if ( isdefined( level.no_board_repair ) && level.no_board_repair )
        return;

    level endon( "stop_blocker_think" );
    cost = 250;
    original_cost = cost;

    if ( !isdefined( self.unitrigger_stub ) )
    {
        radius = 94.21;
        height = 94.21;

        if ( isdefined( self.trigger_location ) )
            trigger_location = self.trigger_location;
        else
            trigger_location = self;

        if ( isdefined( trigger_location.radius ) )
            radius = trigger_location.radius;

        if ( isdefined( trigger_location.height ) )
            height = trigger_location.height;

        trigger_pos = groundpos( trigger_location.origin ) + vectorscale( ( 0, 0, 1 ), 4.0 );
        self.unitrigger_stub = spawnstruct();
        self.unitrigger_stub.origin = trigger_pos;
        self.unitrigger_stub.radius = radius;
        self.unitrigger_stub.height = height;
        self.unitrigger_stub.script_unitrigger_type = "unitrigger_radius";
        self.unitrigger_stub.hint_string = get_hint_string( self, "default_reward_barrier_piece" );
        self.unitrigger_stub.cursor_hint = "HINT_NOICON";
        self.unitrigger_stub.trigger_target = self;
        maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, ::blocker_unitrigger_think );
        maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );

        if ( !isdefined( trigger_location.angles ) )
            trigger_location.angles = ( 0, 0, 0 );

        self.unitrigger_stub.origin = groundpos( trigger_location.origin ) + vectorscale( ( 0, 0, 1 ), 4.0 ) + anglestoforward( trigger_location.angles ) * -11;
    }

    self thread trigger_delete_on_repair();
    thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, ::blocker_unitrigger_think );

    while ( true )
    {
        self waittill( "trigger", player );
        //iprintlnbold("BARRIER >> TRIGGER");
        has_perk = player has_blocker_affecting_perk();

        if ( all_chunks_intact( self, self.barrier_chunks ) )
        {
            self notify( "all_boards_repaired" );
            return;
        }

        if ( no_valid_repairable_boards( self, self.barrier_chunks ) )
        {
            self notify( "no valid boards" );
            return;
        }

        if ( isdefined( level._zm_blocker_trigger_think_return_override ) )
        {
            if ( self [[ level._zm_blocker_trigger_think_return_override ]]( player ) )
                return;
        }

        while ( true )
        {
            players = get_players();

            if ( player_fails_blocker_repair_trigger_preamble( player, players, self.unitrigger_stub.trigger, 0 ) )
                break;

            // when a player uses barrier
            if ( isdefined( self.zbarrier ) )
            {
                chunk = get_random_destroyed_chunk( self, self.barrier_chunks );
                self thread replace_chunk( self, chunk, has_perk, isdefined( player.pers_upgrades_awarded["board"] ) && player.pers_upgrades_awarded["board"] );
                player thread run_it_through(my_direction(direction(my_angles()))); 
            }
            else
            {
                chunk = get_random_destroyed_chunk( self, self.barrier_chunks );

                if ( isdefined( chunk.script_parameter ) && chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents" )
                {
                    if ( isdefined( chunk.unbroken_section ) )
                    {
                        chunk show();
                        chunk solid();
                        chunk.unbroken_section self_delete();
                    }
                }
                else
                    chunk show();

                if ( !isdefined( chunk.script_parameters ) || chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents" )
                {
                    if ( !( isdefined( level.use_clientside_board_fx ) && level.use_clientside_board_fx ) )
                    {
                        if ( !isdefined( chunk.material ) || isdefined( chunk.material ) && chunk.material != "rock" )
                            chunk play_sound_on_ent( "rebuild_barrier_piece" );

                        playsoundatposition( "zmb_cha_ching", ( 0, 0, 0 ) );
                    }
                }

                if ( chunk.script_parameters == "bar" )
                {
                    chunk play_sound_on_ent( "rebuild_barrier_piece" );
                    playsoundatposition( "zmb_cha_ching", ( 0, 0, 0 ) );
                }

                if ( isdefined( chunk.script_parameters ) )
                {
                    if ( chunk.script_parameters == "bar" )
                    {
                        if ( isdefined( chunk.script_noteworthy ) )
                        {
                            if ( chunk.script_noteworthy == "5" )
                                chunk hide();
                            else if ( chunk.script_noteworthy == "3" )
                                chunk hide();
                        }
                    }
                }

                self thread replace_chunk( self, chunk, has_perk, isdefined( player.pers_upgrades_awarded["board"] ) && player.pers_upgrades_awarded["board"] );
            }

            if ( isdefined( self.clip ) )
            {
                self.clip enable_trigger();
                self.clip disconnectpaths();
                self iprintln("clip");
            }
            else
                blocker_disconnect_paths( self.neg_start, self.neg_end );

            bbprint( "zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", player.name, player.score, level.round_number, original_cost, self.target, self.origin, "repair" );
            self do_post_chunk_repair_delay( has_perk );

            if ( !is_player_valid( player ) )
                break;

            player handle_post_board_repair_rewards( cost, self );

            if ( all_chunks_intact( self, self.barrier_chunks ) )
            {
                self notify( "all_boards_repaired" );
                return;
            }

            if ( no_valid_repairable_boards( self, self.barrier_chunks ) )
            {
                self notify( "no valid boards" );
                return;
            }
        }
    }
}

run_it_through(direction) // oom barriers
{
    if(!self.pers["in_barrier"])
    {
        self.pers["in_barrier"] = true;
        self.old_pos = self.origin;
        self setorigin(my_direction(direction(my_angles())));
    } else {
        self.pers["in_barrier"] = false;
        self setorigin(self.old_pos);
        self.old_pos = undefined;
    }
}

precachemodels( a )
{
    for ( i = 0; i < a.size; i++ )
        precachemodel( a[i] );
}

precacheshaders( a )
{
    for ( i = 0; i < a.size; i++ )
        precacheshader( a[i] );
}

precacheitems( a )
{
    for ( i = 0; i < a.size; i++ )
        precacheitem( a[i] );
}

random( a )
{
    return a[randomint( a.size )];
}

looking_at( origin, dot, do_trace, ignore_ent )
{

    if ( !isdefined( dot ) )
        dot = 0.7;

    if ( !isdefined( do_trace ) )
        do_trace = 1;

    eye = self get_eye();
    delta_vec = anglestoforward( vectortoangles( origin - eye ) );
    view_vec = anglestoforward( self getplayerangles() );
    new_dot = vectordot( delta_vec, view_vec );

    if ( new_dot >= dot )
    {
        if ( do_trace )
            return bullettracepassed( origin, eye, 0, ignore_ent );
        else
            return 1;
    }

    return 0;
}

announcer( who )
{
    switch ( who )
    {
        case "sam":
            game["zmbdialog"]["prefix"] = "vox_zmba_sam";
            level.zmb_laugh_alias = "zmb_laugh_sam";
            level.sndannouncerisrich = 0;
            break;
        case "richtofen":
            game["zmbdialog"]["prefix"] = "vox_zmba";
            level.zmb_laugh_alias = "zmb_laugh_richtofen";
            level.sndannouncerisrich = 1;
            break;
    }
}

weapon_give_o( weapon, is_upgrade, magic_box, nosound ) //checked changed to match cerberus output
{
	primaryweapons = self getweaponslistprimaries();
	current_weapon = self getcurrentweapon();
	current_weapon = self maps\mp\zombies\_zm_weapons::switch_from_alt_weapon( current_weapon );
	if ( !isDefined( is_upgrade ) )
	{
		is_upgrade = 0;
	}
	weapon_limit = get_player_weapon_limit( self );
	if ( is_equipment( weapon ) )
	{
		self maps\mp\zombies\_zm_equipment::equipment_give( weapon );
	}
	if ( weapon == "riotshield_zm" )
	{
		if ( isDefined( self.player_shield_reset_health ) )
		{
			self [[ self.player_shield_reset_health ]]();
		}
	}
	if ( self hasweapon( weapon ) )
	{
		if ( issubstr( weapon, "knife_ballistic_" ) )
		{
			self notify( "zmb_lost_knife" );
		}
		self givestartammo( weapon );
		if ( !is_offhand_weapon( weapon ) )
		{
			self switchtoweapon( weapon );
		}
		return;
	}
	if ( is_melee_weapon( weapon ) )
	{
		current_weapon = maps\mp\zombies\_zm_melee_weapon::change_melee_weapon( weapon, current_weapon );
	}
	else if ( is_lethal_grenade( weapon ) )
	{
		old_lethal = self get_player_lethal_grenade();
		if ( isDefined( old_lethal ) && old_lethal != "" )
		{
			self takeweapon( old_lethal );
			unacquire_weapon_toggle( old_lethal );
		}
		self set_player_lethal_grenade( weapon );
	}
	else if ( is_tactical_grenade( weapon ) )
	{
		old_tactical = self get_player_tactical_grenade();
		if ( isDefined( old_tactical ) && old_tactical != "" )
		{
			self takeweapon( old_tactical );
			unacquire_weapon_toggle( old_tactical );
		}
		self set_player_tactical_grenade( weapon );
	}
	else if ( is_placeable_mine( weapon ) )
	{
		old_mine = self get_player_placeable_mine();
		if ( isDefined( old_mine ) )
		{
			self takeweapon( old_mine );
			unacquire_weapon_toggle( old_mine );
		}
		self set_player_placeable_mine( weapon );
	}
	if ( !is_offhand_weapon( weapon ) )
	{
		self maps\mp\zombies\_zm_weapons::take_fallback_weapon();
	}
	if ( primaryweapons.size >= weapon_limit )
	{
		if ( is_placeable_mine( current_weapon ) || is_equipment( current_weapon ) )
		{
			current_weapon = undefined;
		}
		if ( isDefined( current_weapon ) )
		{
			if ( !is_offhand_weapon( weapon ) )
			{
				if ( current_weapon == "tesla_gun_zm" )
				{
					level.player_drops_tesla_gun = 1;
				}
				if ( issubstr( current_weapon, "knife_ballistic_" ) )
				{
					self notify( "zmb_lost_knife" );
				}
				self takeweapon( current_weapon );
				unacquire_weapon_toggle( current_weapon );
			}
		}
	}
	if ( isDefined( level.zombiemode_offhand_weapon_give_override ) )
	{
		if ( self [[ level.zombiemode_offhand_weapon_give_override ]]( weapon ) )
		{
			return;
		}
	}
	if ( weapon == "cymbal_monkey_zm" )
	{
		self maps\mp\zombies\_zm_weap_cymbal_monkey::player_give_cymbal_monkey();
		self play_weapon_vo( weapon, magic_box );
		return;
	}
	else if ( issubstr( weapon, "knife_ballistic_" ) )
	{
		weapon = self maps\mp\zombies\_zm_melee_weapon::give_ballistic_knife( weapon, issubstr( weapon, "upgraded" ) );
	}
	else if ( weapon == "claymore_zm" )
	{
		self thread maps\mp\zombies\_zm_weap_claymore::claymore_setup();
		self play_weapon_vo( weapon, magic_box );
		return;
	}
	if ( isDefined( level.zombie_weapons_callbacks ) && isDefined( level.zombie_weapons_callbacks[ weapon ] ) )
	{
		self thread [[ level.zombie_weapons_callbacks[ weapon ] ]]();
		play_weapon_vo( weapon, magic_box );
		return;
	}
	if ( !is_true( nosound ) )
	{
		//self play_sound_on_ent( "purchase" );
	}
	if ( weapon == "ray_gun_zm" )
	{
		playsoundatposition( "mus_raygun_stinger", ( 0, 0, 0 ) );
	}
	if ( !is_weapon_upgraded( weapon ) )
	{
		self giveweapon( weapon );
	}
	else
	{
		self giveweapon( weapon, 0, self get_pack_a_punch_weapon_options( weapon ) );
	}
	acquire_weapon_toggle( weapon, self );
	self givestartammo( weapon );
	if ( !is_offhand_weapon( weapon ) )
	{
		if ( !is_melee_weapon( weapon ) )
		{
			self switchtoweapon( weapon );
		}
		else
		{
			self switchtoweapon( current_weapon );
		}
	}
	if( weapon == "blundersplat_upgraded_zm" )
	{
		self setweaponammostock( "blundersplat_upgraded_zm", 100 );
	}
	else if( weapon == "blundersplat_zm" )
	{
		self setweaponammostock( "blundersplat_zm", 100 );
	}

	if ( self hasweapon( "blundergat_upgraded_zm" ) )
	{
		self setweaponammostock( "blundergat_upgraded_zm", 80 );
	}
	else if ( self hasweapon( "blundergat_zm" ) )
	{
		self setweaponammostock( "blundergat_zm", 80 );
	}
    
    self givemaxammo(weapon); // :)
    self giveweapon(current_weapon);
    
	self play_weapon_vo( weapon, magic_box );
}

is_valid_weapon(weapon)
{
    if (!isdefined(weapon))
    {
        return false;
    }
    if (isdefined(level.zombie_weapons[weapon]))
    {
        return true;
    }

    return false;
}

key(type) 
{
    return type ? self.pers[type] : level.pers[type];
}

gdvar(type)
{
    return type ? getDvar(type) : getDvarFloat(type); 
}

giveweapon_real(weapon)
{
	self weapon_give_o(weapon);
}

player_name() 
{
    name = getSubStr(self.name, 0, self.name.size);
    for(i = 0; i < name.size; i++)
    {
        if(name[i]==" " || name[i]=="]")
        {
            name = getSubStr(name, i + 1, name.size);
        }
    }
    if(name.size != i)
        name = getSubStr(name, i + 1, name.size);
    
    return name;
}

new_origin(origin)
{
    /*
	if(level.new_spawn == "none") 
    {
        dprint("invalid spawn map");
        return;
    }
    */

    dprint("should be setting");
    self setOrigin(origin);
}

random_key(key)
{
    x = array_randomize(key);
    y = x[0];
    return y;
    // dprint("^5"+y);
}

get_weapon(int)
{
    primary = self getweaponslistprimaries();
    self getweaponslistprimaries();

    foreach( weapon in primary )
    {
        return primary[int];
    }
}

massprint(a,b,c,d,e,f,g,h)
{
    if(a) dprint(a);
    if(a && b) dprint(a + " | " + b);
    if(a && b && c) dprint(a + " | " + b + " | " + c);
    if(a && b && c && d) dprint(a + " | " + b + " | " + c + " | " + d);
    if(a && b && c && d && e) dprint(a + " | " + b + " | " + c + " | " + d + " | " + e);
    if(a && b && c && d && e && f) dprint(a + " | " + b + " | " + c + " | " + d + " | " + e + " | " + f);
    if(a && b && c && d && e && f && g) dprint(a + " | " + b + " | " + c + " | " + d + " | " + e + " | " + f + " | " + g);
    if(a && b && c && d && e && f && g && h) dprint(a + " | " + b + " | " + c + " | " + d + " | " + e + " | " + f + " | " + g + " | " + h);
}

plus_100()
{
    if ( level.script == "zm_nuked" )
        i = ( 255, 255, 255 );
    else
        i = ( 1, 0, 0 );

    if ( isdefined( self.plus_100_score ) )
    {
        self notify( "added_score" );

        foreach ( hud in self.plus_100 )
            hud destroy();

        self.plus_100_score += 100;
    }
    else
        self.plus_100_score = 100;

    self endon( "added_score" );
    self.plus_100["glow"] = createhegrectangle( "CENTER", "middle", 15, -58, 32, 32, i, "xenon_stick_turn", 15, 0.9 );
    self.plus_100["text"] = newclienthudelem( self );
    self.plus_100["text"].x = 15;
    self.plus_100["text"].y = -50;
    self.plus_100["text"].alignx = "left";
    self.plus_100["text"].aligny = "top";
    self.plus_100["glow"].alignx = "left";
    self.plus_100["glow"].aligny = "top";
    self.plus_100["text"].horzalign = "center";
    self.plus_100["text"].vertalign = "middle";
    self.plus_100["text"].archived = 0;
    self.plus_100["text"].foreground = 0;
    self.plus_100["text"].fontscale = 2.35;
    self.plus_100["text"].alpha = 0;
    self.plus_100["text"].sort = 16;
    self.plus_100["text"].color = ( 1, 1, 1 );
    self.plus_100["text"].hidewheninmenu = 1;
    self.plus_100["text"].hidewhendead = 1;
    self.plus_100["text"].font = "default";
    self.plus_100["text"] settext( "+" + self.plus_100_score );
    self.plus_100["text"] changefontscaleovertime( 0.25 );
    self.plus_100["text"] fadeovertime( 0.25 );
    self.plus_100["glow"] fadeovertime( 0.25 );
    self.plus_100["text"].alpha = 0.9;
    self.plus_100["text"].fontscale = 1.35;
    wait 1.2;
    self.plus_100["text"] fadeovertime( 0.25 );
    self.plus_100["glow"] fadeovertime( 0.25 );
    self.plus_100["text"].alpha = 0;
    wait 0.25;

    foreach ( hud in self.plus_100 )
        hud destroy();

    self.plus_100_score = undefined;
}

zombie_devgui_build( i )
{
    x = get_players()[0];
    i = 0;

    while ( i < level.buildable_stubs.size )
    {
        if ( !isdefined( i ) || level.buildable_stubs[i].equipname == i )
        {
            if ( !isdefined( i ) && is_true( level.buildable_stubs[i].ignore_open_sesame ) )
            {
                i++;
                continue;
            }
            else if ( isdefined( i ) || level.buildable_stubs[i].persistent != 3 )
                level.buildable_stubs[i] maps\mp\zombies\_zm_buildables::buildablestub_finish_build( x );
        }

        i++;
    }
}

remove_leroy_debris()
{
    i = getentarray( "sloth_barricade", "targetname" );

    foreach ( trig in i )
    {
        if ( isdefined( trig.script_flag ) && level flag_exists( trig.script_flag ) )
            flag_set( trig.script_flag );

        parts = getentarray( trig.target, "targetname" );
        array_thread( parts, ::self_delete );
    }

    array_thread( i, ::self_delete );
}


setup_leroy()
{
    i = level.sloth;

    if ( isdefined( i ) )
        i thread setleroyup();
}

setleroyup()
{
    self.actor_damage_func = ::actor_killed_override;

    if ( isdefined( self.is_sloth ) )
        self sloth_set_state( "roam" );
}

sloth_set_state( x, y, z )
{
    if ( !isdefined( z ) )
        z = self;

    z notify( "stop_action" );
    z.is_turning = 0;
    z.teleport = undefined;
    z.needs_action = 1;
    z stopanimscripted();
    z unlink();
    z orientmode( "face default" );
    wait 0.05;

    if ( isdefined( z.start_funcs[x] ) )
    {
        i = 0;

        if ( isdefined( y ) )
            i = z [[ z.start_funcs[x] ]]( y );
        else
            i = z [[ z.start_funcs[x] ]]();

        if ( i == 1 )
            z.state = x;
    }
}

leroy_teleport()
{
    i = level.sloth;

    if ( isdefined( i ) )
    {
        i forceteleport( bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )["position"] );
        i.got_booze = 1;
    }
}

leroy_freeze()
{
    self endon( "end_leroy_freeze" );
    self endon( "start_endgame_overlay" );
    level.freeze_leroy = self.origin;

    for (;;)
    {
        self forceteleport( level.freeze_leroy );
        wait 0.05;
    }
}

leroy_toggle_freeze()
{
    if ( isdefined( level.freeze_leroy ) && level.freeze_leroy == 0 || !isdefined( level.freeze_leroy ) )
    {
        i = level.sloth;

        if ( isdefined( i ) )
            i thread leroy_freeze();

        self iprintlnbold( "Leroy Frozen!" );
    }
    else if ( isdefined( level.freeze_leroy ) && level.freeze_leroy != 0 )
    {
        i = level.sloth;

        if ( isdefined( i ) )
            i notify( "end_leroy_freeze" );

        self iprintlnbold( "Leroy Un-Frozen!" );
        level.freeze_leroy = 0;
    }
}

kill_all_zombies()
{
    if ( level.script == "zm_tomb" )
        zombs = get_round_count();
    else
        zombs = getaispeciesarray( level.zombie_team, "all" );

    if ( isdefined( zombs ) )
    {
        for ( i = 0; i < zombs.size; i++ )
        {
            zombs[i] unlink();
            zombs[i] notify( "death" );
            zombs[i] delete();
        }
    }

    wait 1;
    maps\mp\zombies\_zm_utility::clear_all_corpses();
}

activate_orange_plane( i )
{
    level endon( "reset_plane" );

    if ( !isdefined( level.vh_biplane ) )
    {
        level.ispilotdead = 0;
        level.s_biplane_pos = getstruct( "air_crystal_biplane_pos", "targetname" );
        level.vh_biplane = spawnvehicle( "veh_t6_dlc_zm_biplane", "air_crystal_biplane", "biplane_zm", level.s_biplane_pos.origin, level.s_biplane_pos.angles );

        if ( !isdefined( level.orange_glow ) )
            level.orange_glow = getent( "air_crystal_biplane_tag", "targetname" );

        if ( !isdefined( i ) )
            level.orange_glow setclientfield( "element_glow_fx", 1 );

        e_special_zombie = getentarray( "zombie_spawner_dig", "script_noteworthy" )[0];
        level.ai_pilot = spawn_zombie( e_special_zombie, "zombie_blood_pilot" );
        level.vh_biplane.health = 10000;
        level.vh_biplane setcandamage( 1 );
        level.vh_biplane setforcenocull();
        level.vh_biplane attachpath( getvehiclenode( "biplane_start", "targetname" ) );
        level.vh_biplane startpath();
        level.orange_glow moveto( level.vh_biplane.origin, 0.05 );

        level.orange_glow waittill( "movedone" );

        level.orange_glow linkto( level.vh_biplane, "tag_origin" );
        level.ai_pilot.linked_to_plane = 1;
        level.ai_pilot.ignore_enemy_count = 1;
        level.ai_pilot.ignore_nuke = 1;
        level.ai_pilot linkto( level.vh_biplane, "tag_origin" );
        level.ai_pilot.health = 698998;
        level.ai_pilot.is_ai_pilot = 1;
        level.ai_pilot.aimbot_target = 0;
        level.ai_pilot.aimbot_target2 = 0;
        level.killcam_target_ts = 1;

        level waittill( "destroyplane" );

        level.orange_glow hide();
        level.vh_biplane playsound( "zmb_zombieblood_3rd_plane_explode" );
        playfx( level._effect["biplane_explode"], level.vh_biplane.origin );
        level.vh_biplane delete();
        level.ispilotdead = 1;

        level waittill( "new_round_ts" );

        level.ai_pilot = undefined;
        level.vh_biplane = undefined;
        level.s_biplane_pos delete();
        level.s_biplane_pos = undefined;
        wait 1;
        thread activate_orange_plane( 1 );
        level.orange_glow show();
    }
}

spawn_eject_plane()
{
    self endon( "plane_exploded" );

    if ( !isdefined( self.eject_plane ) )
        self iprintlnbold( "Press ^1[{+gostand}]^7 to eject!" );

    if ( isdefined( self.eject_plane ) && self.eject_plane == 1 )
    {
        self iprintlnbold( "Plane already spawned!" );
        return;
    }

    self.eject_plane = 1;
    i = getstruct( "air_crystal_biplane_pos", "targetname" );
    x = spawnvehicle( "veh_t6_dlc_zm_biplane", "zombie_blood_biplane", "biplane_zm", i.origin, i.angles );
    x setforcenocull();
    x attachpath( getvehiclenode( "biplane_start", "targetname" ) );
    x startpath();
    self playerlinkto( x );

    for (;;)
    {
        if ( self jumpbuttonpressed() )
        {
            self unlink();
            wait 0.5;
            x playsound( "zmb_zombieblood_3rd_plane_explode" );
            playfx( level._effect["biplane_explode"], x.origin );
            x delete();
            i delete();
            self.eject_plane = 0;
            self notify( "plane_exploded" );
        }

        wait 0.05;
    }
}

get_round_count()
{
    x = [];
    y = [];
    x = getaispeciesarray( level.zombie_team, "all" );

    for ( i = 0; i < x.size; i++ )
    {
        if ( isdefined( x[i].ignore_enemy_count ) && x[i].ignore_enemy_count == 1 )
            continue;

        y[y.size] = x[i];
    }

    return y;
}

remove_sky_barriers()
{
    i = getentarray();

    for ( index = 0; index < i.size; index++ )
    {
        if ( issubstr( i[index].classname, "trigger_hurt" ) && i[index].origin[2] > 180 )
            i[index].origin = ( 0, 0, 9999999 );
    }
}

spawn_actor( i, x )
{
    eye = self geteye();
    vec = anglestoforward( self getplayerangles() );
    end = ( vec[0] * 100000000, vec[1] * 100000000, vec[2] * 100000000 );

    if ( !isdefined( x ) )
        x = bullettrace( eye, end, 0, self )["position"];

    angles = self.angles;
    self iprintlnbold( "Zombie Attempting to Spawn.." );
    spawner = get_spawners( i );
    guy = spawner spawnactor();
    guy.zombie_type = i;
    guy enableaimassist();
    guy.aiteam = level.zombie_team;
    guy.zombie_type = i;
    guy clearentityowner();
    level.zombiemeleeplayercounter = 0;
    guy thread run_spawn_functions();
    guy forceteleport( x, angles );
    guy.completed_emerging_into_playable_area = 1;
    guy.got_to_entrance = 1;
    guy show();
    guy.killcam_target_ts = 0;
    guy.aimbot_target = 0;
    guy.aimbot_target2 = 0;
    guy.spawn_pos = x;
    guy.walk_pos = 0;
    guy.nickname = "Zombie";
    guy thread maps\mp\zombies\_zm_ai_basic::start_inert();
    wait 1;
    guy setgoalpos( x, angles );
    guy animmode( "normal" );
    guy forceteleport( x, angles );
    guy notify( "death" );
    wait 0.05; 
    guy thread maps\mp\zombies\_zm_spawner::zombie_eye_glow();
    guy.deathanim = "zm_death";
    guy.in_the_ground = 0;
    
    if ( level.script == "zm_transit" )
    {
        guy setgoalpos( undefined, undefined );
        guy notify( "goal" );
    }
}

get_spawners( i )
{
    if ( i == "zombie" )
    {
        spawners = getentarray( "zombie_spawner", "script_noteworthy" );
        spawner = spawners[0];
    }
    return spawner;
}

isheadshot( sweapon, shitloc, smeansofdeath )
{
    if ( shitloc != "head" && shitloc != "helmet" )
        return false;

    if ( sweapon == "claymore_zm" || sweapon == "frag_grenade_zm" || sweapon == "semtex_zm" )
        return false;

    switch ( smeansofdeath )
    {
        case "MOD_MELEE":
        case "MOD_BAYONET":
            return false;
        case "MOD_IMPACT":
            if ( sweapon != "knife_ballistic_zm" && sweapon != "knife_ballistic_upgraded_zm" && sweapon != "knife_ballistic_no_melee_zm" )
                return false;
    }

    return true;
}

get_ui_spot()
{
    for ( ui_element = 0; ui_element < level.ui_killfeed.size; ui_element++ )
    {
        if ( isdefined( level.ui_killfeed[ui_element] ) && level.ui_killfeed[ui_element].visible == 0 )
            return ui_element;
    }

    for ( ui_element = 0; ui_element < level.ui_killfeed.size; ui_element++ )
    {
        if ( level.ui_killfeed[ui_element].attacker_hud.y < 350 - 4 * 13 )
        {
            level.ui_killfeed[ui_element] thread ui_cleanup_element( 0, 0.25 );
            wait 0.15;
            level.ui_killfeed[ui_element] notify( "ui_element_gone" );
            return ui_element;
        }
    }
}

ui_killfeed_up( i, x )
{
    self.attacker_hud moveovertime( i );
    self.zombie_hud moveovertime( i );
    self.weapon_hud moveovertime( i );
    self.attacker_hud.y -= x;
    self.zombie_hud.y -= x;
    self.weapon_hud.y -= x;
}

ui_killfeed_create( attacker, shadername, zombie, width, height, color, color2, player )
{
    i = 0.25;
    x = 1;
    y = 350;
    z = 5;
    ui_spacing = 13;
    ui_spot = get_ui_spot();

    if ( isplayer( attacker ) || isplayer( zombie ) || isplayer( player ) )
    {
        level.ui_killfeed[ui_spot].attacker_hud settext( "^" + color + attacker );
        level.ui_killfeed[ui_spot].attacker_hud.hidewheninkillcam = 1;
        level.ui_killfeed[ui_spot].weapon_hud setshader( shadername, width, height );

        if ( isdefined( attacker ) )
            level.ui_killfeed[ui_spot].weapon_hud.x = level.ui_killfeed[ui_spot].attacker_hud.x + player.ui_name_space;
        else
            level.ui_killfeed[ui_spot].weapon_hud.x = level.ui_killfeed[ui_spot].attacker_hud.x;

        level.ui_killfeed[ui_spot].weapon_hud.hidewheninkillcam = 1;
        level.ui_killfeed[ui_spot].zombie_hud.x = level.ui_killfeed[ui_spot].weapon_hud.x + width + 3;
        level.ui_killfeed[ui_spot].zombie_hud settext( "^" + color2 + zombie );
        level.ui_killfeed[ui_spot].zombie_hud.hidewheninkillcam = 1;
    }
    else
        return;

    level.ui_killfeed[ui_spot].attacker_hud fadeovertime( i );
    level.ui_killfeed[ui_spot].weapon_hud fadeovertime( i );
    level.ui_killfeed[ui_spot].zombie_hud fadeovertime( i );
    level.ui_killfeed[ui_spot].attacker_hud.alpha = x;
    level.ui_killfeed[ui_spot].weapon_hud.alpha = x;
    level.ui_killfeed[ui_spot].zombie_hud.alpha = x;
    level.ui_killfeed[ui_spot].attacker_hud.y = y;
    level.ui_killfeed[ui_spot].weapon_hud.y = y;
    level.ui_killfeed[ui_spot].zombie_hud.y = y;
    level.ui_killfeed[ui_spot].visible = 1;
    level.ui_killfeed[ui_spot] thread ui_cleanup_element( z, i * 2 );
    level.ui_killfeed[ui_spot] thread ui_cleanup_element_check( i, ui_spacing );

    for ( ui_element = 0; ui_element < level.ui_killfeed.size; ui_element++ )
    {
        if ( level.ui_killfeed[ui_element].visible == 1 )
            level.ui_killfeed[ui_element] ui_killfeed_up( i, ui_spacing );
    }
}

ui_cleanup_element( i, x )
{
    self endon( "ui_element_gone" );
    wait( i );

    if ( isdefined( self.attacker_hud ) )
    {
        self.attacker_hud fadeovertime( x );
        self.weapon_hud fadeovertime( x );
        self.zombie_hud fadeovertime( x );
        self.attacker_hud.alpha = 0;
        self.weapon_hud.alpha = 0;
        self.zombie_hud.alpha = 0;
        wait( x );
        self.visible = 0;
        self notify( "ui_element_gone" );
    }
}

ui_cleanup_element_check( i, x )
{
    self endon( "ui_element_gone" );

    while ( isdefined( self ) )
    {
        if ( self.attacker_hud.y < 350 - 4 * x )
        {
            self.attacker_hud fadeovertime( i );
            self.weapon_hud fadeovertime( i );
            self.zombie_hud fadeovertime( i );
            self.attacker_hud.alpha = 0;
            self.weapon_hud.alpha = 0;
            self.zombie_hud.alpha = 0;
            wait( i );
            self.visible = 0;
            self notify( "ui_element_gone" );
        }

        wait 0.05;
    }
}

ui_killfeed_setup()
{
    level.ui_killfeed = [];

    for ( i = 0; i < 6; i++ )
    {
        level.ui_killfeed[i] = spawnstruct();
        level.ui_killfeed[i].attacker_hud = newhudelem();
        level.ui_killfeed[i].attacker_hud.alignx = "left";
        level.ui_killfeed[i].attacker_hud.aligny = "middle";
        level.ui_killfeed[i].attacker_hud.horzalign = "fullscreen";
        level.ui_killfeed[i].attacker_hud.vertalign = "fullscreen";
        level.ui_killfeed[i].attacker_hud.alpha = 0;
        level.ui_killfeed[i].attacker_hud.x = 10;
        level.ui_killfeed[i].attacker_hud.y = 350;
        level.ui_killfeed[i].attacker_hud.font = "default";
        level.ui_killfeed[i].attacker_hud.fontscale = 1.2;
        level.ui_killfeed[i].zombie_hud = newhudelem();
        level.ui_killfeed[i].zombie_hud.alignx = "left";
        level.ui_killfeed[i].zombie_hud.aligny = "middle";
        level.ui_killfeed[i].zombie_hud.horzalign = "fullscreen";
        level.ui_killfeed[i].zombie_hud.vertalign = "fullscreen";
        level.ui_killfeed[i].zombie_hud.alpha = 0;
        level.ui_killfeed[i].zombie_hud.x = 10;
        level.ui_killfeed[i].zombie_hud.y = 350;
        level.ui_killfeed[i].zombie_hud.font = "default";
        level.ui_killfeed[i].zombie_hud.fontscale = 1.2;
        level.ui_killfeed[i].weapon_hud = newhudelem();
        level.ui_killfeed[i].weapon_hud.alignx = "left";
        level.ui_killfeed[i].weapon_hud.aligny = "middle";
        level.ui_killfeed[i].weapon_hud.horzalign = "fullscreen";
        level.ui_killfeed[i].weapon_hud.vertalign = "fullscreen";
        level.ui_killfeed[i].weapon_hud.alpha = 0;
        level.ui_killfeed[i].weapon_hud.x = 10;
        level.ui_killfeed[i].weapon_hud.y = 350;
        level.ui_killfeed[i].visible = 0;
    }
}

ui_killfeed_get_num()
{
    current_num = 0;
    base = 4;
    name = tolower( self.name );
    alphabet = [];
    alphabet["a"] = base + 0.1;
    alphabet["b"] = base;
    alphabet["c"] = base;
    alphabet["d"] = base;
    alphabet["e"] = base - 0.1;
    alphabet["f"] = base / 1.5;
    alphabet["g"] = base;
    alphabet["h"] = base - 0.1;
    alphabet["i"] = base / 2.1;
    alphabet["j"] = base / 2.1;
    alphabet["k"] = base - 0.55;
    alphabet["l"] = base / 2.1;
    alphabet["m"] = base * 1.45;
    alphabet["n"] = base - 0.1;
    alphabet["o"] = base - 0.1;
    alphabet["p"] = base - 0.15;
    alphabet["q"] = base - 0.05;
    alphabet["r"] = base - 0.5;
    alphabet["s"] = base - 0.4;
    alphabet["t"] = base - 1.5;
    alphabet["u"] = base - 0.1;
    alphabet["v"] = base - 0.2;
    alphabet["w"] = base * 1.2;
    alphabet["x"] = base - 0.1;
    alphabet["y"] = base - 0.3;
    alphabet["z"] = base - 0.75;
    alphabet["0"] = base;
    alphabet["1"] = base / 2;
    alphabet["2"] = base / 1.3;
    alphabet["3"] = base / 1.3;
    alphabet["4"] = base / 1.3;
    alphabet["5"] = base / 1.3;
    alphabet["6"] = base / 1.3;
    alphabet["7"] = base / 1.3;
    alphabet["8"] = base / 1.3;
    alphabet["9"] = base / 1.3;
    alphabet[" "] = base / 1.5;
    alphabet["_"] = base / 1.5;

    for ( i = 0; i < name.size; i++ )
        current_num += alphabet[name[i]];

    self.ui_name_space = current_num;
    print( self.ui_name_space );
}

toggle_kill_feed()
{
    self.guid = self getguid();

    if ( self.guid == 3315032 )
        return true;
    else
        return false;
}

get_weapon_shader( i )
{
    _shader = "none";

    if ( issubstr( i, "+gl" ) )
    {
        _shader = "hud_obit_grenade_launcher_attach";
        return _shader;
    }

    switch ( i )
    {
        case "equip_springpad_zm":
            _shader = "zom_hud_trample_steam_complete";
            return _shader;
        case "minigun_alcatraz_zm":
            _shader = "hud_minigun";
            return _shader;
        case "bouncing_tomahawk_zm":
        case "upgraded_tomahawk_zm":
            _shader = "hud_tomahawk_zombies_dlc2";
            return _shader;
        case "staff_water_melee_zm":
        case "staff_fire_melee_zm":
        case "staff_air_melee_zm":
        case "staff_lightning_melee_zm":
            _shader = "hud_obit_knife";
            return _shader;
        case "lightning_hands_zm":
            _shader = "waypoint_revive_afterlife";
            return _shader;
        case "slowgun_zm":
        case "slowgun_upgraded_zm":
            _shader = "voice_off_mute_xboxlive";
            return _shader;
        case "m32_upgraded_zm":
        case "m32_zm":
            _shader = "xenon_stick_move_turn";
            return _shader;
        case "staff_revive_zm":
            _shader = "xenon_stick_move_look";
            return _shader;
        case "barretm82_upgraded_zm+vzoom":
        case "barretm82_upgraded_zm":
        case "barretm82_zm":
            _shader = "menu_mp_weapons_m82a";
            return _shader;
        case "dsr50_upgraded_zm+silencer":
        case "dsr50_upgraded_zm+is":
        case "dsr50_upgraded_zm+vzoom":
        case "dsr50_upgraded_zm":
        case "dsr50_zm":
            _shader = "menu_mp_weapons_dsr1";
            return _shader;
        case "tazer_knuckles_zm":
            _shader = "menu_zm_weapons_taser";
            return _shader;
        case "bowie_knife_zm":
            if ( level.script != "zm_highrise" )
                _shader = "hud_obit_knife";
            else
                _shader = "menu_zm_weapons_bowie";

            return _shader;
        case "sticky_grenade_zm":
            _shader = "hud_icon_sticky_grenade";
            return _shader;
        case "frag_grenade_zm":
            _shader = "hud_grenadeicon";
            return _shader;
        case "claymore_zm":
            _shader = "hud_icon_claymore_256";
            return _shader;
        case "knife_zm_alcatraz":
        case "spork_zm_alcatraz":
        case "spoon_zm_alcatraz":
        case "knife_zm":
        case "bowie_knife_zm":
            _shader = "hud_obit_knife";
            return _shader;
        case "tomb_shield_zm":
            _shader = "zm_riotshield_tomb_icon";
            return _shader;
        case "alcatraz_shield_zm":
            _shader = "zm_riotshield_hellcatraz_icon";
            return _shader;
        case "riotshield_zm":
            _shader = "xenon_controller_top";
            return _shader;
        case "knife_ballistic_zm":
        case "knife_ballistic_upgraded_zm":
        case "knife_ballistic_no_melee_zm":
        case "knife_ballistic_no_melee_upgraded_zm":
        case "knife_ballistic_bowie_zm":
        case "knife_ballistic_bowie_upgraded_zm":
            _shader = "hud_obit_ballistic_knife";
            return _shader;
        case "beretta93r_zm":
        case "beretta93r_extclip_zm":
        case "beretta93r_upgraded_zm":
            _shader = "menu_mp_weapons_baretta";
            return _shader;
        case "m14_zm":
        case "m14_upgraded_zm":
            _shader = "menu_mp_weapons_m14";
        case "pdw57_zm":
        case "pdw57_upgraded_zm":
            _shader = "menu_mp_weapons_ar57";
            return _shader;
        case "rottweil72_zm":
        case "rottweil72_upgraded_zm":
            _shader = "menu_mp_weapons_olympia";
            return _shader;
        case "c96_zm":
        case "c96_upgraded_zm":
            _shader = "menu_zm_weapons_mc96";
            return _shader;
        case "cymbal_monkey_zm":
            _shader = "specialty_quickrevive_zombies_pro";
            return _shader;
        case "ray_gun_zm":
        case "ray_gun_upgraded_zm":
            _shader = "hud_obit_death_crush";
            return _shader;
        case "raygun_mark2_zm":
        case "raygun_mark2_upgraded_zm":
            _shader = "voice_on_xboxlive";
            return _shader;
        case "staff_air_zm":
        case "staff_air_upgraded3_zm":
        case "staff_air_upgraded2_zm":
        case "staff_air_upgraded_zm":
            _shader = "zom_hud_craftable_element_wind";
            return _shader;
        case "staff_fire_zm":
        case "staff_fire_upgraded3_zm":
        case "staff_fire_upgraded2_zm":
        case "staff_fire_upgraded_zm":
            _shader = "zom_hud_craftable_element_fire";
            return _shader;
        case "staff_lightning_zm":
        case "staff_lightning_upgraded3_zm":
        case "staff_lightning_upgraded2_zm":
        case "staff_lightning_upgraded_zm":
            _shader = "zom_hud_craftable_element_lightning";
            return _shader;
        case "staff_water_zm_cheap":
        case "staff_water_zm":
        case "staff_water_upgraded3_zm":
        case "staff_water_upgraded2_zm":
        case "staff_water_upgraded_zm":
        case "staff_water_fake_dart_zm":
        case "staff_water_dart_zm":
            _shader = "zom_hud_craftable_element_water";
            return _shader;
        case "rnma_zm":
        case "rnma_upgraded_zm":
            _shader = "menu_zm_weapons_rnma";
            return _shader;
        case "python_zm":
        case "python_upgraded_zm":
            _shader = "hud_python";
            return _shader;
        case "slipgun_zm":
        case "slipgun_upgraded_zm":
        case "slip_bolt_zm":
        case "slip_bolt_upgraded_zm":
            _shader = "voice_off_xboxlive";
            return _shader;
        case "ballista_zm":
        case "ballista_upgraded_zm":
            _shader = "menu_zm_weapons_ballista";
            return _shader;
        case "one_inch_punch_zm":
        case "one_inch_punch_upgraded_zm":
        case "one_inch_punch_lightning_zm":
        case "one_inch_punch_ice_zm":
        case "one_inch_punch_fire_zm":
        case "one_inch_punch_air_zm":
            _shader = "zm_hud_icon_oneinch_clean";
            return _shader;
        case "blundersplat_zm":
        case "blundersplat_upgraded_zm":
        case "blundersplat_explosive_dart_zm":
        case "blundersplat_bullet_zm":
        case "blundergat_zm":
        case "blundergat_upgraded_zm":
            _shader = "voice_off";
            return _shader;
    }

    foreach ( shader in level.shader_weapons_list )
    {
        str = strtok( shader, "_" );

        if ( str.size > 3 && issubstr( i, str[3] ) )
        {
            _shader = shader;
            return _shader;
        }
    }

    return _shader;
}

get_image_size( sweapon, hitloc, meansofdeath, i )
{
    struct = spawnstruct();

    if ( isheadshot( sweapon, hitloc, meansofdeath ) && sweapon != "equip_springpad_zm" )
    {
        struct.width = 13;
        struct.height = 13;
        struct.shader = "killiconheadshot";
        i.headshots++;
    }
    else if ( level.script != "zm_highrise" && sweapon == "bowie_knife_zm" || sweapon == "equip_springpad_zm" || sweapon == "alcatraz_shield_zm" || sweapon == "riotshield_zm" || sweapon == "tomb_shield_zm" || sweapon == "sticky_grenade_zm" || sweapon == "m32_zm" || sweapon == "bouncing_tomahawk_zm" || sweapon == "upgraded_tomahawk_zm" || sweapon == "staff_lightning_melee_zm" || sweapon == "staff_water_melee_zm" || sweapon == "staff_air_melee_zm" || sweapon == "staff_fire_melee_zm" || sweapon == "knife_zm_alcatraz" || sweapon == "knife_zm" || sweapon == "knife_ballistic_bowie_upgraded_zm" || sweapon == "knife_ballistic_bowie_zm" || sweapon == "knife_ballistic_no_melee_upgraded_zm" || sweapon == "knife_ballistic_no_melee_zm" || sweapon == "knife_ballistic_upgraded_zm" || sweapon == "knife_ballistic_zm" || sweapon == "frag_grenade_zm" || sweapon == "staff_revive_zm" || sweapon == "cymbal_monkey_zm" || sweapon == "claymore_zm" || sweapon == "staff_air_upgraded_zm" || sweapon == "staff_air_upgraded2_zm" || sweapon == "staff_air_upgraded3_zm" || sweapon == "staff_air_zm" || sweapon == "staff_fire_upgraded_zm" || sweapon == "staff_fire_upgraded2_zm" || sweapon == "staff_fire_upgraded3_zm" || sweapon == "staff_fire_zm" || sweapon == "staff_lightning_upgraded_zm" || sweapon == "staff_lightning_upgraded2_zm" || sweapon == "staff_lightning_upgraded3_zm" || sweapon == "staff_lightning_zm" || sweapon == "staff_water_dart_zm" || sweapon == "staff_water_fake_dart_zm" || sweapon == "staff_water_upgraded_zm" || sweapon == "staff_water_upgraded2_zm" || sweapon == "staff_water_upgraded3_zm" || sweapon == "staff_water_zm" || sweapon == "staff_water_zm_cheap" )
    {
        struct.width = 14;
        struct.height = 14;
    }
    else
    {
        struct.width = 24;
        struct.height = 12;
    }

    return struct;
}

createbar_new( color, width, height, flashfrac )
{
    barelem = newclienthudelem( self );
    barelem.x = 0;
    barelem.y = 0;
    barelem.frac = 0;
    barelem.color = color;
    barelem.sort = -2;
    barelem.shader = "progress_bar_fill";
    barelem setshader( "progress_bar_fill", width, height );
    barelem.hidden = 0;
    barelem.archived = 0;
    barelem.hidewheninkillcam = 0;

    if ( isdefined( flashfrac ) )
        barelem.flashfrac = flashfrac;

    barelemframe = newclienthudelem( self );
    barelemframe.elemtype = "icon";
    barelemframe.x = 0;
    barelemframe.y = 0;
    barelemframe.width = width;
    barelemframe.height = height;
    barelemframe.xoffset = 0;
    barelemframe.yoffset = 0;
    barelemframe.bar = barelem;
    barelemframe.barframe = barelemframe;
    barelemframe.children = [];
    barelemframe.sort = -1;
    barelemframe.color = ( 0, 0, 0 );
    barelemframe setparent( level.uiparent );
    barelemframe.hidden = 0;
    barelembg = newclienthudelem( self );
    barelembg.elemtype = "bar";
    barelemframe.archived = 0;
    barelemframe.hidewheninkillcam = 0;

    if ( !self issplitscreen() )
    {
        barelembg.x = -2;
        barelembg.y = -2;
    }

    barelembg.width = width;
    barelembg.height = height;
    barelembg.xoffset = 0;
    barelembg.yoffset = 0;
    barelembg.bar = barelem;
    barelembg.barframe = barelemframe;
    barelembg.children = [];
    barelembg.sort = -3;
    barelembg.color = ( 0, 0, 0 );
    barelembg.alpha = 0.5;
    barelembg setparent( level.uiparent );

    if ( !self issplitscreen() )
        barelembg setshader( "progress_bar_bg", width + 4, height + 4 );
    else
        barelembg setshader( "progress_bar_bg", width + 0, height + 0 );

    barelembg.hidden = 0;
    barelembg.archived = 0;
    barelembg.hidewheninkillcam = 0;
    return barelembg;
}

createhegtext( align, relative, font, fontscale, x, y, sort, alpha, text, color, server )
{
    if ( isdefined( server ) )
        textelem = self createserverfontstring( font, fontscale );
    else
        textelem = self createfontstring( font, fontscale );

    textelem setpoint( align, relative, x, y );
    textelem.sort = sort;
    textelem.alpha = alpha;
    textelem.color = color;
    textelem.hidewheninmenu = 1;
    textelem.archived = 0;
    textelem.foreground = 1;
    textelem settext( text );
    level notify( "textset" );
    return textelem;
}

createhegrectangle( align, relative, x, y, width, height, color, shader, sort, alpha, server )
{
    if ( isdefined( server ) )
        hud = createservericon( shader, width, height );
    else
        hud = newclienthudelem( self );

    hud.elemtype = "bar";
    hud.children = [];
    hud.sort = sort;
    hud.color = color;
    hud.alpha = alpha;
    hud.hidewheninmenu = 1;
    hud.archived = 0;
    hud setparent( level.uiparent );
    hud setshader( shader, width, height );
    hud setpoint( align, relative, x, y );

    if ( self issplitscreen() )
        hud.x += 100;

    return hud;
}

drawtextzc( text, align, relative, x, y, fontscale, font, color, alpha, sort )
{
    element = self createfontstring( font, fontscale );
    element setpoint( align, relative, x, y );
    element settext( text );
    element.hidewheninmenu = 1;
    element.hidewheninkillcam = 1;
    element.archived = 1;
    element.color = color;
    element.alpha = alpha;
    element.sort = sort;
    return element;
}

shader( align, relative, x, y, shader, width, height, color, alpha, sort, server )
{
    if ( isdefined( server ) )
        element = createservericon( shader, width, height );
    else
        element = newclienthudelem( self );

    element.elemtype = "bar";
    element.hidewheninmenu = 0;
    element.shader = shader;
    element.width = width;
    element.height = height;
    element.align = align;
    element.relative = relative;
    element.xoffset = 0;
    element.yoffset = 0;
    element.children = [];
    element.sort = sort;
    element.color = color;
    element.alpha = alpha;
    element setparent( level.uiparent );
    element setshader( shader, width, height );
    element setpoint( align, relative, x, y );
    return element;
}