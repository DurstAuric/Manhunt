local Services = require(game:GetService("ServerStorage").Services);
local Core = require(Services.ServerStorage.Core)();
local PlayerStats = require("PlayerStats");

local Event = Services.ReplicatedStorage.Assets.Events.GE;
local CanStart = Services.ReplicatedStorage.Assets.Lobby.CanStart;
local Players = {};
local PFolder = Services.ServerStorage.Players;
local PFolder2 = Services.ReplicatedStorage.Players;
local CountingDown = false;
Event.OnServerEvent:Connect(function(Player, Call)
	if Call:lower() == "rdup" then
--		PFolder2:WaitForChild(Player.Name);
--		if (PFolder2[Player.Name].IsReady.Value == false and PFolder2[Player.Name].InStore.Value == false) then
--			PFolder2[Player.Name].IsReady.Value = true;
--		end;
		local Plr = PlayerStats:FindPlayer(Player);
		print(Plr.IsReady)
		if Plr.IsReady == false and Plr.InStore == false then
			Plr.IsReady = true;
		end
		Players[Player] = {
			IsReady = Plr.IsReady;
		};
		if Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value == false then
			local RunningTotal = 0;
			for Plr,_ in pairs(Players) do
				if Players[Plr].IsReady == true then
					RunningTotal = RunningTotal + 1;
				end;
			end;
			if RunningTotal < 2 then
				Event:FireAllClients("nep");
				CanStart.Value=false;
				for Plr,_ in pairs(Players) do
					if Players[Plr].IsReady == true then
						Event:FireClient(Plr, "hcl");
					end;
				end;
			elseif RunningTotal >= 2 then
				Event:FireAllClients("ep");
				CanStart.Value = true;
				for Plr,_ in pairs(Players) do
					if Players[Plr].IsReady == true then
						Event:FireClient(Plr, "scl");
					end;
				end;
				spawn(function()
					CountingDown = true;
					while CountingDown == true do
						wait(1);
						Services.ReplicatedStorage.Assets.Lobby.LobbyTimer.Value = Services.ReplicatedStorage.Assets.Lobby.LobbyTimer.Value - 1;
						if Services.ReplicatedStorage.Assets.Lobby.LobbyTimer.Value == 0 then
							CountingDown = false;
							Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value = true;
							Services.ReplicatedStorage.Assets.Lobby.Hiding.Value = true;
							Services.ReplicatedStorage.Assets.Lobby.LobbyTimer.Value = 5; -- finished xdddd
							-- time to start the round?? :DDD
						end;
					end;
				end);
			end;
		elseif Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value == true then
			if Services.ReplicatedStorage.Assets.Lobby.Hiding.Value == true then
				local Map = Services.ReplicatedStorage.Misc.CurrentMap.Value;
				Event:FireClient(Player, "rbb");
				wait(3);
				if Player.Backpack:FindFirstChild("IsReady").Value == true then
					Event:FireClient(Player, "apli", {Map.MapLighting});
					local XPos, ZPos = math.random(1, Map.SpawnBoundaries.Size.X/2), math.random(1, Map.SpawnBoundaries.Size.Z/2);
					Player.Character.HumanoidRootPart.CFrame = Map.SpawnBoundaries.CFrame * CFrame.new(XPos, 0, ZPos)
					Player.Character.Humanoid.WalkSpeed = 20;
				end;
				wait(2);
				Event:FireClient(Player, "lbb");
			elseif Services.ReplicatedStorage.Assets.Lobby.Hiding.Value == false then
				local Map = Services.ReplicatedStorage.Misc.CurrentMap.Value;
				Event:FireClient(Player, "rbb");
				wait(3);
				if Player.Backpack:FindFirstChild("IsReady").Value == true then
					Event:FireClient(Player, "apli", {Map.MapLighting});
					local XPos, ZPos = math.random(1, Map.SpawnBoundaries.Size.X/2), math.random(1, Map.SpawnBoundaries.Size.Z/2);
					Player.Character.HumanoidRootPart.CFrame = Map.SpawnBoundaries.CFrame * CFrame.new(XPos, 0, ZPos)
					Player.Character.Humanoid.WalkSpeed = 16;
				end;
				wait(2);
				Event:FireClient(Player, "lbb");
			end;
		end;
	elseif Call:lower() == "nrd" then
		if CountingDown == true then
			CountingDown = false;
			Services.ReplicatedStorage.Assets.Lobby.LobbyTimer.Value = 5;
		end;
	elseif Call:lower() == "mprd" then
		if PFolder2[Player.Name].IsReady.Value == true then
			PFolder2[Player.Name].IsReady.Value = false;
			PFolder2[Player.Name].InStore.Value = true;
		end;
	end;
end);
