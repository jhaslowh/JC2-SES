-- Called when chat message sent 
function ChatControl(args)
  -- Print player position 
  if args.text == "/pos" then
    args.player:SendChatMessage(args.player:GetName() .. " is is at location " .. 
      tostring(args.player:GetPosition()), colorCommand)
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)