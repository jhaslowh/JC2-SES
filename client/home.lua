
local homeLoc = Vector3(-6386,208,-3534)

function SetHome(v)
  homeLoc = v
end

function DrawHome()
  -- Make sure valid state and world
  if Game:GetState() ~= GUIState.Game then return end
  if LocalPlayer:GetWorld() ~= DefaultWorld then return end

  -- Check distance 
  local dist = homeLoc:Distance2D( Camera:GetPosition() )

  -- If in right distance 
  if dist < 6000 and dist > 512 then

    -- This code is from freeroam.lua 
    local pos = homeLoc + Vector3( 0, 250, 0 )
    local angle = Angle(Camera:GetAngle().yaw, 0, math.pi ) * Angle( math.pi, 0, 0 )

    local text = "/home"
    local text_size = Render:GetTextSize( text, TextSize.VeryLarge )

    local t = Transform3()
    t:Translate( pos )
    t:Scale( 1.0 )
    t:Rotate( angle )
    t:Translate( -Vector3( text_size.x, text_size.y, 0 )/2 )
    Render:SetTransform( t )

    local shadow_colour = Color( 0, 0, 0, 255 )
    shadow_colour = shadow_colour * 0.4

    Render:DrawText( Vector3( 1, 1, 0 ), text, shadow_colour, TextSize.VeryLarge, 1.0 )
    Render:DrawText( Vector3( 0, 0, 0 ), text, Color( 255, 255, 255, 255 ), TextSize.VeryLarge, 1.0 )
  end
end

Events:Subscribe("Render", DrawHome)
Network:Subscribe("SetHome", SetHome)

