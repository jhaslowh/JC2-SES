Server Enhancement Suite
========================

This is a script for the Just Cause 2 Multiplayer Mod that adds a ton of commands to the chat, very basic admin system, and a GUI.  
The GUI has all the commands listed on it and tabs for spawning vehicles, giving weapons, and some player options.  

A lot of what is done in this script has been done before, this is just my own version of it. Check out other cool scripts at [the forums](http://www.jc-mp.com/forums/index.php/board,319.0.html).  

###How to use

You must be running a copy of the Just Cause 2 Dedicated Mulitiplayer Server. Then just drop everything in this repo into a folder inside your script folder. 

###Admin

To create a new admin, add thier steam id to the admins.txt file. If you need to figure out your steam id, type "/steamid" into chat ingame.  

###Commands

The following commands are recognized by the chat.  

**Commands for Everyone**  
/vehicle [num] : spawn the vehicle with specified number  
/vehicleColor [r] [g] [b] : set the color or your vehicle, values are [0-255]  
/explode : blow up car  
/mass [num] : set the vehicle mass to the specified value  
/weapon [num] : give yourself the gun with index [0-26]  
/heaven : go to top of map  
/pos : get your current position  
/tpp [player name] : teliport yourself to the given player  
/tpl [x] [z] : teliport to the specified location  
/time [value] : set the time of day for the world. Can either be a number [0-24], "day", or "night"  
/weather [value] : set the weather of the world. Can either be [0-2], "sunny", "rain", or "storm".  
/clear : clear chat  
/home : go home  
/sethome : set the home location to the players current location    
/whisper [player name] "[message]" : send private message to player  
/steamid : print out your steam id to your own chat   

**Admin commands**  
/makeAdmin [player name] : make the specified player an admin  
/kick [player name] : kick the player with the given name  
/kill [player name] : kill the given player  

**Buttons**  
F7 - Open Interactive GUI  
B - Blow up car  
U - Makes car fly up into air  
Arrows - Apply Linear Velocity to car  
P - Open Teliport map  
--- When map is open, click on a position to teliport there. 

###Planned  
- Model id for player in GUI  
- /suicide command  
- health commands for player  
- money commands  
- model for player  
- /repair command for vehicle  
- time step  command
- tabbed vehicle list  
- ammo on weapon GUI    
- set color button for vehicle in GUI  
- /ground command to go to ground  
- banning  

###Technical    
SES Version - 0.032  
JCMP Version - 0.1.4  
