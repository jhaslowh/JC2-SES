-- Controls chat commands 
function ChatControl(args)
  if isAdmin(args.player) == false then
    return true
  end

  -- Kill the given player if you have permission 
  if args.text:sub(0,5) == "/kill" then 
    -- Search for player in player list
    local pname = args.text:sub(7,args.text:len())
    local player = GetPlayerByName(pname)

    if player != nil then
      player:SetHealth(0)
      Chat:Broadcast("Admin has killed " .. player:GetName(), colorAdmin)
      return false
    end

    args.player:SendChatMessage("Player " .. pname .. " not found", Color(115, 170, 220))
    return false
  end

  -- Add player to admin list
  if args.text:sub(0,10) == "/makeAdmin" then
    -- Get player 
    local pname = args.text:sub(12,args.text:len())
    AddAdmin(args.player)
    Chat:Broadcast(pname .. " is now an Admin", colorAdmin)

    return false
  end

  -- Kick player 
  if args.text:sub(0,5) == "/kick" then
    -- Get player name
    local playerName = args.text:sub(7,args.text:len())
    print(playerName)
    -- Get player
    local player = GetPlayerByName(playerName)

    -- Try and kick player 
    if player != nil then
      player:Kick()
    end
    return false
  end 

  return true
end

-- Load the admin file from drive
function  LoadAdminFile()
  -- Open up the admin file 
  local filename = "admins.txt"
  print("Opening " .. filename)
  local file = io.open( filename, "r" )

  if file == nil then
      print( "No admins.txt, aborting loading of admins" )
      return
  end

  -- For each line load as admin name 
  for line in file:lines() do
    admins[adminCount] = line
    adminCount = adminCount + 1
  end

  file:close()
end

-- Check if player is an admin
function  isAdmin(player)
  for i=0, adminCount - 1 do
    if player:GetSteamId().id == admins[i] then
      return true
    end
  end
  return false
end

-- Add admin to file 
-- Will also save admin file 
function  AddAdmin(player)
  admins[adminCount] = player:GetSteamId().id
  adminCount = adminCount + 1

  -- Open up the admin file 
  local filename = "admins.txt"
  print("Opening " .. filename)
  local file = io.open( filename, "w+" )

  if file == nil then
      print( "No admins.txt, aborting loading of admins" )
      return
  end

  -- Write each name to the admin file 
  for i = 0, adminCount - 1 do
    file:write(admins[i] .. "\n")
  end

  file:close()
end

-- List of admins in server 
adminCount = 0
admins = {}

-- Load admins from file 
LoadAdminFile()

-- Add events to global events 
Events:Subscribe("PlayerChat", ChatControl)
