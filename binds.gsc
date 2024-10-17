#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_weapons;
#include scripts\zm\functions;
#include scripts\zm\utils;

binds()
{
	thread random_class("2"); 
	thread toggle_soh("4"); 
	// thread testing_fx("1");
	// thread testing_dir("1"); // barriers
}

random_class(slot)
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("+actionslot " + slot);
		thread rand_class();
		wait 0.05;
	}
}

toggle_soh(slot)
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("+actionslot " + slot);
		// uglyyyyy
		if(self getStance() != "crouch") continue; // better then if checking 
		if(!self hasperk("specialty_fastreload")) 
		{
			self setperk("specialty_fastreload");
			sfx("poltergeist");

		} else {
			self unsetperk("specialty_fastreload");
		}
		wait 0.05;
	}
}

testing_dir(slot)
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("+actionslot " + slot);
		//if(self getStance() != "crouch") continue;
		if(isDefined(self.is_dir_testing)) continue;
		self thread init_dir_test();
		wait 0.05;
	}
}

testing_fx(slot)
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("+actionslot " + slot);
		if(self getStance() != "prone") continue;
		if(isDefined(self.is_testing)) continue;
		self thread init_fx_test();
		wait 0.05;
	}
}

init_dir_test()
{
    self endon("game_ended");  
    self endon("stopdirtest");
	self.is_dir_testing = true;
    for(;;)
    {
		self thread send_message("Testing directions!");
        level waittill( "say", message, player );
        direction = message;
        player test_dir(direction);
    }        
}  

test_dir(direction)
{
	new_dir = float(direction);
	self thread send_message(new_dir + " | " + direction(my_angles()));
	self thread force_check_direction(new_dir);
	self.is_dir_testing = undefined;
	self notify("stopdirtest");
}