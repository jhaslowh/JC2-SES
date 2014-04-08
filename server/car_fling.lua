-- Move up 
-- Will make the car fly up into the air 
function  MoveUp(args, player)
  -- Return if not in vehicle 
  if player:InVehicle() then 
    -- Get vehicle 
    local veh = player:GetVehicle()
    veh:SetLinearVelocity(Vector3(0,100,0))
  end
end

-- Movecar in direction 
function MoveCar(args, player)
  local y = math.sin(args.yaw)
  local x = math.cos(args.yaw)

  -- Return if not in vehicle 
  if player:InVehicle() then 
    if args.up == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(-y * 100.0, 0, -x * 100.0))
    elseif args.left == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(-x * 100.0, 0, y * 100.0)) 
    elseif args.right == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(x * 100.0, 0, -y * 100.0))
    elseif args.down == true then 
      -- Get vehicle 
      local veh = player:GetVehicle()
      veh:SetLinearVelocity(Vector3(y * 100.0, 0, x * 100.0))
    end 
  end
end

Network:Subscribe("MoveUp", MoveUp)
Network:Subscribe("MoveCar", MoveCar)
