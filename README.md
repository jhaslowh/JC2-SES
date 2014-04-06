Server Enhancement Suite
========================

This is a script for the Just Cause 2 Multiplayer Mod that adds a ton of commands to the chat, adds admins and admin controls, and a GUI for spawning game items. 

How to use
----------

You must be running a copy of the Just Cause 2 Dedicated Mulitiplayer Server. Then just drop everything in this repo into a folder inside your script folder. 

Commands
--------

The following commands are recognized by the chat.  

**Commands for Everyone**  
/vehicle [num] : spawn the vehicle with specified number  
/vehicleColor [r] [g] [b] : set the color or your vehicle, values are [0-255]  
/heaven : go to top of map  
/pos : get your current position  
/tpp [player name] : teliport yourself to the given player  
/tpl [x] [z] : teliport to the specified location  
/clear : Clear chat  
/whisper [player name] "[message]" : send private message to player  

**Admin commands**  
/makeAdmin [player name] : make the specified player an admin  
/kick [player name] : Kick the player with the given name  
/kill [player name] : kill the given player  
  
Admin
-----

To create a new admin, add thier steam name to the admins.txt file. 
