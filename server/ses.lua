
class 'SES'

colorAdmin = Color(255, 209, 25)
colorPrivate = Color(0, 216, 255)
colorGreen = Color(98, 220, 0)
colorError = Color(249,63,63)
colorCommand = Color(115, 170, 220)

function SES:__init()
  -- Add events to global events 
  Events:Subscribe("PlayerChat", self, self.ChatControl)
  Events:Subscribe("PlayerJoin", self, self.PlayerJoin)
  Events:Subscribe("PlayerQuit", self, self.PlayerQuit)
end


-- Controls chat commands 
function SES:ChatControl(args)
  -- Fall from the heavens 
  if args.text == "/heaven" then
    local currentPosition = args.player:GetPosition()
    local newPosition = currentPosition + Vector3(0, 15000, 0)
    args.player:SetPosition(newPosition)
    Chat:Broadcast(args.player:GetName() .. " is BRB visiting jesus", colorCommand)
    return false
  end

  -- Print player position 
  if args.text == "/pos" then
    args.player:SendChatMessage(args.player:GetName() .. " is is at location " .. tostring(args.player:GetPosition()), Color(115, 170, 220))
    return false
  end

  -- Print your steam id to console
  if args.text == "/steamid" then
    args.player:SendChatMessage(tostring(args.player:GetSteamId().id), colorCommand)
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

-- Player join 
function  SES:PlayerJoin(args)
  -- Set player skin (this will sometimes generate a invalid model)
  math.randomseed( os.time() )
  args.player:SetModelId(math.random(1,103))

  -- Print global chat message 
  Chat:Broadcast(args.player:GetName() .. " has joined the game", colorGreen)

  -- Print welcome message to player 
  args.player:SendChatMessage("Welcome to the server!", colorGreen)
  args.player:SendChatMessage("Hit F7 for help and more", colorGreen)

end

-- Player quit
function SES:PlayerQuit(args)
  -- Print global chat message 
  Chat:Broadcast(args.player:GetName() .. " has left the game", colorGreen)
end

ses = SES()
