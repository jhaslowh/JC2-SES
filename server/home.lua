local home = Vector3(-6386,212,-3534)

-- Called when chat message sent 
function ChatControl(args)
  -- Go home
  if args.text == "/home" then
    args.player:SetPosition(home)
    return false
  end

  -- Set home as current location
  if args.text == "/sethome" then
    home = args.player:GetPosition()
    Network:Send(args.player, "SetHome", home)
    print("Home set")
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)