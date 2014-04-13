-- Move up 
-- Will make the car hop
function  Hop(args, player)
  -- Return if not in vehicle 
  if player:InVehicle() then 
    -- Get vehicle 
    local veh = player:GetVehicle()
    veh:SetLinearVelocity(Vector3(
      veh:GetLinearVelocity().x,
      veh:GetLinearVelocity().y+4,
      veh:GetLinearVelocity().z))
  end
end

Network:Subscribe("Hop", Hop)
