
class 'SES'

function SES:__init()
  -- List of admins in server 
  self.adminCount = 0
  self.playerCount = 0
  self.admins = {}
  self.players = {}

  self:LoadAdminFile()
  self.weapons = { }
  self:CreateWeaponArray()

  -- Colors
  self.colorAdmin = Color(255, 209, 25)
  self.colorPrivate = Color(0, 216, 255)
  self.colorGreen = Color(98, 220, 0)
  self.colorError = Color(249,63,63)
  self.colorCommand = Color(115, 170, 220)

  -- Add events to global events 
  Events:Subscribe("PlayerChat", self, self.ChatControl)
  Events:Subscribe("PlayerSpawn", self, self.PlayerJoin)
  Network:Subscribe("SpawnVehicle", self, self.SpawnVehicle)
  Network:Subscribe("GiveGun", self, self.GiveGun)
  Network:Subscribe("ExplodeCar", self, self.ExplodeCar)
  Network:Subscribe("MoveUp", self, self.MoveUp)
  Network:Subscribe("MoveCar", self, self.MoveCar)
end

-- Call to spawn a vehicle 
function SES:SpawnVehicle(args, player)
  -- Get out of vehicle if in one 
  if player:InVehicle() then
    local veh = player:GetVehicle()
    veh:Remove()
  end

  -- Vehicle spawn arguments 
  spawnArgs = {}
  spawnArgs.model_id = args.id
  spawnArgs.position = player:GetPosition()
  spawnArgs.angle = player:GetAngle()

  -- Create vehicle 
  local vehicle = Vehicle.Create(spawnArgs)
  vehicle:SetDeathRemove(true)
  vehicle:SetInvulnerable(false)
  vehicle:SetUnoccupiedRemove(true)

  player:EnterVehicle(vehicle, VehicleSeat.Driver)

  -- Display chat message 
  Chat:Broadcast(player:GetName() .. " - Spawned Vehicle (" .. tostring(args.id) .. 
    ": " .. Vehicle.GetNameByModelId(args.id) .. ")", self.colorCommand)

  -- Try and set colors
  local color1 = args.color1
  if color1 == nil then return end
  local color2 = args.color2
  if color2 == nil then color2 = color1 end
  vehicle:SetColors( color1, color2 )
end

-- Call to give a weapon to a player
function SES:GiveGun(args, player)
  if args.id < 0 or args.id > 26 then 
    player:SendChatMessage("Please select a number in the range [0-26]", 
        self.colorError)
    return
  end

  -- Get the weapon 
  local id = self.weapons[args.id]

  -- Give gun to player 
  if args.primary then 
    player:GiveWeapon( WeaponSlot.Primary, Weapon(id,100,999))
  end
  if args.primary == false then
    player:GiveWeapon( WeaponSlot.Right, Weapon(id,100,999))
  end
end

--=========================================================================
--=========================================================================

-- Controls chat commands 
function SES:ChatControl(args)
  -- Change players vehicle color
  if args.text:sub(0,13) == "/vehicleColor" then
    -- Check if player is in vehicle 
    if args.player:InVehicle() == false then 
      args.player:SendChatMessage("You must be in a vehicle to set the color of a vehicle", 
        self.colorError)
      return false 
    end

    -- Make sure args has sub args
    if args.text:len() < 14 then
      return false
    end

    -- Cut command from args 
    local text = args.text:sub(15, args.text:len())
    -- Find first space
    local space1 = text:find("%s")
    -- Return if no space
    if space1 == nil then return false end
    -- Convert space to number
    space1 = tonumber(space1)

    -- Find second space
    local space2 = text:find("%s",space1+1)
    -- Return if no second space
    if space2 == nil then return false end
    space2 = tonumber(space2)

    -- Set vehicle color
    local color = Color( 
      tonumber(text:sub(0,space1)), 
      tonumber(text:sub(space1+1,space2)),
      tonumber(text:sub(space2+1,text:len())))
    args.player:GetVehicle():SetColors( color, color )

    args.player:SendChatMessage("Vehicle color set to this", color)
    return false
  end

  -- Spawn a vehicle and put them inside it.
  if args.text:sub(0,8) == "/vehicle" then
    local args2 = {id=tonumber(args.text:sub(10,args.text:len()))}
    SpawnVehicle(args2, args.player)
    return false
  end

  -- Give a weapon 
  if args.text:sub(0,7) == "/weapon" then
    -- Check if no args given 
    if args.text:len() < 9 then return false end
    -- Parse args
    local args2 = 
    {
      id = tonumber(args.text:sub(9, args.text:len())),
      primary = true
    }
    print(args2.id)
    -- Give gun 
    self:GiveGun(args2, args.player)
    return false
  end

  -- Fall from the heavens 
  if args.text == "/heaven" then
    local currentPosition = args.player:GetPosition()
    local newPosition = currentPosition + Vector3(0, 15000, 0)
    args.player:SetPosition(newPosition)
    Chat:Broadcast(args.player:GetName() .. " is BRB visiting jesus", self.colorCommand)
    return false
  end

  -- Print player position 
  if args.text == "/pos" then
    args.player:SendChatMessage(args.player:GetName() .. " is is at location " .. tostring(args.player:GetPosition()), Color(115, 170, 220))
    return false
  end

  -- Teliport to given player
  if args.text:sub(0,4) == "/tpp" then 
    local pname = args.text:sub(6,args.text:len())
    for player in Server:GetPlayers() do
      if player:GetName() == pname then
        args.player:SetPosition(player:GetPosition())
        Chat:Broadcast(args.player:GetName() .. " teliported to " .. player:GetName(), self.colorCommand)
        return false
      end 
    end
    args.player:SendChatMessage("Player " .. pname .. " not found", self.colorCommand)
    return false
  end

  -- Teliport to given place on map 
  if args.text:sub(0,4) == "/tpl" then 
    local loc = args.text:sub(6,args.text:len())
    local xloc = tonumber(loc:sub(0,loc:find("%s")))
    local zloc = tonumber(loc:sub(loc:find("%s"),loc:len()))
    args.player:SetPosition(Vector3(xloc, 500.0, zloc))
  end 

  -- Whisper to a player 
  if args.text:sub(0,8) == "/whisper" then 
    -- Remove command
    local text = args.text:sub(10,args.text:len())
    local qstart = text:find("\"")
    -- Return if no message 
    if qstart == nil then
      return false
    end
    -- Get player name
    local playerName = text:sub(0, qstart-2)
    -- Get Message 
    local mess = text:sub(qstart, text:len())
    -- Get player
    local player = self:GetPlayerByName(playerName)
    
    -- Send private message to player if they exist
    if player != nil then
      player:SendChatMessage(args.player:GetName() .. "(whisper): " .. mess, self.colorPrivate)
    end 
    
    return false
  end  

  -- Set the time of day 
  if args.text:sub(0,5) == "/time" then
    -- Grab the time value 
    local timev = args.text:sub(7,args.text:len())

    -- Check time words 
    if timev == "day" then
      DefaultWorld:SetTime(12)
      Chat:Broadcast(args.player:GetName() .. " set time to day", self.colorCommand)
      return false
    end
    if timev == "night" then
      DefaultWorld:SetTime(0)
      Chat:Broadcast(args.player:GetName() .. " set time to night", self.colorCommand)
      return false
    end

    timev = tonumber(timev)
    if timev < 0 or timev > 24 then
      args.player:SendChatMessage("Time must be [0-24]", self.colorError)
      return false
    end
    DefaultWorld:SetTime(timev)
    Chat:Broadcast(args.player:GetName() .. " set time to " .. tostring(timev), self.colorCommand)
    return false
  end

  -- Set the weather
  if args.text:sub(0,8) == "/weather" then
    -- Grab the weather value 
    local wea = args.text:sub(10,args.text:len())
    -- Check weather words 
    if wea == "sunny" then
      DefaultWorld:SetWeatherSeverity(0)
      Chat:Broadcast(args.player:GetName() .. " set weather to sunny", self.colorCommand)
      return false
    end
    if wea == "rain" then
      DefaultWorld:SetWeatherSeverity(1)
      Chat:Broadcast(args.player:GetName() .. " set weather to rain", self.colorCommand)
      return false
    end
    if wea == "storm" then
      DefaultWorld:SetWeatherSeverity(2)
      Chat:Broadcast(args.player:GetName() .. " set weather to storm", self.colorCommand)
      return false
    end

    wea = tonumber(wea)
    if wea < 0 or wea > 2 then
      args.player:SendChatMessage("Weather value must be [0-2]", self.colorError)
      return false
    end

    DefaultWorld:SetWeatherSeverity(wea)
    Chat:Broadcast(args.player:GetName() .. " set weather to " .. tostring(wea), self.colorCommand)
    return false
  end

  -- Go home
  if args.text == "/home" then
    args.player:SetPosition(Vector3(-6386,212,-3534))
  end

  -- Change the vehicle mass of your car 
  if args.text:sub(0,5) == "/mass" then
    -- Return if not in vehicle 
    if args.player:InVehicle() == false then 
      args.player:SendChatMessage("You must be in a vehicle to set mass of a vehicle", 
        self.colorError)
      return false 
    end
    -- Grab the mass value 
    local massv = args.text:sub(7,args.text:len())
    print(massv)

    -- Get vehicle 
    local veh = args.player:GetVehicle()
    veh:SetMass(tonumber(massv))

    args.player:SendChatMessage("Vehicle mass set to " .. massv, self.colorCommand)
    return false
  end

  -- Print your steam id to console
  if args.text == "/steamid" then
    args.player:SendChatMessage(tostring(args.player:GetSteamId().id), self.colorCommand)
  end

  --==============================
  -- Admin Commands

  -- Kill the given player if you have permission 
  if args.text:sub(0,5) == "/kill" then 
    -- Return false if not admin 
    if self:isAdmin(args.player) == false then
      return false
    end

    -- Search for player in player list
    local pname = args.text:sub(7,args.text:len())
    local player = self:GetPlayerByName(pname)

    if player != nil then
      player:SetHealth(0)
      Chat:Broadcast("Admin has killed " .. player:GetName(), self.colorAdmin)
      return false
    end

    args.player:SendChatMessage("Player " .. pname .. " not found", Color(115, 170, 220))
    return false
  end

  -- Add player to admin list
  if args.text:sub(0,10) == "/makeAdmin" then
    -- Return false if not admin 
    if self:isAdmin(args.player) == false then
      return false
    end

    -- Get player 
    local pname = args.text:sub(12,args.text:len())
    self:AddAdmin(args.player)
    Chat:Broadcast(pname .. " is now an Admin", self.colorAdmin)

    return false
  end

  -- Kick player 
  if args.text:sub(0,5) == "/kick" then
     -- Return false if not admin 
    if self:isAdmin(args.player) == false then
      return false
    end

    -- Get player name
    local playerName = args.text:sub(7,args.text:len())
    print(playerName)
    -- Get player
    local player = self:GetPlayerByName(playerName)

    -- Try and kick player 
    if player != nil then
      player:Kick()
    end
    return false
  end 

  return true
end

--=========================================================================
--=========================================================================

-- Load the admin file from drive
function  SES:LoadAdminFile()
  -- Open up the admin file 
  local filename = "admins.txt"
  print("Opening " .. filename)
  local file = io.open( filename, "r" )

  if file == nil then
      print( "No admins.txt, aborting loading of admins" )
      return
  end

  -- For each line load as admin name 
  for line in file:lines() do
    self.admins[self.adminCount] = line
    self.adminCount = self.adminCount + 1
  end

  file:close()
end

-- Check if player is an admin
function  SES:isAdmin(player)
  for i=0, self.adminCount - 1 do
    if player:GetSteamId().id == self.admins[i] then
      return true
    end
  end
  return false
end

-- Add admin to file 
-- Will also save admin file 
function  SES:AddAdmin(player)
  self.admins[self.adminCount] = player:GetSteamId().id
  self.adminCount = self.adminCount + 1

  -- Open up the admin file 
  local filename = "admins.txt"
  print("Opening " .. filename)
  local file = io.open( filename, "w+" )

  if file == nil then
      print( "No admins.txt, aborting loading of admins" )
      return
  end

  -- Write each name to the admin file 
  for i = 0, self.adminCount - 1 do
    file:write(self.admins[i] .. "\n")
  end

  file:close()
end

-- Get player by player name 
function  SES:GetPlayerByName(playerName)
  for player in Server:GetPlayers() do
    if player:GetName() == playerName then
      return player
    end 
  end
  return nil
end

-- Player join 
function  SES:PlayerJoin(args)
  -- Set player skin (this will sometimes generate a invalid model)
  math.randomseed( os.time() )
  args.player:SetModelId(math.random(1,103))

  -- Check if player is allready in game
  for i=0, self.playerCount-1 do
    if self.players[i] == args.player:GetName() then
      return 
    end
  end

  -- Add player to player list
  self.players[self.playerCount] = args.player:GetName()
  self.playerCount = self.playerCount + 1

  -- Print global chat message 
  Chat:Broadcast(args.player:GetName() .. " has joined the game", self.colorGreen)

  -- Print welcome message to player 
  args.player:SendChatMessage("Welcome to the server!", self.colorGreen)
  args.player:SendChatMessage("Hit F7 for help and more", self.colorGreen)

end

-- Blow up car
function  SES:ExplodeCar(args, player)
  -- Return if not in vehicle 
  if player:InVehicle() == false then 
    return false 
  end

  -- Get vehicle 
  local veh = player:GetVehicle()
  veh:SetHealth(0)
  Chat:Broadcast("BOOM", self.colorError)
end

-- Move up 
-- Will make the car fly up into the air 
function  SES:MoveUp(args, player)
  -- Return if not in vehicle 
  if player:InVehicle() then 
    -- Get vehicle 
    local veh = player:GetVehicle()
    veh:SetLinearVelocity(Vector3(0,100,0))
  end
end

-- Movecar in direction 
function SES:MoveCar(args, player)
  local y = math.sin(args.yaw)
  local x = math.cos(args.yaw)

  -- Return if not in vehicle 
  if player:InVehicle() then 
    if args.up == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(-y * 100.0, 0, -x * 100.0))
    elseif args.left == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(-x * 100.0, 0, y * 100.0)) 
    elseif args.right == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(x * 100.0, 0, -y * 100.0))
    elseif args.down == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(y * 100.0, 0, x * 100.0))
    end 
  end
end

-- Create weapon array
function  SES:CreateWeaponArray()
  self.weapons[0] = Weapon.Assault
  self.weapons[1] = Weapon.BubbleGun 
  self.weapons[2] = Weapon.GrenadeLauncher 
  self.weapons[3] = Weapon.Handgun 
  self.weapons[4] = Weapon.HeavyMachineGun 
  self.weapons[5] = Weapon.MachineGun 
  self.weapons[6] = Weapon.MachinegunARVE 
  self.weapons[7] = Weapon.Minigun 
  self.weapons[8] = Weapon.MinigunARVE 
  self.weapons[9] = Weapon.MinigunLAVE 
  self.weapons[10] = Weapon.MinigunVehicle 
  self.weapons[11] = Weapon.MultiTargetRocketLauncher 
  self.weapons[12] = Weapon.PanayRocketLauncher 
  self.weapons[13] = Weapon.Revolver 
  self.weapons[14] = Weapon.RocketARVE 
  self.weapons[15] = Weapon.RocketLAVE 
  self.weapons[16] = Weapon.RocketLauncher 
  self.weapons[17] = Weapon.SAM 
  self.weapons[18] = Weapon.SMG 
  self.weapons[19] = Weapon.SawnOffShotgun 
  self.weapons[20] = Weapon.SentryGun 
  self.weapons[21] = Weapon.Shotgun 
  self.weapons[22] = Weapon.Sniper 
  self.weapons[23] = Weapon.V022_VHLRKT 
  self.weapons[24] = Weapon.V023_VHLRKT 
  self.weapons[25] = Weapon.V089_VHLRKT 
  self.weapons[26] = Weapon.Vulcan 
end

ses = SES()
