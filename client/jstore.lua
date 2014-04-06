class 'JWindow'

function JWindow:__init()
  self.active = false
  -- Bool for primary weapon 
  self.primary = false 

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
            "Commands for Everyone\n------------------------------------------------------------------------------------\n" ..
            "/vehicle [num] : spawn the vehicle with specified number\n" .. 
            "/vehicleColor [r] [g] [b] : set the color or your vehicle, values are [0-255]\n"..
            "/weapon [num] : Give yourself the gun with index num\n"..
            "/heaven : go to top of map \n" .. 
            "/pos : get your current position\n" ..
            "/tpp [player name] : teliport yourself to the given player\n" ..
            "/tpl [x] [z] : teliport to the specified location\n"..
            "/time [value] : Set the time of day for the world. Can either be a number [0-24], \"day\", or \"night\"\n"..
            "/weather [value] : Set the weather of the world. Can either be [0-2], \"sunny\", \"rain\", or \"storm\".\n"..
            "/clear : Clear chat\n"..
            "/whisper [player name] \"[message]\" : send private message to player. \n"..
            "\n\nAdmin commands\n------------------------------------------------------------------------------------\n" ..
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
  -- Create vehicle list
  self.list = ListBox.Create( tab_button:GetPage() )
  self.list:SetDock( GwenPosition.Fill )
  self.list:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
  self.list:SetScrollable(false,true)
  --self.list:SetColumnCount(1)
  self:FillVehicleList()
  -- Create spawn button 
  local button1 = Button.Create(tab_button:GetPage())
  button1:SetDock(GwenPosition.Bottom)
  button1:SetSize(Vector2(self.window:GetSize().x, 32)) 
  button1:SetText("Spawn")
  button1:Subscribe("Press", self, self.VehicleSpawnPressed)
  -- Add vehicle tab to tab control 
  self.tabs["Vehicles"] = tab_button


  -- Add Weapon list 
  tab_button = self.tab_control:AddPage("Weapons")
  -- Create weapon list
  self.wlist = ListBox.Create( tab_button:GetPage() )
  self.wlist:SetDock( GwenPosition.Fill )
  self.wlist:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
  self.wlist:SetScrollable(false,true)
  --self.wlist:SetColumnCount(1)
  self:FillWeaponList()
  -- Create spawn button 
  local page1 = PageControl.Create(tab_button:GetPage())
    page1:SetDock(GwenPosition.Bottom)
    page1:SetSize(Vector2(self.window:GetSize().x, 32)) 
    button1 = Button.Create(page1)
    button1:SetSize(Vector2(200, 32)) 
    button1:SetText("Give Weapon")
    button1:Subscribe("Press", self, self.GiveWeapon)
  -- Create primary checkbox
  local primaryw_checkbox = LabeledCheckBox.Create(page1)
    primaryw_checkbox:SetPosition(Vector2(210,0))
    primaryw_checkbox:SetSize( Vector2( 140, 20 ) )
    primaryw_checkbox:GetLabel():SetText( "Primary weapon" )
    primaryw_checkbox:GetCheckBox():SetChecked( self.primary )
    primaryw_checkbox:GetCheckBox():Subscribe( "CheckChanged", 
      function() self.primary = primaryw_checkbox:GetCheckBox():GetChecked() end )
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

-- Called when spawn button pressed 
function JWindow:VehicleSpawnPressed(args)
  local pass = {}
  local row = tonumber(self.list:GetSelectedRowName())
  -- Return if invalid
  if row == nil or row < 0 then return end
  -- Get Vehicle model number
  pass.id = row
  Network:Send("SpawnVehicle", pass)
  self:WindowClosed()
end

-- Called when weapon spawn button pressed
function JWindow:GiveWeapon(args)
  -- body
end

-- Add all weapons to weapon list
function JWindow:FillWeaponList()
  self.wlist:AddItem("Airzooka", "101")
  self.wlist:AddItem("AlphaDLCWeapon", "100")
  self.wlist:AddItem("Assault", "11")
  self.wlist:AddItem("BigCannon", "34")
  self.wlist:AddItem("BubbleGun", "43")
  self.wlist:AddItem("Cannon", "134")
  self.wlist:AddItem("Grenade Launcher", "17")
  self.wlist:AddItem("Handgun", "2")
  self.wlist:AddItem("Heavy Machine Gun", "129")
  self.wlist:AddItem("Machine Gun", "28")
  self.wlist:AddItem("Machine Gun LAVE", "129")
  self.wlist:AddItem("Minigun", "26")

end


-- Add all vehicles to vehicle list 
function JWindow:FillVehicleList()
  -- Land Vehicles 
  self.list:AddItem("----------------------------------------------------------------------------------------------------", "-1")
  self.list:AddItem("   Land Vehicles         ", "-1")
  self.list:AddItem("----------------------------------------------------------------------------------------------------", "-1")
  self.list:AddItem("1 Dongtai Agriboss 35", "1")
  self.list:AddItem("2 Mancini Cavallo 1001", "2")
  self.list:AddItem("4 Kenwall Heavy Rescue", "4")
  self.list:AddItem("7 Poloma Renegade", "7")
  self.list:AddItem("8 Columbi Excelsior", "8")
  self.list:AddItem("9 Tuk-Tuk Rickshaw","9")
  self.list:AddItem("10  Saas PP12 Hogg","10")
  self.list:AddItem("11  Shimuzu Tracline","11")
  self.list:AddItem("12  Vanderbildt LeisureLiner","12")
  self.list:AddItem("13  Stinger Dunebug 84","13")
  self.list:AddItem("15  Sakura Aquila Space","15")
  self.list:AddItem("18  SV-1003 Raider","18")
  self.list:AddItem("21  Hamaya Cougar 600","21")
  self.list:AddItem("20  (DLC) Monster Truck","20")
  self.list:AddItem("22  Tuk-Tuk Laa","22")
  self.list:AddItem("23  Chevalier Liner SB","23")
  self.list:AddItem("26  Chevalier Traveller SD","26")
  self.list:AddItem("29  Sakura Aquila City","29")
  self.list:AddItem("31  URGA-9380","31")
  self.list:AddItem("32  Mosca 2000","32")
  self.list:AddItem("33  Chevalier Piazza IX","33")
  self.list:AddItem("35  Garret Traver-Z","35")
  self.list:AddItem("36  Shimuzu Tracline","36")
  self.list:AddItem("40  Fengding EC14FD2","40")
  self.list:AddItem("41  Niseco Coastal D22","41")
  self.list:AddItem("42  Niseco Tusker P246","42")
  self.list:AddItem("43  Hamaya GSY650","43")
  self.list:AddItem("44  Hamaya Oldman","44")
  self.list:AddItem("46  MV V880","46")
  self.list:AddItem("47  Schulz Virginia","47")
  self.list:AddItem("48  Maddox FVA 45","48")
  self.list:AddItem("49  Niseco Tusker D18","49")
  self.list:AddItem("52  Saas PP12 Hogg","52")
  self.list:AddItem("54  Boyd Fireflame 544","54")
  self.list:AddItem("55  Sakura Aquila Metro ST","55")
  self.list:AddItem("56  GV-104 Razorback","56")
  self.list:AddItem("58  (DLC) Chevalier Classic","58")
  self.list:AddItem("60  Vaultier Patrolman","60")
  self.list:AddItem("61  Makoto MZ 260X","61")
  self.list:AddItem("63  Chevalier Traveller SC","63")
  self.list:AddItem("66  Dinggong 134D","66")
  self.list:AddItem("68  Chevalier Traveller SX","68")
  self.list:AddItem("70  Sakura Aguila Forte","70")
  self.list:AddItem("71  Niseco Tusker G216","71")
  self.list:AddItem("72  Chepachet PVD","72")
  self.list:AddItem("73  Chevalier Express HT","73")
  self.list:AddItem("74  Hamaya 1300 Elite Cruiser","74")
  self.list:AddItem("75  (DLC) Tuk Tuk Boom Boom","75")
  self.list:AddItem("76  SAAS PP30 Ox","76")
  self.list:AddItem("77  Hedge Wildchild","77")
  self.list:AddItem("78  Civadier 999","78")
  self.list:AddItem("79  Pocumtuck Nomad","79")
  self.list:AddItem("82  (DLC) Chevalier Ice Breaker","82")
  self.list:AddItem("83  Mosca 125 Performance","83")
  self.list:AddItem("84  Marten Storm III","84")
  self.list:AddItem("86  Dalton N90","86")
  self.list:AddItem("87  Wilforce Trekstar","87")
  self.list:AddItem("89  Hamaya Y250S","89")
  self.list:AddItem("90  Makoto MZ 250","90")
  self.list:AddItem("91  Titus ZJ","91")
  --self.list:SelectByString("1 Dongtai Agriboss 35")
end


mwindow = JWindow()
