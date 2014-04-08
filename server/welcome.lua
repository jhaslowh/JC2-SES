-- Player join 
function  PlayerJoin(args)
  -- Set player skin (this will sometimes generate a invalid model)
  math.randomseed( os.time() )
  args.player:SetModelId(math.random(1,103))

  -- Print global chat message 
  Chat:Broadcast(args.player:GetName() .. " has joined the game", Color(98, 220, 0))

  -- Print welcome message to player 
  args.player:SendChatMessage("Welcome to the server!", Color(98, 220, 0))
  args.player:SendChatMessage("Hit F7 for help and more", Color(98, 220, 0))

end

-- Player quit
function PlayerQuit(args)
  -- Print global chat message 
  Chat:Broadcast(args.player:GetName() .. " has left the game", Color(98, 220, 0))
end

Events:Subscribe("PlayerJoin", PlayerJoin)
Events:Subscribe("PlayerQuit", PlayerQuit)