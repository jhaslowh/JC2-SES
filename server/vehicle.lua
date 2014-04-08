-- Called when chat message sent 
function ChatControl(args)
  -- Change players vehicle color
  if args.text:sub(0,13) == "/vehicleColor" or args.text:sub(0,13) == "/vehiclecolor"then
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


  -- Change the vehicle mass of your car 
  if args.text:sub(0,12) == "/vehicleMass" or args.text:sub(0,12) == "/vehiclemass" then
    -- Return if not in vehicle 
    if args.player:InVehicle() == false then 
      args.player:SendChatMessage("You must be in a vehicle to set mass of a vehicle", colorError)
      return false 
    end
    -- Grab the mass value 
    local massv = args.text:sub(14,args.text:len())
    print(massv)

    -- Get vehicle 
    local veh = args.player:GetVehicle()
    veh:SetMass(tonumber(massv))

    args.player:SendChatMessage("Vehicle mass set to " .. massv, colorCommand)
    return false
  end


  -- Spawn a vehicle and put them inside it.
  if args.text:sub(0,8) == "/vehicle" then
    local args2 = {id=tonumber(args.text:sub(10,args.text:len()))}
    SpawnVehicle(args2, args.player)
    return false
  end
end

-- Call to spawn a vehicle 
function SpawnVehicle(args, player)
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

Events:Subscribe("PlayerChat", ChatControl)
Network:Subscribe("SpawnVehicle", SpawnVehicle)