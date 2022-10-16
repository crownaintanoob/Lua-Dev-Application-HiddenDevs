--[[
Credits:
CrownKingPown
--]]

-- [Code 1 (I wrote this for an example just now)]

function lerp(a, b, t)
	return a + (b - a) * t
end

function quadraticBezier(t, p0, p1, p2)
	local l1 = lerp(p0, p1, t)
	local l2 = lerp(p1, p2, t)
	local quad = lerp(l1, l2, t)
	return quad
end


local function MakeSpawn()
	local makeSpawn = Instance.new("Part") -- This will create the "Part"
	makeSpawn.Parent = workspace -- This will change the SpawnLocation's parent to workspace
	makeSpawn.Name = "SpawnLocation" -- This will change the name of the part to SpawnLocation
	return makeSpawn
end

local function StartCurveLoop()
	local SpawnLocation = workspace:FindFirstChild("SpawnLocation") -- This is the "Part" that the script is going to move
	if SpawnLocation == nil then -- If the part doesn't exist
		SpawnLocation = MakeSpawn() -- This function will make the part
	end
	SpawnLocation.Anchored = true -- Makes sure the Part doesn't rotate and fall at all
	local BezierLength = 100

	SpawnLocation.CFrame = CFrame.new() -- the "0, 0, 0" is not required for it to change the CFrame to "0, 0, 0"

	local StartPos = SpawnLocation.Position
	local EndPos = StartPos + Vector3.new(--[[X]]5)
	local TopPos = EndPos + Vector3.new(--[[X]]0, --[[Y]]15, --[[Z]]0)
	for indexLoop = 0, BezierLength do
		task.wait()
		SpawnLocation.Position = quadraticBezier(indexLoop / BezierLength, StartPos, TopPos, EndPos) -- Get the current bézier curve point's position
	end
	
	task.wait(1) -- 2 seconds delay before restarting the loop
	StartCurveLoop() -- Continue the loop
end

StartCurveLoop() -- Start the loop

-- [Code 2 (Matchmaking module written by me a while ago)]

local crownMatchmaking = {}

-- // Variables \\ --
local MemoryStoreService = game:GetService("MemoryStoreService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local queueMap = MemoryStoreService:GetSortedMap("queueMapData")
local serversDataMap = MemoryStoreService:GetSortedMap("serversData")
local dayInSeconds = 86400
local MaxPlayers = 3
local QueuesLocalList = {}
-- // Variables -> End \\ --



-- // Functions \\ --
-- Adds player to queue
function crownMatchmaking:AddPlayerToQueue(plr)
	local TriesGet = 0
	local isSuccessGet = false
	local queueListGot = {}
	repeat
		local successGet, listOfQueues = pcall(function()
			return queueMap:GetRangeAsync(Enum.SortDirection.Ascending, 30) -- Returns a list of the 25 newest queues available
		end)
		if successGet == true then
			isSuccessGet = true
			queueListGot = listOfQueues
		else -- if successGet == false
			wait(1)
			TriesGet += 1
		end
	until isSuccessGet == true or TriesGet >= 10
	if #queueListGot <= 0 then -- If no queue was found
		local randomNum = math.random(100, 1000000)
		QueuesLocalList[plr] = tostring(plr.UserId) .. "-" .. tostring(randomNum)
		queueMap:SetAsync(QueuesLocalList[plr], {["Players"] = {plr.UserId}, ["currentStatus"] = "Waiting", ["reservedServerId"] = ""}, dayInSeconds)
		coroutine.wrap(function()
			while true do
				wait(math.random(2, 3))
				if plr == nil then -- If player left
					break
				end
				local getSuccess, getData = pcall(function()
					return queueMap:GetAsync(QueuesLocalList[plr])
				end)
				if getSuccess == true then
					if getData ~= nil then
						if table.find(getData["Players"], plr.UserId) == true or QueuesLocalList[plr] ~= nil then
							if getData["currentStatus"] == "Joining" and getData["reservedServerId"] ~= "" then
								TeleportService:TeleportToPrivateServer(--[[Removed the id]]0, getData["reservedServerId"], {plr})
								break
							end
						else
							print("Player was removed somehow!")
							break
						end
					end
				end
			end
		end)()
	else -- If a queue was found
		local HasQueueBeenFound = false
		for index, QueueData in pairs(queueListGot) do
			local TableValue = QueueData.value -- Table
			local KeyData = QueueData.key -- String
			if KeyData == nil then -- If broken queue
				queueMap:RemoveAsync(KeyData)
				local randomNum = math.random(100, 1000000)
				QueuesLocalList[plr] = tostring(plr.UserId) .. "-" .. tostring(randomNum)
				queueMap:SetAsync(QueuesLocalList[plr], {["Players"] = {plr.UserId}, ["currentStatus"] = "Waiting", ["reservedServerId"] = ""}, dayInSeconds)
				coroutine.wrap(function()
					while true do
						wait(math.random(2, 3))
						if plr == nil then -- If player left
							break
						end
						local getSuccess, getData = pcall(function()
							return queueMap:GetAsync(QueuesLocalList[plr])
						end)
						if getSuccess == true then
							if getData ~= nil then
								if table.find(getData["Players"], plr.UserId) == true or QueuesLocalList[plr] ~= nil then
									if getData["currentStatus"] == "Joining" and getData["reservedServerId"] ~= "" then
										TeleportService:TeleportToPrivateServer(--[[Removed the id]]0, getData["reservedServerId"], {plr})
										break
									end
								else
									print("Player was removed somehow!")
									break
								end
							end
						end
					end
				end)()
			else
				if TableValue["Players"] == nil then -- If broken queue
					queueMap:RemoveAsync(KeyData)
					local randomNum = math.random(100, 1000000)
					QueuesLocalList[plr] = tostring(plr.UserId) .. "-" .. tostring(randomNum)
					queueMap:SetAsync(QueuesLocalList[plr], {["Players"] = {plr.UserId}, ["currentStatus"] = "Waiting", ["reservedServerId"] = ""}, dayInSeconds)
					coroutine.wrap(function()
						while true do
							wait(math.random(2, 3))
							if plr == nil then -- If player left
								break
							end
							local getSuccess, getData = pcall(function()
								return queueMap:GetAsync(QueuesLocalList[plr])
							end)
							if getSuccess == true then
								if getData ~= nil then
									if table.find(getData["Players"], plr.UserId) == true or QueuesLocalList[plr] ~= nil then
										if getData["currentStatus"] == "Joining" and getData["reservedServerId"] ~= "" then
											TeleportService:TeleportToPrivateServer(--[[Removed the id]]0, getData["reservedServerId"], {plr})
											break
										end
									else
										print("Player was removed somehow!")
										break
									end
								end
							end
						end
					end)()
				else -- If queue isn't broken
					if #TableValue["Players"] < MaxPlayers then
						QueuesLocalList[plr] = KeyData
						local NewTableData = queueMap:UpdateAsync(KeyData, function(queueTable) -- Add Player & Change Status
							queueTable = queueTable or {} -- Default Table
							if queueTable["Players"] then
								table.insert(queueTable["Players"], plr.UserId)
								if queueTable["Players"] then
									if queueTable["currentStatus"] == "Waiting" then
										if #queueTable["Players"] >= MaxPlayers then
											queueTable["currentStatus"] = "Joining"
											return queueTable
										end
									end
								end
							end
							return queueTable
						end, dayInSeconds) -- Expiration Time
						if NewTableData["currentStatus"] == "Joining" then -- If status was changed by selected player
							local dataGot = queueMap:GetAsync(QueuesLocalList[plr])
							if dataGot["currentStatus"] == "Joining" then
								local ServerCode, privateServerId = TeleportService:ReserveServer(--[[Removed the id]])
								serversDataMap:SetAsync(privateServerId, QueuesLocalList[plr], dayInSeconds)
								local tableDataNew = queueMap:UpdateAsync(QueuesLocalList[plr], function(queueTable)
									queueTable = queueTable or {} -- Default Table
									if queueTable["Players"] then
										if queueTable["currentStatus"] == "Joining" then
											queueTable["reservedServerId"] = ServerCode
										end
									end
									return queueTable
								end, dayInSeconds) -- Expiration Time
								if tableDataNew["reservedServerId"] ~= "" then -- if a server has been reserved
									TeleportService:TeleportToPrivateServer(--[[Removed the id]]0, tableDataNew["reservedServerId"], {plr})
								end
							end
						else
							coroutine.wrap(function()
								while true do
									wait(math.random(2, 3))
									if plr == nil then -- If player left
										break
									end
									local getSuccess, getData = pcall(function()
										return queueMap:GetAsync(QueuesLocalList[plr])
									end)
									if getSuccess == true then
										if getData ~= nil then
											if table.find(getData["Players"], plr.UserId) == true or QueuesLocalList[plr] ~= nil then
												if getData["currentStatus"] == "Joining" and getData["reservedServerId"] ~= "" then
													TeleportService:TeleportToPrivateServer(--[[Removed the id]]0, getData["reservedServerId"], {plr})
													break
												end
											else
												print("Player was removed somehow!")
												break
											end
										end
									end
								end
							end)()
						end
						HasQueueBeenFound = true
						break -- Stops looping through the queues, because an available queue was found
					end
				end
				if HasQueueBeenFound == false then -- If all servers were full
					local randomNum = math.random(100, 1000000)
					QueuesLocalList[plr] = tostring(plr.UserId) .. "-" .. tostring(randomNum)
					queueMap:SetAsync(QueuesLocalList[plr], {["Players"] = {plr.UserId}, ["currentStatus"] = "Waiting", ["reservedServerId"] = ""}, dayInSeconds)
					coroutine.wrap(function()
						while true do
							wait(math.random(2, 3))
							if plr == nil then -- If player left
								break
							end
							local getSuccess, getData = pcall(function()
								return queueMap:GetAsync(QueuesLocalList[plr])
							end)
							if getSuccess == true then
								if getData ~= nil then
									if table.find(getData["Players"], plr.UserId) == true or QueuesLocalList[plr] ~= nil then
										if getData["currentStatus"] == "Joining" and getData["reservedServerId"] ~= "" then
											TeleportService:TeleportToPrivateServer(--[[Removed the id]]0, getData["reservedServerId"], {plr})
											break
										end
									else
										print("Player was removed somehow!")
										break
									end
								end
							end
						end
					end)()
				end
			end
		end
	end
end

-- Removes player from queue
function crownMatchmaking:RemovePlayerFromQueue(plr)
	if QueuesLocalList[plr] ~= nil then
		pcall(function()
			queueMap:UpdateAsync(QueuesLocalList[plr], function(queueTable)
				queueTable = queueTable or nil -- Default Table
				if queueTable ~= nil then
					if queueTable["Players"] ~= nil then
						if queueTable["currentStatus"] ~= "Joining" then
							table.remove(queueTable["Players"], table.find(queueTable["Players"], plr.UserId))
						end
						return queueTable
					else
						return {["Players"] = {}, ["currentStatus"] = "Waiting", ["reservedServerId"] = ""}
					end
				else -- If nil
					return {["Players"] = {}, ["currentStatus"] = "Waiting", ["reservedServerId"] = ""}
				end
			end, dayInSeconds)
		end)
		table.remove(QueuesLocalList, table.find(QueuesLocalList, plr))
	end
end
-- // Functions -> End \\ --

game:BindToClose(function()
	wait(3)
end)


return crownMatchmaking
