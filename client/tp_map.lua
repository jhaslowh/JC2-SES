class 'Tp_Map_GUI'
 
function Tp_Map_GUI:__init( ... )
  self.map_min = 0
  self.map_max = 32768
  self.map_size = Render.Height
  self.map_x = (Render.Width*.5) - (self.map_size*.5)
  self.map_y = (Render.Height*.5) - (self.map_size*.5)
  self.map_right = self.map_x + self.map_size
  self.map_bottom = self.map_y + self.map_size


  self.map = Image.Create( AssetLocation.Game, 'pda_map_dif.dds' )
 
  -- Resize / set the initial position of the map
  self.map:SetSize( Vector2( self.map_size , self.map_size ) )
  self.map:SetPosition( Vector2( self.map_x, self.map_y))
 
  -- Settings
 
  -- Some people prefer to render a border around their PDA
  -- I prefer to fill the screen with a water colour, use 
  -- this to toggle.
  self.use_border = false 
  self.border_width = Vector2( 1, 1 )
 
 
  -- used to stop our map open input from spamming.
  self.toggle_timer = Timer()
 
  -- Events
 
  -- initialize our map render, we'll use this for subscribing to the render event later
  self.map_render = nil
 
  Events:Subscribe('LocalPlayerInput', self, self.Input )
  Events:Subscribe("KeyDown", self, self.KeyDown )
  Events:Subscribe("MouseDown", self, self.OnMouseClick)
end

-- Update mouse events 
function Tp_Map_GUI:OnMouseClick(args)
  -- If map open, check for player teliport 
  if self.map_render ~= nil then

    -- Check if left mouse button press 
    if args.button == 1 then
      -- Get mouse location
      local mloc = Mouse:GetPosition()

      -- Make sure position is inside map 
      if mloc.x > self.map_x and mloc.y > self.map_y and mloc.x < self.map_right and mloc.y < self.map_bottom then
        local pos = {}
        -- Get Map locations 
        pos.x = (((mloc.x - self.map_x) / (self.map_right - self.map_x)) * self.map_max) - (self.map_max * .5) 
        pos.z = (((mloc.y - self.map_y) / (self.map_bottom - self.map_y)) * self.map_max) - (self.map_max * .5) 
        pos.y = Physics:GetTerrainHeight(Vector2(pos.x, pos.z)) + 5
        self:Toggle()
        Network:Send("TPPlayer", Vector3(pos.x, pos.y, pos.z))
      end
    end 
    return false
  end
end

-- Update key presses 
function Tp_Map_GUI:KeyDown(args)
  print(args.key)
  -- Toggle map
  if args.key == 80 then
    -- Toggle the new PDA map.
    self:Toggle()
    -- Block the game from opening the standard Just Cause 2 PDA map.
    return false
  elseif args.key == 4 then

    return false
  end
end
 
-- Update map input 
function Tp_Map_GUI:Input( e )
  local input = e.input
  if self.map_render ~= nil then
    -- Input lock --
    -- Block any game inputs while the map is rendering
    return false
  end
 
end
 
-- Toggle map on and off 
function Tp_Map_GUI:Toggle( ... )
  if self.toggle_timer:GetMilliseconds() > 250 then
    self.toggle_timer:Restart()
 
    if self.map_render == nil then
 
      -- map currently isn't rendering so open the PDA
      self.map_render = Events:Subscribe( 'Render', self, self.Render )
      Mouse:SetVisible( true )
 
    else
 
      -- map is currently rendering so close the PDA
      Events:Unsubscribe( self.map_render )
      self.map_render = nil
      Mouse:SetVisible( false )
 
    end
  end
end
 
-- Draw map to screen
function Tp_Map_GUI:Render( ... )
  if self.map == nil then return end
 
  if self.use_border then
    --Border Render
    Render:FillArea( self.map:GetPosition()-self.border_width, self.map:GetSize()+self.border_width*2, Color.Black )
  else
    -- Water Render
    Render:FillArea( Vector2.Zero, Render.Size, Color(6,36,47,255) )
  end
 
  -- Render our map.
  self.map:Draw()
 
 
  -- Anything you wish to draw on top of your map goes here.
end
 
function ModuleLoad()
  pda = Tp_Map_GUI()
end
 
Events:Subscribe('ModuleLoad', ModuleLoad)