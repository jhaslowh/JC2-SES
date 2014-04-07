Server Enhancement Suite
========================

This is a script for the Just Cause 2 Multiplayer Mod that adds a ton of commands to the chat, adds admins & admin controls, and a GUI for spawning game items. 

###How to use

You must be running a copy of the Just Cause 2 Dedicated Mulitiplayer Server. Then just drop everything in this repo into a folder inside your script folder. 

###Commands

The following commands are recognized by the chat.  

**Commands for Everyone**  
/vehicle [num] : spawn the vehicle with specified number  
/vehicleColor [r] [g] [b] : set the color or your vehicle, values are [0-255]  
/mass [num] : set the vehicle mass to the specified value  
/weapon [num] : Give yourself the gun with index [0-26]  
/heaven : go to top of map  
/pos : get your current position  
/tpp [player name] : teliport yourself to the given player  
/tpl [x] [z] : teliport to the specified location  
/time [value] : Set the time of day for the world. Can either be a number [0-24], "day", or "night"  
/weather [value] : Set the weather of the world. Can either be [0-2], "sunny", "rain", or "storm".  
/clear : Clear chat  
/home : go home  
/whisper [player name] "[message]" : send private message to player  

**Admin commands**  
/makeAdmin [player name] : make the specified player an admin  
/kick [player name] : Kick the player with the given name  
/kill [player name] : kill the given player  

**Buttons**  
F7 - Open Interactive GUI  
B - Blow up car (must be on ground)  
  
###Admin

To create a new admin, add thier steam name to the admins.txt file. 
