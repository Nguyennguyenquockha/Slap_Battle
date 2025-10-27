local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

_G.AutoFarmCandy = _G.AutoFarmCandy or true
_G.AutoGhost = _G.AutoGhost or false
_G.Autoexec = _G.Autoexec or true

task.spawn(function()
	while _G.AutoFarmCandy do
		local candies = workspace:FindFirstChild("CandyCorns")
		if candies and #candies:GetChildren() > 0 then
			for _, candy in pairs(candies:GetChildren()) do
				if candy:IsA("BasePart") or candy:FindFirstChild("TouchInterest") then
					candy.CFrame = hrp.CFrame + Vector3.new(0, 1, 0)
				end
			end
		else
			print("[Kha Hub] Không còn Candy, đang chuyển server mới...")
			local HttpService = game:GetService("HttpService")
			local TPService = game:GetService("TeleportService")
			local servers = {}
			local success, data = pcall(function()
				return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
			end)
			if success and data then
				local decoded = HttpService:JSONDecode(data)
				for _, v in pairs(decoded.data) do
					if v.playing < v.maxPlayers then
						table.insert(servers, v.id)
					end
				end
				if #servers > 0 then
					TPService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
				end
			end
		end
		task.wait(0.2)
	end
end)

task.spawn(function()
	while _G.AutoGhost do
		task.wait(3)
		local plr = game.Players.LocalPlayer
		if plr.Character and not plr.Character:FindFirstChild("entered") and plr:FindFirstChild("leaderstats") then
			if plr.leaderstats:FindFirstChild("Slaps") and plr.leaderstats.Slaps.Value >= 666 then
				local glove = plr.leaderstats.Glove.Value
				if workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("Ghost") then
					fireclickdetector(workspace.Lobby.Ghost.ClickDetector)
					game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
					if workspace.Lobby:FindFirstChild(glove) then
						fireclickdetector(workspace.Lobby[glove].ClickDetector)
					end
					task.wait(1)
					for _,v in pairs(plr.Character:GetChildren()) do
						if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
							v.Transparency = 0
						end
					end
				end
			end
		end
	end
end)

if _G.Autoexec then
	game.Loaded:Connect(function()
		task.wait(5)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/REPO/main/AutoCandy.lua"))()
	end)
end
