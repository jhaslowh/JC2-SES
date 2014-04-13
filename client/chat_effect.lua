function SpawnEffect(args)
  local y = math.sin(args.player:GetAngle().yaw)
  local x = math.cos(args.player:GetAngle().yaw)

  ClientEffect.Play(AssetLocation.Game, {
    effect_id = args.num,
    position = args.player:GetPosition() + Vector3(-y * 5.0, 2, -x * 5.0),
    angle = args.player:GetAngle()
  })
end

Network:Subscribe("SpawnEffect", SpawnEffect)