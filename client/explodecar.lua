function KeyDown( args )
  if args.key == 66 then
    Network:Send("ExplodeCar", args)
  end
end

Events:Subscribe("KeyDown", KeyDown)
