
colorAdmin = Color(255, 209, 25)
colorPrivate = Color(0, 216, 255)
colorError = Color(249,63,63)
colorCommand = Color(115, 170, 220)

-- Controls chat commands 
function ChatControl(args)
  -- Fall from the heavens 
  if args.text == "/heaven" then
    local currentPosition = args.player:GetPosition()
    local newPosition = currentPosition + Vector3(0, 15000, 0)
    args.player:SetPosition(newPosition)
    Chat:Broadcast(args.player:GetName() .. " is BRB visiting jesus", Color(115, 170, 220))
    return false
  end

  -- Print player position 
  if args.text == "/pos" then
    args.player:SendChatMessage(args.player:GetName() .. " is is at location " .. 
      tostring(args.player:GetPosition()), Color(115, 170, 220))
    return false
  end

  -- Print your steam id to console
  if args.text == "/steamid" then
    args.player:SendChatMessage(tostring(args.player:GetSteamId().id), Color(115, 170, 220))
  end

  return true
end

--Get player by player name 
function GetPlayerByName(playerName)
  for player in Server:GetPlayers() do
    if player:GetName() == playerName then
      return player
    end 
  end
  return nil
end

Events:Subscribe("PlayerChat", ChatControl)
