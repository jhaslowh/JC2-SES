
-- Movecar in direction 
function TPPlayer(args, player)
  player:SetPosition(args)
  Chat:Broadcast(player:GetName() .. " teliported to " .. tostring(args), Color(115, 170, 220))
end

Network:Subscribe("TPPlayer", TPPlayer)

