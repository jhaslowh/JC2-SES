Server Enhancement Suite
========================

This is a script for the Just Cause 2 Multiplayer Mod that adds a ton of commands to the chat, very basic admin system, a GUI to control some of the features easier, and a map used to teleport the player.  
The GUI has all the commands listed on it and tabs for spawning vehicles, giving weapons, and some player options.
When the teleport map is opened, the player will be teleported to the location they click on the map.    

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
/mass [num] : set the vehicle mass to the specified value  
/repair : repair current vehicle  
/explode : blow up car  
/weapon [num] : give yourself the gun with index [0-26]  
/heaven : go to top of map  
/pos : get your current position  
/tpp [player name] : teleport yourself to the given player  
/tpl [x] [z] : teleport to the specified location  
/time [value] : set the time of day for the world. Can either be a number [0-24], "day", or "night"  
/weather [value] : set the weather of the world. Can either be [0-2], "sunny", "rain", or "storm".  
/clear : clear chat  
/home : go home  
/sethome : set the home location to the players current location    
/whisper [player name] "[message]" : send private message to player  
/steamid : print out your steam id to your own chat   
/smash [player name] : smash the given player with a car. If no player give, you will small yourself  

**Admin commands**  
/makeAdmin [player name] : make the specified player an admin  
/kick [player name] : kick the player with the given name  
/kill [player name] : kill the given player  

**Buttons**  
F7 - Open Interactive GUI  
B - Blow up car  
U - Makes car fly up into air  
Arrows - Apply Linear Velocity to car  
P - Open Teleport map  
--- When map is open, click on a position to teleport there. 
F - Hop car (Can be continuously pressed, and might also work in air vehicles....)  

###Planned  
- Model id for player in GUI  
- /suicide command  
- health commands for player  
- money commands  
- model for player  
- time step  command  
- ammo on weapon GUI    
- /ground command to go to ground  
- banning  
- Secondary vehicle color in GUI  

###Technical    
SES Version - 0.046  
JCMP Version - 0.1.4  
