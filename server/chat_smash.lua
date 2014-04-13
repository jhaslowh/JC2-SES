-- Called when chat message sent 
function ChatControl(args)
  -- Smash player with a vehicle
  if args.text == "/smash" then
    Smash(args, args.player)

    return false
  end

  -- Check if player is trying to smash another player 
  if args.text:sub(0,6) == "/smash" then
    local name = args.text:sub(8,args.text:len())
    for player in Server:GetPlayers() do
      if player:GetName() == name then
        Smash(args, player)
        return false
      end 
    end

    -- Display error if player could not be found
    args.player:SendChatMessage("Could not find player " .. name, Color(255, 0, 0))
    return false
  end
end

-- Smash the given player 
function Smash(args, player)
  -- Vehicle spawn arguments 
    spawnArgs = {}
    spawnArgs.model_id = 46
    spawnArgs.position = player:GetPosition() + Vector3(0,10,0)
    spawnArgs.angle = player:GetAngle()

    -- Create vehicle 
    local vehicle = Vehicle.Create(spawnArgs)
    vehicle:SetDeathRemove(true)
    vehicle:SetInvulnerable(false)
    vehicle:SetUnoccupiedRemove(true)
    vehicle:SetHealth(1)
    -- Throw vehicle down 
    vehicle:SetLinearVelocity(Vector3(
      vehicle:GetLinearVelocity().x,
      vehicle:GetLinearVelocity().y-500,
      vehicle:GetLinearVelocity().z))

    -- Display chat message 
    player:SendChatMessage("SMASH!!", Color(255, 0, 0))
end

Events:Subscribe("PlayerChat", ChatControl)
