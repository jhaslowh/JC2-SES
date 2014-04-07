
-- Blow up car
function  ExplodeCar(args,player)
  -- Check if args are nil
  if args.player == nil then
    args.player = player
  end

  -- Check if still nill
  if args.player == nil then return end

  -- Return if not in vehicle 
  if args.player:InVehicle() == false then 
    player:SendChatMessage("No vehicle to blow up :( ", Color(255,0,0))
    return false 
  end

  -- Get vehicle 
  local veh = args.player:GetVehicle()
  veh:SetHealth(0)
  Chat:Broadcast("BOOM", Color(255,0,0))
end

-- Called when chat message sent 
function ChatControl(args)
  -- Clear terminal
  if args.text == "/explode" then
    ExplodeCar(args)
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)
Network:Subscribe("ExplodeCar", ExplodeCar)