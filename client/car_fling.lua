
function KeyDown( args )
  if args.key == 85 then
    Network:Send("MoveUp", nil)
  elseif args.key == 38 then
    Network:Send("MoveCar", {yaw=Camera:GetAngle().yaw, up=true,down=false,left=false,right=false})
  elseif args.key == 37 then
    Network:Send("MoveCar", {yaw=Camera:GetAngle().yaw, up=false,down=false,left=true,right=false})
  elseif args.key == 39 then
    Network:Send("MoveCar", {yaw=Camera:GetAngle().yaw, up=false,down=false,left=false,right=true})
  elseif args.key == 40 then
    Network:Send("MoveCar", {yaw=Camera:GetAngle().yaw, up=false,down=true,left=false,right=false})
  end
end

Events:Subscribe("KeyDown", KeyDown )
