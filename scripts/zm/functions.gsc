#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_weapons;
#include scripts\zm\buildables;
#include scripts\zm\binds;
#include scripts\zm\utils;

init_blackout() 
{ 
	map = getdvar("mapname");
	self.elecount = 0;

	switch(map)
	{
		case "zm_transit":
			self thread ie((-7006.36, 4067.15, -49.2972), (-6897.93,3937.51,134.488), 15, undefined, "Roof Jump"); 
			self thread ie((-6652.22,3528.67,-63.875), (-6897.93,3937.51,134.488), 25, undefined, "Roof Jump 2"); // go back from tree
			self thread ie((-6528.8, 3785.08, -63.875), (-6784.3,4212.92,69.3221), 15, undefined, "Safe Exit");
			self thread ie((-6903.64,4024.86,-47.875), (-6784.3,4212.92,69.3221), 15, undefined, "Safe Exit"); // in case they fall
			self thread ie((-6854.36,4000.36,-63.658), (-6784.3,4212.92,69.3221), 15, undefined, "Safe Exit"); // in case they fall, again
			self thread ie((-6303.27,3981.17,-51.875), (-6191.29,3785.2,141.604), 15, undefined, "Other Roof"); // in case they fall, again
		case "zm_buried":
			self thread ie((-271.419,858.529,144.125), (-930.664,555.048,420.125), 15, undefined, "a Door"); 
			self thread ie((-2868.64,-136.359,1360.13), (517.733,-810.009,162.501), 15, undefined, "Candy Store");
			self thread ie((-915.361,85.1158,-28.9881), (6481.99,567.724,120.929), 15, undefined, "Pack a Punch");
			self thread ie((6223.13,777.992,-135.875), (-480.962,174.484,142.49), 15, undefined, "Safe Exit");
			self thread ie((280.731,-1215.46,56.125), (262.157,-1246.4,208.125), 15, undefined, "Top");
		default:
			break;
	}
	
	if(self isHost()) 
	{
		if(self.elecount == 0) return;
		self iprintln("^3Setting up " + self.elecount + " teleporter(s).. ^7[^3" + map + "^7]");
	}
}

ie(enter, exit, radius, fade_time, ie_name) 
{
	self thread ie_think(enter, exit, radius, fade_time, ie_name);
	self.elecount++;
}

ie_think(enter, exit, radius, fade_time, ie_name) 
{
	self endon("disconnect");
    self endon("game_ended");

	for(;;)
	{
		if(distance(enter, self.origin) <= radius)
		{
			self.fakeorigin = self.origin;

			// create messages and fallbacks - create a new message handler later
			if(isDefined(ie_name)) self iprintln("^7In range of ^2" + ie_name + " ^7[[{+usereload}]]");
			if(!isDefined(ie_name)) self iprintln("^2In range ^7[[{+usereload}]]");
			
			// loop an effect till a player uses the teleporter
			thread loop_till_use("character_fire_death_torso");

			self waittill("+usereload");
			self notify("iusedit");

			if(!isDefined(fade_time)) fade_time = randomfloatrange(0.3,0.5); // fade time callback

			// force stand just in case 👀
			self setStance("stand");
			self freezecontrolsallowlook(1);

			// blackscreen fade --> wait then unfreeze
			self thread blackscreen( 0.01, fade_time, 0.01, 0.3 );
			wait (fade_time + 0.2);

			self freezecontrolsallowlook(0);

			self setOrigin( exit );

			wait 5;
		}
		wait 0.05;
	}
}

loop_till_use(effect)
{
	self endon("disconnect");
	self endon("iusedit");
	dprint("waiting for usage, playing fx");
	
	thread usage_fx_monitor();
	for(;;)
	{
		dprint("^1still waiting for usage......");
		sfx(effect, self.fakeorigin);
		x = randomintrange(2,3); // i think this is fair
		wait (x);
	}
	thread force_end_if_idle(10); // call after everything 
}

force_end_if_idle(time)
{
	dprint("^2called start for force end: " + time);
	wait (time);
	dprint("^2gave up and ended fx");
	self notify("iusedit");
}

usage_fx_monitor()
{
	self waittill("iusedit");

	self.fakeorigin = undefined;
	cool_epic_fx_list = list("poltergeist powerup_off character_fire_death_torso");

	foreach(fx in cool_epic_fx_list)
	{
	dprint("teleporter used and played ^3" + fx);
	sfx(fx);
	}
}

init_fx_test()
{
    self endon("game_ended");  
    self endon("stopfxtest");

	self.is_testing = true;

    for(;;)
    {
		self thread send_message("Now testing effects!");
        level waittill( "say", message, player );
        fx = message;
        player test_fx(fx);
    }        
}  

test_fx(fx)
{
	self.is_testing = undefined;
	self thread send_message("Testing: " + fx);
	sfx(fx, get_crosshair());
	self notify("stopfxtest");
}

sfx(fx, origin)
{
	if(!isDefined(origin)) origin = self.origin;
	if(!isDefined(level._effect[fx])) self iprintln("Invalid FX!"); // ?
	playfx(level._effect[fx], origin);
}

init_no_clip() 
{
	self endon("nomoreufo");
    b = 0;
	for(;;)
	{
		self waittill("+melee");
		if(self GetStance() == "crouch")
		if(b == 0)
		{
			b = 1;
			self thread do_no_clip();
			self disableweapons();
			foreach(w in self.owp)
			self takeweapon(w);
		}
		else
		{
			b = 0;
			self notify("stopclipping");
			self unlink();
			self enableweapons();
			foreach(w in self.owp)
			self giveweapon(w);
		}
	}
}

do_no_clip() 
{
	self endon("stopclipping");
	if(isdefined(self.newufo)) self.newufo delete();
	self.newufo = spawn("script_origin", self.origin);
	self.newufo.origin = self.origin;
	self playerlinkto(self.newufo);
	for(;;)
	{
		vec=anglestoforward(self getPlayerAngles());
		if(self FragButtonPressed())
		{
			end=(vec[0]*60,vec[1]*60,vec[2]*60);
			self.newufo.origin=self.newufo.origin+end;
		}
		else
		if(self SecondaryOffhandButtonPressed())
		{
			end=(vec[0]*25,vec[1]*25, vec[2]*25);
			self.newufo.origin=self.newufo.origin+end;
		}
		wait 0.05;
	}
}

rand_class()
{
	sniper = randomize("dsr50_zm");
	keys   = array_randomize( getarraykeys( level.zombie_weapons ) );
	keys2  = array_randomize( getarraykeys( level.zombie_weapons_upgraded ) );
	keys3  = array_randomize( getarraykeys( level.zombie_lethal_grenade_list ) );
	keys4  = array_randomize( getarraykeys( level.zombie_equipment_list ) );
	keys5  = array_randomize( getarraykeys( level.zombie_lethal_grenade_list ) ); // to make sure
	keys6  = array_randomize( getarraykeys( level.zombie_tactical_grenade_list ) );
	genie  = genie(keys[0],keys2[0]); // do we give a normal or papped weapon ?

	// ensure player doesnt get an unusable secondary
	if ( issubstr( keys3[0], "emp_" ) || issubstr( keys6[0], "emp_" ) ||  issubstr( keys4[0], "_bomb_zm" ) || issubstr( keys3[0], "_bomb_zm" ) || issubstr( keys5[0], "_bomb_zm" ) || issubstr( keys6[0], "_bomb_zm" ) || issubstr( genie, "tazer_" ) || issubstr( genie, "bowie" ) || issubstr( genie, "_monkey" )  || issubstr( genie, "_revive" ) || issubstr( genie, "beacon_" ) || issubstr( genie, "_lightning_upgraded" ) || issubstr( genie, "_air_upgraded" ) || issubstr( genie, "_fire_upgraded" ) || issubstr( genie, "_water_upgraded" ) || !issubstr( genie, "_zm" ) || issubstr( genie, "_tomahawk" ) || issubstr( genie, "_grenade" ) || issubstr( genie, "claymore_" ) || issubstr( genie, "_bomb" ) || genie == sniper  )
	{
		// dprint("broken secondary.. rerolling");
		thread rand_class();
		return;
	}

	custom_class("knife_zm", sniper, genie, "Random Class", keys3[0], keys4[0], keys5[0], keys6[0]);
}

custom_class( melee, weap1, weap2, classnamep, equip1, equip2, equip3, equip4 )
{
    self notify("rerolled");

	weapons = array(melee, weap1, weap2, equip1, equip2, equip3, equip4);
	massprint(weap1,weap2,equip1,equip2,equip3,equip4);

    self takeallweapons();

	foreach(weap in weapons)
	{
		self giveweapon_real(weap);
	}

    self switchtoweapon( weap1 );
    thread more_perks();
}

set_player_perks()
{
    wait 0.05;
	self setperk("specialty_unlimitedsprint");
    self setperk("specialty_movefaster");
    self setperk("specialty_sprintrecovery");    
    self setperk("specialty_earnmoremomentum");
	self setperk("specialty_fastmantle");
	self setperk("specialty_fastladderclimb");
    self setperk("specialty_extraammo");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_fasttoss");
    self setperk("specialty_fastladderclimb");
    self setperk("specialty_fastmantle");
    self setperk("specialty_fastequipmentuse");
}

give_and_switch(weap) 
{
	w = weap + "_zm";
	self giveWeapon(w);
	self switchToWeapon(w);
	foreach(weapon in self getWeaponsListPrimaries()) self giveMaxAmmo(weapon);
}

more_perks()
{
    v = randomize("specialty_fastladderclimb,specialty_fastmantl");
    r = randomize("specialty_fasttoss,specialty_fastequipmentuse,x");
    self clearPerks();
    thread add_perks(undefined, v, r);
}

add_perks(l, v, r)
{
	self endon("disconnect");
	self endon("death");
	self endon("rerolled");

	for(;;)
	{
    if(isDefined(v)) self setperk(v);
    if(isDefined(r)) self setperk(r);
    self setperk("specialty_longersprint");
    self setperk("specialty_unlimitedsprint");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_armorpiercing");
    self setperk("specialty_earnmoremomentum");
    self setperk("specialty_fallheight");
    self setperk("specialty_movefaster");
    self setperk("specialty_holdbreath");
    self setperk("specialty_fastads");
    self setperk("specialty_sprintrecovery");
    self setperk("specialty_extraammo");
    self setperk("specialty_holdbreath");
	wait 10;
	}
}

// array_randomize, getarraykeys

force_out(enter) // unused now keeping it though
{
	self endon("disconnect");

	for(;;)
	{
		if(distance(enter, my_angles()) <= 15)
		{
			/*	10/13/24
				so, this is super annoying
				trying to get directions to work so i wont have to use an exit argument
				they work when i force them (force_check_direction() - utils.gsc)
				but not when i replicate it (check_direction() - utils.gsc). weird right?
				pretty annoying, hopefully can find a fix eventually cause this is a cool oom func idea!
			*/

			/* 10/14/24
			   i got it working in a way after hours of overcomplicating things
			   but directions still need to be cleaned up
			*/

			self iprintln("Near! [{+melee}] - Facing " + direction(my_angles()));
			self waittill("+melee");
			angle = direction(my_angles());
			//self thread check_direction(angle);
			wait 2;
		}
		wait 0.05;
	}
}