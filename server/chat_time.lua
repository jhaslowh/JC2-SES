-- Called when chat message sent 
function ChatControl(args)
  -- Set the time of day 
  if args.text:sub(0,5) == "/time" then
    -- Grab the time value 
    local timev = args.text:sub(7,args.text:len())

    -- Check time words 
    if timev == "day" then
      DefaultWorld:SetTime(12)
      Chat:Broadcast(args.player:GetName() .. " set time to day", Color(115, 170, 220))
      return false
    end
    if timev == "night" then
      DefaultWorld:SetTime(0)
      Chat:Broadcast(args.player:GetName() .. " set time to night", Color(115, 170, 220))
      return false
    end

    timev = tonumber(timev)
    if timev < 0 or timev > 24 then
      args.player:SendChatMessage("Time must be [0-24]", Color(255, 0, 0))
      return false
    end
    DefaultWorld:SetTime(timev)
    Chat:Broadcast(args.player:GetName() .. " set time to " .. tostring(timev), Color(115, 170, 220))
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)