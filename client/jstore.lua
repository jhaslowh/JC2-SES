class 'JWindow'

function JWindow:__init()
  self.active = false

  self.window = Window.Create()
  self.window:SetSizeRel( Vector2( 0.4, 0.4 ) )
  self.window:SetPositionRel( 
    Vector2( 0.5, 0.5 ) - self.window:GetSizeRel()/2 )
  self.window:SetTitle( "Server Enhancement Suite" )
  self.window:SetVisible( self.active )

  self.tab_control = TabControl.Create( self.window )
  self.tab_control:SetDock( GwenPosition.Fill )
  self.tab_control:SetTabStripPosition( GwenPosition.Top )

  self.tabs = {}

  Events:Subscribe("KeyUp", self, self.KeyUp )
  Events:Subscribe("LocalPlayerInput", self, self.LocalPlayerInput )
  self.window:Subscribe( "WindowClosed", self, self.WindowClosed )
  Events:Subscribe("ModuleLoad", self, self.ModulesLoad )
  Events:Subscribe("ModulesLoad", self, self.ModulesLoad )
  Events:Subscribe("ModuleUnload", self, self.ModuleUnload )

  -- ====================================
  -- Create GUI 

  -- Add About Tab 
  local tab_button = self.tab_control:AddPage("About")
  local page = tab_button:GetPage()
  local scroll_control = ScrollControl.Create( page )
  scroll_control:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
  scroll_control:SetScrollable( false, true )
  scroll_control:SetDock( GwenPosition.Fill )
  local label = Label.Create( scroll_control )
  label:SetPadding( Vector2( 0, 0 ), Vector2( 14, 0 ) )
  label:SetText("The following commands are recognized \n \n" .. 
            "/vehicle [num] : spawn the vehicle with specified number\n" .. 
            "/heaven : go to top of map \n" .. 
            "/pos : get your current position\n" ..
            "/tpp [player name] : teliport yourself to the given player\n" ..
            "/tpl [x] [z] : teliport to the specified location\n"..
            "/whisper [player name] \"[message]\" : send private message to player. \n\n"..
            "Admin commands\n" ..
            "/makeAdmin [player name] : make the specified player an admin\n" ..
            "/kick [player name] : Kick the player with the given name\n"..
            "/kill [player name] : kill the given player\n\n\n" ..
            "Created by: Jonathan Haslow-Hall")
  label:SetWrap( true )
  label:SetWidth( self.window:GetWidth() )
  label:SizeToContents()
  -- Add about tab to tab control 
  self.tabs["About"] = tab_button


  -- Add Vehicle list 
  tab_button = self.tab_control:AddPage("Vehicles")
  -- Add vehicle tab to tab control 
  self.tabs["Vehicles"] = tab_button


  -- Add Weapon list 
  tab_button = self.tab_control:AddPage("Weapons")
  -- Add vehicle tab to tab control 
  self.tabs["Weapons"] = tab_button


  -- Add Player tab 
  tab_button = self.tab_control:AddPage("Player")
  -- Add vehicle tab to tab control 
  self.tabs["Player"] = tab_button

end

function JWindow:ModulesLoad()
    Events:Fire( "HelpAddItem",
        {
            name = "Server Enhancement Suite",
            text = "Hit F7 to use.\n"
        } )
end

function JWindow:ModuleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Server Enhancement Suite"
        } )
end

function JWindow:GetActive()
  return self.active
end

function JWindow:SetActive( state )
  self.active = state
  self.window:SetVisible( self.active )
  Mouse:SetVisible( self.active )
end

function JWindow:KeyUp( args )
  if args.key == VirtualKey.F7 then
    self:SetActive( not self:GetActive() )
  end
end

function JWindow:LocalPlayerInput( args )
  if self:GetActive() and Game:GetState() == GUIState.Game then
    return false
  end
end

function JWindow:WindowClosed( args )
  self:SetActive( false )
end

mwindow = JWindow()
