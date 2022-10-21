--[[
Credits:
CrownKingPown
--]]

-- I just wrote all of this, this can be ran in only one script, and without having to add parts in workspace manually for the script to work
local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(
	.8, -- Time
	Enum.EasingStyle.Bounce, -- Easing Style
	Enum.EasingDirection.Out, -- Easing Direction
	0, -- Repeat Count
	false, -- If it reverses
	0 -- Delay before it continues
)

function lerp(a, b, t)
	return a + (b - a) * t
end

function quadraticBezier(t, p0, p1, p2)
	local l1 = lerp(p0, p1, t)
	local l2 = lerp(p1, p2, t)
	local quad = lerp(l1, l2, t)
	return quad
end

local DoorMake = Instance.new("Part")
DoorMake.Parent = workspace
-- these coords can be changed, they are only there to prevent the door from being stuck with the other objects
DoorMake.Position += Vector3.new(30, 4.5, 10)
DoorMake.Size = Vector3.new(6, 9, 1)
DoorMake.Color = Color3.fromRGB(105, 64, 40)
DoorMake.Orientation = Vector3.new(0, 90, 0)
DoorMake.Anchored = true

local RotatingPart = Instance.new("Part")
RotatingPart.Parent = workspace
RotatingPart.Position += Vector3.new(5, 7, 30)
RotatingPart.Size = Vector3.new(1, 6, 1)
RotatingPart.Anchored = true

local Start = Instance.new("Part")
Start.Parent = workspace
Start.Position += Vector3.new(0, 0, 15)
Start.Anchored = true
Start.CanCollide = false
-- Makes the part transparent
Start.Transparency = 1

local function MakeCurvedPlatform()
	-- This will make the generation random
	local seed = math.random(100, 10000000)
	for x = -30, 30 do
		-- This will prevent lag and crashes
		task.wait()
		for z = -30, 30 do
		    -- This will prevent lag and crashes
			task.wait()
			local noise = (math.noise(seed, x / 10, z / 10) * 10) + --[[Makes sure the height is above the Baseplate ->]]6
			local part = Instance.new("Part")
			part.Anchored = true
			part.Size = Vector3.new(1,1,1)
			-- This is required for the generated parts to be positioned according to the noise curve
			part.Position = Vector3.new(60 + x, noise, 60 + z)
			part.Parent = workspace
		end
	end
end

local function DoorFunc()
	-- 0 == Closed, 1 == Open
	local DoorMode = 0
	local tweenDoorOpenCreate = TweenService:Create(DoorMake, tweenInfo, {Position = Vector3.new(30, 4.5, 10 + 5), Orientation = Vector3.new(0, 0, 0)})
	local tweenDoorCloseCreate = TweenService:Create(DoorMake, tweenInfo, {Position = Vector3.new(30, 4.5, 10), Orientation = Vector3.new(0, 90, 0)})
	while true do
		for index, plr in pairs(Players:GetPlayers()) do
			-- Makes sure there won't be any errors
			if plr.Character ~= nil and plr.Character:IsDescendantOf(workspace) and plr.Character:FindFirstChild("HumanoidRootPart") then
				local humRoot = plr.Character:WaitForChild("HumanoidRootPart")
				-- Checks if the distance between the player's humanoidrootpart and the door is less or equal to 15
				if (DoorMake.Position - humRoot.Position).Magnitude <= 10 then
					-- If the door is closed, then the code below will open it
					if DoorMode == 0 then
						tweenDoorOpenCreate:Play()
						-- Toggles to Open
						DoorMode = 1
					end
					-- Prevents the loop from going further in the players table
					break
				-- If the player is too far away from the door
				else
					-- If the door is open, then the code below will close it
					if DoorMode == 1 then
						-- Toggles to Closed
						DoorMode = 0
						tweenDoorCloseCreate:Play()
					end
				end
			end
		end
		-- Delay for the near player check
		task.wait(.2)
	end
end

local function RotatePartLoop()
	while true do
		task.wait()
		-- This will create the "Part"
		RotatingPart.CFrame = RotatingPart.CFrame * CFrame.Angles(math.rad(math.random(1, 5)), 0, math.rad(math.random(1, 5)))
	end
end

local function GenerateStairs()
	for StairsLength = 1, 20 do
		task.wait()
		for x = 1, 5 do
			for z = 1, 3 do
				for y = 1, 5 do
					-- This will create the "Part"
					local MakePart = Instance.new("Part")
					MakePart.Anchored = true
					MakePart.CanCollide = true
					-- Changes the Part's parent to workspace
					MakePart.Parent = workspace
					MakePart.Name = x .. y
					MakePart.Position = Start.Position + Vector3.new(--[[X]]StairsLength + x, --[[Y]]StairsLength / 2, --[[Z]]z)
					if workspace:FindFirstChild(tostring(x - 1 .. y - 1)) then
						workspace:FindFirstChild(tostring(x - 1 .. y - 1)).CFrame = CFrame.lookAt(MakePart.Position, workspace:FindFirstChild(tostring(x - 1 .. y - 1)).Position)
					end
				end
			end
		end
	end
end

local function MakeSpawn()
	-- This will create the "Part"
	local makeSpawn = Instance.new("Part")
	-- This will change the SpawnLocation's parent to workspace
	makeSpawn.Parent = workspace
	-- This will change the name of the part to SpawnLocation
	makeSpawn.Name = "SpawnLocation"
	return makeSpawn
end

local function StartCurveLoop()
	-- This is the "Part" that the script is going to move
	local SpawnLocation = workspace:FindFirstChild("SpawnLocation")
	-- If the part doesn't exist
	if SpawnLocation == nil then
		-- This function will make the part
		SpawnLocation = MakeSpawn()
	end
	-- Makes sure the Part doesn't rotate and fall at all
	SpawnLocation.Anchored = true
	local BezierLength = 100
	
	-- the "0, 0, 0" is not required for it to change the CFrame to "0, 0, 0"
	SpawnLocation.CFrame = CFrame.new()

	local StartPos = SpawnLocation.Position
	local EndPos = StartPos + Vector3.new(--[[X]]5)
	local TopPos = EndPos + Vector3.new(--[[X]]0, --[[Y]]15, --[[Z]]0)
	for indexLoop = 0, BezierLength do
		task.wait()
		-- Get the current bézier curve point's position
		SpawnLocation.Position = quadraticBezier(indexLoop / BezierLength, StartPos, TopPos, EndPos)
	end
	
	-- 2 seconds delay before restarting the loop
	task.wait(1)
	-- Continue the loop
	StartCurveLoop()
end

coroutine.wrap(function()
	-- Start the Stair Generator
	GenerateStairs()
end)()

coroutine.wrap(function()
	-- Start the loop
	StartCurveLoop()
end)()

coroutine.wrap(function()
	-- Start the part rotation loop
	RotatePartLoop()
end)()

coroutine.wrap(function()
	-- Start the door opening/closing when a player is close
	DoorFunc()
end)()

coroutine.wrap(function()
	-- Generates the noise curve parts
	MakeCurvedPlatform()
end)()

-- Changes the parts' color to a random BrickColor

local ListOfColorChangedParts = {}

local function ChangePartColorToRandom(Part)
	-- If the part isn't in the list yet
	if ListOfColorChangedParts[Part] == nil then
		-- Generate a random BrickColor
		Part.BrickColor = BrickColor.Random()
		-- Add part to the list to prevent further color changes
		ListOfColorChangedParts[Part] = true
	end
end

-- Loops through workspace
for index, PartGot in pairs(workspace:GetChildren()) do
	-- If it's a part
	if PartGot:IsA("BasePart") then
		ChangePartColorToRandom(PartGot)
	end
end

-- When a new object is added
workspace.ChildAdded:Connect(function(PartGot)
	-- If it's a part
	if PartGot:IsA("BasePart") then
		ChangePartColorToRandom(PartGot)
	end
end)
