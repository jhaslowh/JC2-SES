
class 'SES'

colorAdmin = Color(255, 209, 25)
colorPrivate = Color(0, 216, 255)
colorGreen = Color(98, 220, 0)
colorError = Color(249,63,63)
colorCommand = Color(115, 170, 220)

function SES:__init()
  self.playerCount = 0
  self.players = {}

  self.weapons = { }
  self:CreateWeaponArray()

  -- Add events to global events 
  Events:Subscribe("PlayerChat", self, self.ChatControl)
  Events:Subscribe("PlayerSpawn", self, self.PlayerJoin)
  Network:Subscribe("SpawnVehicle", self, self.SpawnVehicle)
  Network:Subscribe("GiveGun", self, self.GiveGun)
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
    ": " .. Vehicle.GetNameByModelId(args.id) .. ")", colorCommand)

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
        colorError)
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

-- Controls chat commands 
function SES:ChatControl(args)
  -- Change players vehicle color
  if args.text:sub(0,13) == "/vehicleColor" then
    -- Check if player is in vehicle 
    if args.player:InVehicle() == false then 
      args.player:SendChatMessage("You must be in a vehicle to set the color of a vehicle", 
        colorError)
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
    self:SpawnVehicle(args2, args.player)
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
    Chat:Broadcast(args.player:GetName() .. " is BRB visiting jesus", colorCommand)
    return false
  end

  -- Print player position 
  if args.text == "/pos" then
    args.player:SendChatMessage(args.player:GetName() .. " is is at location " .. tostring(args.player:GetPosition()), Color(115, 170, 220))
    return false
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
    local player = GetPlayerByName(playerName)
    
    -- Send private message to player if they exist
    if player != nil then
      player:SendChatMessage(args.player:GetName() .. "(whisper): " .. mess, colorPrivate)
    end 
    
    return false
  end  

  -- Print your steam id to console
  if args.text == "/steamid" then
    args.player:SendChatMessage(tostring(args.player:GetSteamId().id), colorCommand)
  end

  return true
end

--Get player by player name 
function GetPlayerByName(playerName)
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
  Chat:Broadcast(args.player:GetName() .. " has joined the game", colorGreen)

  -- Print welcome message to player 
  args.player:SendChatMessage("Welcome to the server!", colorGreen)
  args.player:SendChatMessage("Hit F7 for help and more", colorGreen)

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
