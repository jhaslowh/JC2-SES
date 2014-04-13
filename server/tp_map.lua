
-- Movecar in direction 
function TPPlayer(args, player)
  player:SetPosition(args)
  Chat:Broadcast(player:GetName() .. " teleported to " .. tostring(args), Color(115, 170, 220))
end

Network:Subscribe("TPPlayer", TPPlayer)

