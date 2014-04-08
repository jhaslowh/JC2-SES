-- Call to give a weapon to a player
function GiveGun(args, player)
  if args.id < 0 or args.id > 26 then 
    player:SendChatMessage("Please select a number in the range [0-26]", colorError)
    return
  end

  -- Get the weapon 
  local id = weapons[args.id]

  -- Give gun to player 
  if args.primary then 
    player:GiveWeapon( WeaponSlot.Primary, Weapon(id,100,999))
  end
  if args.primary == false then
    player:GiveWeapon( WeaponSlot.Right, Weapon(id,100,999))
  end
end

-- Controls chat commands 
function ChatControl(args)
  -- Give a weapon 
  if args.text:sub(0,7) == "/weapon" then
    -- Check if no args given 
    if args.text:len() < 9 then return false end
    -- Parse args
    local args2 = 
    {
      id = tonumber(args.text:sub(9, args.text:len())),
      primary = true
    }
    -- Give gun 
    GiveGun(args2, args.player)
    return false
  end
end


weapons = { }
weapons[0] = Weapon.Assault
weapons[1] = Weapon.BubbleGun 
weapons[2] = Weapon.GrenadeLauncher 
weapons[3] = Weapon.Handgun 
weapons[4] = Weapon.HeavyMachineGun 
weapons[5] = Weapon.MachineGun 
weapons[6] = Weapon.MachinegunARVE 
weapons[7] = Weapon.Minigun 
weapons[8] = Weapon.MinigunARVE 
weapons[9] = Weapon.MinigunLAVE 
weapons[10] = Weapon.MinigunVehicle 
weapons[11] = Weapon.MultiTargetRocketLauncher 
weapons[12] = Weapon.PanayRocketLauncher 
weapons[13] = Weapon.Revolver 
weapons[14] = Weapon.RocketARVE 
weapons[15] = Weapon.RocketLAVE 
weapons[16] = Weapon.RocketLauncher 
weapons[17] = Weapon.SAM 
weapons[18] = Weapon.SMG 
weapons[19] = Weapon.SawnOffShotgun 
weapons[20] = Weapon.SentryGun 
weapons[21] = Weapon.Shotgun 
weapons[22] = Weapon.Sniper 
weapons[23] = Weapon.V022_VHLRKT 
weapons[24] = Weapon.V023_VHLRKT 
weapons[25] = Weapon.V089_VHLRKT 
weapons[26] = Weapon.Vulcan 

Events:Subscribe("PlayerChat", ChatControl)
Network:Subscribe("GiveGun", GiveGun)
