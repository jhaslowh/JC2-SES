-- Called when chat message sent 
function ChatControl(args)
  -- Whisper to a player 
  if args.text:sub(0,8) == "/whisper" then 
    -- Remove command
    local text = args.text:sub(10,args.text:len())
    local qstart = text:find("\"")
    -- Return if no message 
    if qstart == nil then
      return false
    end
    -- Get player name
    local playerName = text:sub(0, qstart-2)
    -- Get Message 
    local mess = text:sub(qstart, text:len())
    -- Get player
    local player = GetPlayerByName(playerName)
    
    -- Send private message to player if they exist
    if player != nil then
      player:SendChatMessage(args.player:GetName() .. "(whisper): " .. mess, Color(0, 216, 255))
    end 
    
    return false
  end  
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