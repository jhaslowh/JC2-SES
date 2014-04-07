-- Called when chat message sent 
function ChatControl(args)
  -- Change the vehicle mass of your car 
  if args.text:sub(0,5) == "/mass" then
    -- Return if not in vehicle 
    if args.player:InVehicle() == false then 
      args.player:SendChatMessage("You must be in a vehicle to set mass of a vehicle", colorError)
      return false 
    end
    -- Grab the mass value 
    local massv = args.text:sub(7,args.text:len())
    print(massv)

    -- Get vehicle 
    local veh = args.player:GetVehicle()
    veh:SetMass(tonumber(massv))

    args.player:SendChatMessage("Vehicle mass set to " .. massv, colorCommand)
    return false
  end
end

Events:Subscribe("PlayerChat", ChatControl)