-- Called when chat message sent 
function ChatControl(args)
  -- Clear terminal
  if args.text == "/clear" then
    for i = 0, 12 do
      args.player:SendChatMessage("", Color(0, 0, 0))
    end
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)