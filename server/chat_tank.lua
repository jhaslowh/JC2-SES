-- Called when chat message sent 
function ChatControl(args)
  -- Smash player with a vehicle
  if args.text == "/tank" then
    -- Vehicle spawn arguments 
    spawnArgs = {}
    spawnArgs.model_id = 56
    spawnArgs.position = args.player:GetPosition()
    spawnArgs.angle = args.player:GetAngle()

    -- Create vehicle 
    local vehicle = Vehicle.Create(spawnArgs)
    vehicle:SetDeathRemove(true)
    vehicle:SetInvulnerable(false)
    vehicle:SetUnoccupiedRemove(true)

    args.player:EnterVehicle(vehicle, VehicleSeat.Driver)
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)
