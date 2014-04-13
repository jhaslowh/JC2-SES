-- Called when chat message sent 
function ChatControl(args)
  -- Smash player with a vehicle
  if args.text:sub(0,7) == "/effect" then
    local num = tonumber(args.text:sub(9,args.text:len()))
    Chat:Broadcast(args.player:GetName() .. ": trying to play effect " .. tostring(num), Color(115, 170, 220))
    args2 = {}
    args2.num = num
    args2.player = args.player
    Network:Send(args.player, "SpawnEffect", args2)
  end
end

Events:Subscribe("PlayerChat", ChatControl)
