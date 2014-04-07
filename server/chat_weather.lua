-- Called when chat message sent 
function ChatControl(args)
  -- Set the weather
  if args.text:sub(0,8) == "/weather" then
    -- Grab the weather value 
    local wea = args.text:sub(10,args.text:len())
    -- Check weather words 
    if wea == "sunny" then
      DefaultWorld:SetWeatherSeverity(0)
      Chat:Broadcast(args.player:GetName() .. " set weather to sunny", Color(115, 170, 220))
      return false
    end
    if wea == "rain" then
      DefaultWorld:SetWeatherSeverity(1)
      Chat:Broadcast(args.player:GetName() .. " set weather to rain", Color(115, 170, 220))
      return false
    end
    if wea == "storm" then
      DefaultWorld:SetWeatherSeverity(2)
      Chat:Broadcast(args.player:GetName() .. " set weather to storm", Color(115, 170, 220))
      return false
    end

    wea = tonumber(wea)
    if wea < 0 or wea > 2 then
      args.player:SendChatMessage("Weather value must be [0-2]", Color(249,63,63))
      return false
    end

    DefaultWorld:SetWeatherSeverity(wea)
    Chat:Broadcast(args.player:GetName() .. " set weather to " .. tostring(wea), Color(115, 170, 220))
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)