
function KeyDown( args )
  print(args.key)
  if args.key == 70 then
    Network:Send("Hop", nil)
  end
end

Events:Subscribe("KeyDown", KeyDown )
