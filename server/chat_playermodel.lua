-- Called when chat message sent 
function ChatControl(args)
  -- Set the weather
  if args.text:sub(0,7) == "/pmodel" then
    local num = tonumber(args.text:sub(9,args.text:len()))
    args.player:SetModelId(num)
    args.player:SendChatMessage("Model set to " .. tostring(num) .. "(if nothing, then invalid num)", colorCommand)
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)