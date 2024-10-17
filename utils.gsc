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
	setDvar("player_meleeRange", 64);
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
    level.debug_mode = getdvarintdefault("debug_mode", 0);
	level.zombie_move_speed = "sprint"; // doesnt work unless without other replacefunc
    level.zombie_vars["zombie_spawn_delay"] = 0; // doesnt work unless without other replacefunc
	level.zombie_vars["zombie_between_round_time"] = 0; // doesnt work unless without other replacefunc
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

    level.custom_intermissionog = level.custom_intermission;
    level.custom_intermission = ::player_intermission;  

    level.callbackactordamage = ::actor_damage_override_wrapper;	
}

do_zombie_vars()
{
	set_zombie_var( "zombie_use_failsafe", 0 );
}

spawnpoint()
{
    return level.new_spawn;
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

turn_on_powerr()
{
	flag_wait( "initial_blackscreen_passed" );
	wait 5;
	trig = getEnt( "use_elec_switch", "targetname" );
	powerSwitch = getEnt( "elec_switch", "targetname" );
	powerSwitch notSolid();
	trig setHintString( &"ZOMBIE_ELECTRIC_SWITCH" );
	trig setVisibleToAll();
	trig notify( "trigger", self );
	trig setInvisibleToAll();
	powerSwitch rotateRoll( -90, 0, 3 );
	level thread maps\mp\zombies\_zm_perks::perk_unpause_all_perks();
	powerSwitch waittill( "rotatedone" );
	flag_set( "power_on" );
	level setClientField("zombie_power_on", 1 ); 
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

	level thread turn_on_powerr();
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
    setdvar("zombie_unlock_all", 1);
    flag_set("power_on");
    players = get_players();
    zombie_doors = getentarray("zombie_door", "targetname");
    for(i = 0; i < zombie_doors.size; i++)
    {
        zombie_doors[i] notify("trigger");
        if(is_true(zombie_doors[i].power_door_ignore_flag_wait))
        {
            zombie_doors[i] notify("power_on");
        }
        wait(0.05);
    }
    zombie_airlock_doors = getentarray("zombie_airlock_buy", "targetname");
    for(i = 0; i < zombie_airlock_doors.size; i++)
    {
        zombie_airlock_doors[i] notify("trigger");
        wait(0.05);
    }
    zombie_debris = getentarray("zombie_debris", "targetname");
    for(i = 0; i < zombie_debris.size; i++)
    {
        zombie_debris[i] notify("trigger", players[0]);
        wait(0.05);
    }
    setdvar("zombie_unlock_all", 0);
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
		self play_sound_on_ent( "purchase" );
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