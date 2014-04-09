-- Called when chat message sent 
function ChatControl(args)
  -- Fall from the heavens 
  if args.text == "/heaven" then
    local currentPosition = args.player:GetPosition()
    local newPosition = currentPosition + Vector3(0, 15000, 0)
    args.player:SetPosition(newPosition)
    Chat:Broadcast(args.player:GetName() .. " is BRB visiting jesus", Color(115, 170, 220))
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)