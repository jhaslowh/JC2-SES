
class 'JServerControler'

function JServerControler:__init()
  -- List of admins in server 
  self.adminCount = 0
  self.admins = {}

  self:LoadAdminFile()

  -- Colors
  self.colorAdmin = Color(255, 209, 25)
  self.colorPrivate = Color(0, 216, 255)
  self.colorGreen = Color(98, 220, 0)
  self.colorError = Color(249,63,63)
  self.colorCommand = Color(115, 170, 220)

  -- Add events to global events 
  Events:Subscribe("PlayerChat", self, self.ChatControl)
  Events:Subscribe("PlayerSpawn", self, self.PlayerJoin)
end

function JServerControler:ChatControl(args)
  -- Change players vehicle color
  if args.text:sub(0,13) == "/vehicleColor" then
    -- Check if player is in vehicle 
    if args.player:InVehicle() == false then 
      args.player:SendChatMessage("You must be in a vehicle to set the color of a vehicle", self.colorError)
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
    spawnArgs = {}
    -- Grab vehicle number
    local line = args.text:sub(10,args.text:len())
    spawnArgs.model_id = tonumber(line)
    spawnArgs.position = args.player:GetPosition()
    spawnArgs.angle = args.player:GetAngle()
 
    local vehicle = Vehicle.Create(spawnArgs)
    vehicle:SetDeathRemove(true)
    vehicle:SetInvulnerable(false)
    vehicle:SetUnoccupiedRemove(true)
    args.player:EnterVehicle(vehicle, VehicleSeat.Driver)

    Chat:Broadcast(args.player:GetName() .. " - Spawned Vehicle (" .. line .. ": " .. Vehicle.GetNameByModelId(tonumber(line)) .. ")", self.colorCommand)
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

  -- Clear terminal
  if args.text:sub(0,7) == "/clear" then
    for i = 0, 12 do
      args.player:SendChatMessage("", self.colorPrivate)
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

  --==============================================================
  -- Admin Commands
  --==============================================================

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
    self:AddAdmin(pname)
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

-- Load the admin file from drive
function  JServerControler:LoadAdminFile()
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
function  JServerControler:isAdmin(player)
  for i=0, self.adminCount - 1 do
    if player:GetName() == self.admins[i] then
      return true
    end
  end
  return false
end

-- Add admin to file 
-- Will also save admin file 
function  JServerControler:AddAdmin(playerName)
  self.admins[self.adminCount] = playerName
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
function  JServerControler:GetPlayerByName(playerName)
  for player in Server:GetPlayers() do
    if player:GetName() == playerName then
      return player
    end 
  end
  return nil
end

-- Player join 
function  JServerControler:PlayerJoin(args)
  -- Print global chat message 
  Chat:Broadcast(args.player:GetName() .. " has joined the game", self.colorGreen)

  -- Print welcome message to player 
  args.player:SendChatMessage("Welcome to the server!", self.colorGreen)
  args.player:SendChatMessage("Hit F7 for help and more", self.colorGreen)
end

jserver = JServerControler()

