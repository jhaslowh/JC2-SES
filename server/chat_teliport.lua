-- Called when chat message sent 
function ChatControl(args)
  -- Teliport to given player
  if args.text:sub(0,4) == "/tpp" then 
    local pname = args.text:sub(6,args.text:len())
    for player in Server:GetPlayers() do
      if player:GetName() == pname then
        args.player:SetPosition(player:GetPosition())
        Chat:Broadcast(args.player:GetName() .. " teliported to " .. player:GetName(), Color(115, 170, 220))
        return false
      end 
    end
    args.player:SendChatMessage("Player " .. pname .. " not found", Color(115, 170, 220))
    return false
  end

  -- Teliport to given place on map 
  if args.text:sub(0,4) == "/tpl" then 
    local loc = args.text:sub(6,args.text:len())
    local xloc = tonumber(loc:sub(0,loc:find("%s")))
    local zloc = tonumber(loc:sub(loc:find("%s"),loc:len()))
    args.player:SetPosition(Vector3(xloc, 500.0, zloc))
  end 
end

Events:Subscribe("PlayerChat", ChatControl)