function SpawnEffect(args)
  ClientEffect.Play(AssetLocation.Game, {
    effect_id = args.num,
    position = args.player:GetPosition(),
    angle = args.player:GetAngle()
  })
end

Network:Subscribe("SpawnEffect", SpawnEffect)