-- Called when chat message sent 
function ChatControl(args)
  -- Print your steam id to console
  if args.text == "/steamid" then
    args.player:SendChatMessage(tostring(args.player:GetSteamId().id), Color(115, 170, 220))
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)