class 'SESGUI'

function SESGUI:__init()
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
  Events:Subscribe("KeyDown", self, self.KeyDown )
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
  label:SetText(
    "The following commands are recognized by chat\n \n" .. 
    "Commands for Everyone\n------------------------------------------------------------------------------------\n" ..
    "/vehicle [num] : spawn the vehicle with specified number\n" .. 
    "/vehicleColor [r] [g] [b] : set the color or your vehicle, values are [0-255]\n"..
    "/mass [num] : set the vehicle mass to the specified value\n"..
    "/repair : repair current vehicle\n"..
    "/explode : blow up car\n"..
    "/weapon [num] : give yourself the gun with index [0-26]\n"..
    "/heaven : go to top of map \n" .. 
    "/pos : get your current position\n" ..
    "/tpp [player name] : teliport yourself to the given player\n" ..
    "/tpl [x] [z] : teliport to the specified location\n"..
    "/time [value] : set the time of day for the world. Can either be a number [0-24], \"day\", or \"night\"\n"..
    "/weather [value] : set the weather of the world. Can either be [0-2], \"sunny\", \"rain\", or \"storm\".\n"..
    "/clear : clear chat\n"..
    "/home : go home\n"..
    "/sethome : set the home location to the players current location\n"..
    "/whisper [player name] \"[message]\" : send private message to player. \n"..
    "/steamid : print out your steam id to your own chat \n"..
    "\nAdmin commands\n------------------------------------------------------------------------------------\n" ..
    "/makeAdmin [player name] : make the specified player an admin\n" ..
    "/kick [player name] : kick the player with the given name\n"..
    "/kill [player name] : kill the given player\n" ..
     "\nButtons\n------------------------------------------------------------------------------------\n" ..
    "F7 - Open Interactive GUI\n"..
    "B - Blow up car\n"..
    "U - Makes car fly up into air\n"..  
    "Arrows - Apply Linear Velocity to car\n"..  
    "P - Open Teliport map \n".. 
    "--- When map is open, click on a position to teliport there. \n"..
    "\nCreated by: Jonathan Haslow-Hall")
  label:SetWrap( true )
  label:SetWidth( self.window:GetWidth() )
  label:SizeToContents()
  -- Add about tab to tab control 
  self.tabs["About"] = tab_button


  -- Add Vehicle list 
  tab_button = self.tab_control:AddPage("Vehicles")
  -- Tabs page for vehicles
  self.vtabcontrol = TabControl.Create(tab_button:GetPage())
  self.vtabcontrol:SetDock( GwenPosition.Fill )
  self.vtabcontrol:SetTabStripPosition( GwenPosition.Top )
  -- Add tabs for each type
  self.vtabs = {}
  self.vtabs[0] = self.vtabcontrol:AddPage("Land")
  self.vtabs[1] = self.vtabcontrol:AddPage("Water")
  self.vtabs[2] = self.vtabcontrol:AddPage("Air")
  -- Create land vehicle list
  self.list1 = ListBox.Create( self.vtabs[0]:GetPage() )
  self.list1:SetDock( GwenPosition.Fill )
  self.list1:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
  self.list1:SetScrollable(false,true)
  -- Create Water vehicle list
  self.list2 = ListBox.Create( self.vtabs[1]:GetPage() )
  self.list2:SetDock( GwenPosition.Fill )
  self.list2:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
  self.list2:SetScrollable(false,true)
  -- Create Air vehicle list
  self.list3 = ListBox.Create( self.vtabs[2]:GetPage() )
  self.list3:SetDock( GwenPosition.Fill )
  self.list3:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
  self.list3:SetScrollable(false,true)
  -- Fill lists 
  self:FillVehicleList()
  -- Create Page for Vehicle controls 
  local page1 = BaseWindow.Create(tab_button:GetPage())
    page1:SetDock(GwenPosition.Right)
    page1:SetSize(Vector2(self.window:GetSize().x/2, self.window:GetSize().y)) 
  -- Create spawn button 
  local button1 = Button.Create(page1)
  button1:SetDock(GwenPosition.Bottom)
  button1:SetSize(Vector2(page:GetSize().x, 32)) 
  button1:SetText("Spawn")
  button1:Subscribe("Press", self, self.VehicleSpawnPressed)
  -- Color Picker 
  self.cp = ColorPicker.Create(page1)
  self.cp:SetDock(GwenPosition.Top)
  -- Add vehicle tab to tab control 
  self.tabs["Vehicles"] = tab_button


  -- Add Weapon list 
  tab_button = self.tab_control:AddPage("Weapons")
  -- Create weapon list
  self.wlist = ListBox.Create( tab_button:GetPage() )
  self.wlist:SetDock( GwenPosition.Fill )
  self.wlist:SetMargin( Vector2( 4, 4 ), Vector2( 4, 4 ) )
  self.wlist:SetScrollable(false,true)
  self:FillWeaponList()
  -- Create spawn button 
  page1 = BaseWindow.Create(tab_button:GetPage())
    page1:SetDock(GwenPosition.Bottom)
    page1:SetSize(Vector2(self.window:GetSize().x, 32)) 
  button1 = Button.Create(page1)
    button1:SetSize(Vector2(200, 32)) 
    button1:SetText("Give Weapon")
    button1:Subscribe("Press", self, self.GiveWeapon)
  -- Create primary checkbox
  local primaryw_checkbox = LabeledCheckBox.Create(page1)
    primaryw_checkbox:SetPosition(Vector2(210,0))
    primaryw_checkbox:SetSize(Vector2(140, 20))
    primaryw_checkbox:GetLabel():SetText("Primary weapon")
    primaryw_checkbox:GetCheckBox():SetChecked(self.primary)
    primaryw_checkbox:GetCheckBox():Subscribe("CheckChanged", 
      function() self.primary = primaryw_checkbox:GetCheckBox():GetChecked() end )
  -- Add vehicle tab to tab control 
  self.tabs["Weapons"] = tab_button


  -- Add Player tab 
  tab_button = self.tab_control:AddPage("Player")
  -- Add vehicle tab to tab control 
  self.tabs["Player"] = tab_button

end

function SESGUI:ModulesLoad()
    Events:Fire( "HelpAddItem",
        {
            name = "Server Enhancement Suite",
            text = "Hit F7 to use.\n"
        } )
end

function SESGUI:ModuleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "Server Enhancement Suite"
        } )
end

function SESGUI:GetActive()
  return self.active
end

function SESGUI:SetActive( state )
  self.active = state
  self.window:SetVisible( self.active )
  Mouse:SetVisible( self.active )
end

function SESGUI:KeyUp( args )
  if args.key == VirtualKey.F7 then
    self:SetActive( not self:GetActive() )
  end
end

function SESGUI:KeyDown( args )

end

function SESGUI:LocalPlayerInput( args )
  if self:GetActive() and Game:GetState() == GUIState.Game then
    return false
  end
end

function SESGUI:WindowClosed( args )
  self:SetActive( false )
end

-- Called when spawn button pressed 
function SESGUI:VehicleSpawnPressed(args)
  local pass = {}
  local row = 0
  if self.vtabcontrol:GetCurrentTab() == self.vtabs[0] then
    row = tonumber(self.list1:GetSelectedRowName())
  elseif self.vtabcontrol:GetCurrentTab() == self.vtabs[1] then
    row = tonumber(self.list2:GetSelectedRowName())
  elseif self.vtabcontrol:GetCurrentTab() == self.vtabs[2] then
    row = tonumber(self.list3:GetSelectedRowName())
  end
  -- Return if invalid
  if row == nil or row < 0 then return end
  -- Get Vehicle model number
  pass.id = row
  pass.color1 = self.cp:GetColor()
  Network:Send("SpawnVehicle", pass)
  self:SetActive( false )
end

-- Called when weapon spawn button pressed
function SESGUI:GiveWeapon(args)
  local pass = {}
  local row = tonumber(self.wlist:GetSelectedRowName())
  -- Return if invalid
  if row == nil or row < 0 then return end
  -- Get weapon model number
  pass.id = row
  pass.primary = self.primary
  Network:Send("GiveGun", pass)
  self:SetActive( false )
end

-- Add all weapons to weapon list
function SESGUI:FillWeaponList()
  self.wlist:AddItem("Assault","0")
  self.wlist:AddItem("Bubble Gun","1")
  self.wlist:AddItem("Grenade Launcher","2")
  self.wlist:AddItem("Handgun","3")
  self.wlist:AddItem("Heavy Machine Gun","4")
  self.wlist:AddItem("Machine Gun","5")
  self.wlist:AddItem("Machinegun ARVE","6")
  self.wlist:AddItem("Minigun","7")
  self.wlist:AddItem("Minigun ARVE","8")
  self.wlist:AddItem("Minigun LAVE","9")
  self.wlist:AddItem("Minigun Vehicle","10")
  self.wlist:AddItem("Multi Target Rocket Launcher","11") 
  self.wlist:AddItem("Panay Rocket Launcher","12")
  self.wlist:AddItem("Revolver","13")
  self.wlist:AddItem("Rocket ARVE","14")
  self.wlist:AddItem("Rocket LAVE","15")
  self.wlist:AddItem("Rocket Launcher","16")
  self.wlist:AddItem("SAM","17")
  self.wlist:AddItem("SMG","18")
  self.wlist:AddItem("SawnOff Shotgun","19")
  self.wlist:AddItem("Sentry Gun","20") 
  self.wlist:AddItem("Shotgun","21")
  self.wlist:AddItem("Sniper","22")
  self.wlist:AddItem("V022_VHLRKT","23")
  self.wlist:AddItem("V023_VHLRKT","24")
  self.wlist:AddItem("V089_VHLRKT","25")
  self.wlist:AddItem("Vulcan","26")
end


-- Add all vehicles to vehicle list 
function SESGUI:FillVehicleList()
  -- Land Vehicles 
  self.list1:AddItem("1 Dongtai Agriboss 35", "1")
  self.list1:AddItem("2 Mancini Cavallo 1001", "2")
  self.list1:AddItem("4 Kenwall Heavy Rescue", "4")
  self.list1:AddItem("7 Poloma Renegade", "7")
  self.list1:AddItem("8 Columbi Excelsior", "8")
  self.list1:AddItem("9 Tuk-Tuk Rickshaw","9")
  self.list1:AddItem("10  Saas PP12 Hogg","10")
  self.list1:AddItem("11  Shimuzu Tracline","11")
  self.list1:AddItem("12  Vanderbildt LeisureLiner","12")
  self.list1:AddItem("13  Stinger Dunebug 84","13")
  self.list1:AddItem("15  Sakura Aquila Space","15")
  self.list1:AddItem("18  SV-1003 Raider","18")
  self.list1:AddItem("21  Hamaya Cougar 600","21")
  self.list1:AddItem("20  (DLC) Monster Truck","20")
  self.list1:AddItem("22  Tuk-Tuk Laa","22")
  self.list1:AddItem("23  Chevalier Liner SB","23")
  self.list1:AddItem("26  Chevalier Traveller SD","26")
  self.list1:AddItem("29  Sakura Aquila City","29")
  self.list1:AddItem("31  URGA-9380","31")
  self.list1:AddItem("32  Mosca 2000","32")
  self.list1:AddItem("33  Chevalier Piazza IX","33")
  self.list1:AddItem("35  Garret Traver-Z","35")
  self.list1:AddItem("36  Shimuzu Tracline","36")
  self.list1:AddItem("40  Fengding EC14FD2","40")
  self.list1:AddItem("41  Niseco Coastal D22","41")
  self.list1:AddItem("42  Niseco Tusker P246","42")
  self.list1:AddItem("43  Hamaya GSY650","43")
  self.list1:AddItem("44  Hamaya Oldman","44")
  self.list1:AddItem("46  MV V880","46")
  self.list1:AddItem("47  Schulz Virginia","47")
  self.list1:AddItem("48  Maddox FVA 45","48")
  self.list1:AddItem("49  Niseco Tusker D18","49")
  self.list1:AddItem("52  Saas PP12 Hogg","52")
  self.list1:AddItem("54  Boyd Fireflame 544","54")
  self.list1:AddItem("55  Sakura Aquila Metro ST","55")
  self.list1:AddItem("56  GV-104 Razorback","56")
  self.list1:AddItem("58  (DLC) Chevalier Classic","58")
  self.list1:AddItem("60  Vaultier Patrolman","60")
  self.list1:AddItem("61  Makoto MZ 260X","61")
  self.list1:AddItem("63  Chevalier Traveller SC","63")
  self.list1:AddItem("66  Dinggong 134D","66")
  self.list1:AddItem("68  Chevalier Traveller SX","68")
  self.list1:AddItem("70  Sakura Aguila Forte","70")
  self.list1:AddItem("71  Niseco Tusker G216","71")
  self.list1:AddItem("72  Chepachet PVD","72")
  self.list1:AddItem("73  Chevalier Express HT","73")
  self.list1:AddItem("74  Hamaya 1300 Elite Cruiser","74")
  self.list1:AddItem("75  (DLC) Tuk Tuk Boom Boom","75")
  self.list1:AddItem("76  SAAS PP30 Ox","76")
  self.list1:AddItem("77  Hedge Wildchild","77")
  self.list1:AddItem("78  Civadier 999","78")
  self.list1:AddItem("79  Pocumtuck Nomad","79")
  self.list1:AddItem("82  (DLC) Chevalier Ice Breaker","82")
  self.list1:AddItem("83  Mosca 125 Performance","83")
  self.list1:AddItem("84  Marten Storm III","84")
  self.list1:AddItem("86  Dalton N90","86")
  self.list1:AddItem("87  Wilforce Trekstar","87")
  self.list1:AddItem("89  Hamaya Y250S","89")
  self.list1:AddItem("90  Makoto MZ 250","90")
  self.list1:AddItem("91  Titus ZJ","91")

  -- Sea Vehicles 
  self.list2:AddItem("5 Pattani Gluay", "5")
  self.list2:AddItem("6 Orque Grandois 21TT", "6")
  self.list2:AddItem("16  YP-107 Phoenix", "16")
  self.list2:AddItem("19  Orque Living 42T", "19")
  self.list2:AddItem("25  Trat Tang-mo", "25")
  self.list2:AddItem("27  SnakeHead T20", "27")
  self.list2:AddItem("28  TextE Charteu 52CT", "28")
  self.list2:AddItem("38  Kuang Sunrise", "38")
  self.list2:AddItem("45  Orque Bon Ton 71FT", "45")
  self.list2:AddItem("50  Zhejiang 6903", "50")
  self.list2:AddItem("53  (DLC) Agency Hovercraft", "53")
  self.list2:AddItem("69  Winstons Amen 69", "69")
  self.list2:AddItem("80  Frisco Catshark S-38", "80")
  self.list2:AddItem("88  MTA Powerrun 77", "88")

  -- Air Vehicles 
  self.list3:AddItem("3 Rowlinson K22","3")
  self.list3:AddItem("14  Mullen Skeeter Eagle","14")
  self.list3:AddItem("24  (DLC) F-33 DragonFly Jet Fighter","24")
  self.list3:AddItem("30  Si-47 Leopard","30")
  self.list3:AddItem("34  G9 Eclipse","34")
  self.list3:AddItem("37  Sivirkin 15 Havoc","37")
  self.list3:AddItem("39  Aeroliner 474","39")
  self.list3:AddItem("51  Cassius 192","51")
  self.list3:AddItem("57  Sivirkin 15 Havoc","57")
  self.list3:AddItem("59  Peek Airhawk 225","59")
  self.list3:AddItem("62  UH-10 Chippewa","62")
  self.list3:AddItem("64  AH-33 Topachula","64")
  self.list3:AddItem("65  H-62 Quapaw","65")
  self.list3:AddItem("67  Mullen Skeeter Hawk","67")
  self.list3:AddItem("81  Pell Silverbolt 6","81")
  self.list3:AddItem("85  Bering I-86DP","85")
end

mwindow = SESGUI()
