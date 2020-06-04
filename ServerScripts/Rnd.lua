local Services = require(game:GetService("ServerScriptService").Scripts.Modules.Resources);
local Maps = Services.ServerStorage.Assets.Maps:GetChildren();
local Event = Services.ReplicatedStorage.Assets.Events.GE;
local RoundActive = Services.ReplicatedStorage.Assets.Lobby.RoundActive;
local GameEnded = Services.ReplicatedStorage.Assets.Lobby.GameEnded;
local RoundProgressed = Services.ReplicatedStorage.Assets.Lobby.RoundProgressed;
local CanStart = Services.ReplicatedStorage.Assets.Lobby.CanStart;
local CountingDown = false;
local Counter = false;
local ODS = Services.DataStoreService:GetOrderedDataStore("Leaderboard");
local Players = {};
local Round = {};
local TotalTaggers = Services.ServerStorage.Assets.Misc.TotalTaggers;
local GameModes = {"Classic"}
local EndGui = script.EndGui;
local function Sort(Tab)
	local Num = 1;
	local Temp = {};
	for i,v in pairs(Tab) do
		table.insert(Temp,{["val"] = v, ["plr"] = i});
		Num = Num + 1;
	end;
	Tab = Temp;
	local Sorted = true;
	local n = 0;
	while Sorted do
		Sorted = false;
		local prev;
		for i = 1, #Tab-n do
			if Tab[i+1] and Tab[i]["val"] < Tab[i + 1]["val"] then
				Sorted = true;
				Temp = Tab[i];
				Tab[i] = Tab[i + 1];
				Tab[i + 1] = Temp;
			end;
		end;
		n = n + 1;
	end;
	return Tab;
end;
function Round:Start()
	local RunningTotal = 0;
	for Plr,_ in pairs(Players) do
		if Players[Plr].IsReady == true then
			RunningTotal = RunningTotal + 1;
		end;
	end;
	if RunningTotal < 2 then
		Event:FireAllClients("nep");
		CanStart.Value = false;
		Round:Start(); -- repeats?
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
					Services.ReplicatedStorage.Assets.Lobby.LobbyTimer.Value = 5;
				end;
			end;
		end);
	end;
end
function Round:ChooseMap()
	math.randomseed(tick()*math.random());
	local Map = Maps[math.random(1,#Maps)]:Clone();
	Services.ReplicatedStorage.Assets.Misc.CurrentMap.Value = Map;
	return Map;
end;
function Round:ChooseGameMode()
	math.randomseed(tick()*math.random());
	return GameModes[math.random(#GameModes)];
end;
function Round:SetLeaderboard()
    local Tags = {};
    for Plr,_ in pairs(Players) do
    	Tags[Plr] = Services.ServerStorage.Players[Plr.Name]:FindFirstChild("UserStats").RoundStats.Tags.Value;
		Services.ServerStorage.Players[Plr.Name]:FindFirstChild("UserStats").RoundStats.Tags.Value = 0;
    end;
	local NGui = EndGui:Clone();
	for i,v in pairs(Sort(Tags)) do
		local Player = v["plr"];
		local PTags = v["val"];
		local PTemplate = NGui.Frame.Plr:Clone();
		PTemplate.PlayerName.Text = Player.Name;
		PTemplate.Tags.Text = "Tags: " .. PTags;
		PTemplate.LayoutOrder = i;
		PTemplate.Visible = true;
		PTemplate.Parent = NGui.Frame.Leaderboard;
	end;
	for Plr,_ in pairs(Tags) do
		if Players[Plr].IsReady == true then
        	local PNGui = NGui:Clone();
			local PReward = (25 * Tags[Plr]);
			PNGui.Frame.Rewards.TextLabel.Text = "Reward: " .. tostring(PReward) .. " Gold Coins!";
			Services.ServerStorage.Players[Plr.Name]["Gold Coins"].Value = Services.ServerStorage.Players[Plr.Name]["Gold Coins"].Value + PReward;
			PNGui.Parent = Plr.PlayerGui;
		end;
	end;
end;
function Round:PlrLeft(Clean, Call)
	if Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value == true then
		Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value = false;
		if Counter == true then
			Counter = false;
		end;
		if Call:lower() == "tgl" then
			for Plr,_ in pairs(Players) do
				if Players[Plr].IsReady == true then
					if Plr.Character then
						Plr.Character.Humanoid.WalkSpeed = 16;
						print("uhh");
						Event:FireClient(Plr, "ctx", {"ALL TAGGERS LEFT! GAME ENDING!"});
						for _,Tool in pairs(Plr.Backpack:GetChildren()) do
						if Tool:IsA("Tool") then
							Tool:Destroy();
							end;
						end;
						for _,Tool in pairs(Plr.Character:GetChildren()) do
							if Tool:IsA("Tool") then
								Tool:Destroy();
							end;
						end;
						Plr.Team = nil;
					end;
				end;
			end;
		elseif Call:lower() == "nep" then
			for Plr,_ in pairs(Players) do
				if Players[Plr].IsReady == true then
					if Plr.Character then
						Plr.Character.Humanoid.WalkSpeed = 16;
						print("uhhm");
						Event:FireClient(Plr, "ctx", {"NOT ENOUGH PLAYERS! GAME ENDING!"});
						for _,Tool in pairs(Plr.Backpack:GetChildren()) do
						if Tool:IsA("Tool") then
							Tool:Destroy();
							end;
						end;
						for _,Tool in pairs(Plr.Character:GetChildren()) do
							if Tool:IsA("Tool") then
								Tool:Destroy();
							end;
						end;
						Plr.Team = nil;
					end;
				end;
			end;
		end;
		local Cabin = Services.ServerStorage.Assets.Lobby.EndCabin:Clone();
		Cabin.Parent = game.Workspace;
		Cabin.MVP.HumanoidRootPart.CFrame = Cabin.Seat.Seat.CFrame * CFrame.new(0,0,0);
		Cabin.Seat.Seat:Sit(Cabin.MVP.Humanoid);
		wait(5);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "rbb");
				end;
			end;
		end;
		wait(3);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "ctx", {""})
					GameEnded.Value = true;
					Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value = false;
					Plr.Character.HumanoidRootPart.CFrame = game.Workspace.Spawns:GetChildren()[math.random(#game.Workspace.Spawns:GetChildren())].CFrame * CFrame.new(0, 3, 0);
					Event:FireClient(Plr,"rnen",{Players[Plr],Cabin.CamPart});
					Event:FireClient(Plr, "apli", {Cabin.MapLighting});
				end;
			end;
		end;
		Round:SetLeaderboard();
		wait(2);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "nrbb");
				end;
			end;
		end;
		Clean[1]:Destroy();
		Clean[2]:Destroy();
		wait(15);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "rbb");
				end;
			end;
		end;
		wait(3);
		for Plr,_ in pairs(Players) do
			if Plr.Character then
				if Plr.PlayerGui:FindFirstChild("EndGui") then
					Event:FireClient(Plr, "fnsh", {Players[Plr], Plr}); 
					Event:FireClient(Plr, "apli", {Services.ReplicatedStorage.Assets.Lobby.LobbyLighting});
					Plr.PlayerGui.EndGui:Destroy();
				end;
			end;
		end;
		GameEnded.Value = false;
		wait(2);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "nrbb");
				end;
			end;
		end;
		if CanStart.Value == true then
			Round:Start();
		end;
	end;
end;
function Round:End(Clean)
	if Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value == true then
		Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value = false;
		Counter = false;
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Plr.Character.Humanoid.WalkSpeed = 16;
					if CanStart.Value == false then
					else
						Event:FireClient(Plr, "ctx", {"EVERYONE WAS TAGGED! ROUND ENDING!"})
					end;
					for _,Tool in pairs(Plr.Backpack:GetChildren()) do
						if Tool:IsA("Tool") then
							Tool:Destroy();
						end;
					end;
					for _,Tool in pairs(Plr.Character:GetChildren()) do
						if Tool:IsA("Tool") then
							Tool:Destroy();
						end;
					end;
					Plr.Team = nil;
				end;
			end;
		end;
		local Cabin = Services.ServerStorage.Assets.Lobby.EndCabin:Clone();
		Cabin.Parent = game.Workspace;
		Cabin.MVP.HumanoidRootPart.CFrame = Cabin.Seat.Seat.CFrame * CFrame.new(0,0,0);
		Cabin.Seat.Seat:Sit(Cabin.MVP.Humanoid);
		wait(5);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "rbb");
				end;
			end;
		end;
		wait(3);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "ctx", {""})
					GameEnded.Value = true;
					Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value = false;
					Plr.Character.HumanoidRootPart.CFrame = game.Workspace.Spawns:GetChildren()[math.random(#game.Workspace.Spawns:GetChildren())].CFrame * CFrame.new(0, 3, 0);
					Event:FireClient(Plr,"rnen",{Players[Plr],Cabin.CamPart});
					Event:FireClient(Plr, "apli", {Cabin.MapLighting});
				end;
			end;
		end;
		Round:SetLeaderboard();
		wait(2);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "nrbb");
				end;
			end;
		end;
		Clean[1]:Destroy();
		Clean[2]:Destroy();
		wait(15);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "rbb");
				end;
			end;
		end;
		wait(3);
		for Plr,_ in pairs(Players) do
			if Plr.Character then
				if Plr.PlayerGui:FindFirstChild("EndGui") then
					Event:FireClient(Plr, "fnsh", {Players[Plr], Plr}); 
					Event:FireClient(Plr, "apli", {Services.ReplicatedStorage.Assets.Lobby.LobbyLighting});
					Plr.PlayerGui.EndGui:Destroy();
				end;
			end;
		end;
		GameEnded.Value = false;
		wait(2);
		for Plr,_ in pairs(Players) do
			if Players[Plr].IsReady == true then
				if Plr.Character then
					Event:FireClient(Plr, "nrbb");
				end;
			end;
		end;
	end;
	if CanStart.Value == true then
		Round:Start();
	end;
end;
function Round:CheckReady()
	local Plrs = {};
	for Player,_ in pairs(Players) do
		if Players[Player].IsReady == true then
			table.insert(Plrs, Player);
		end;
	end;
	return Plrs;
end;
function Round:CheckTaggers()
	local Plrs = {};
	local Playing = Round:CheckReady();
	local End = false;
	local N = 0;
	for Player,_ in pairs(Players) do
		if Players[Player].IsTagger == true then
			N = N + 1;
			table.insert(Plrs, Player);
			TotalTaggers.Value = TotalTaggers.Value + N
		end;
	end;
	if #Plrs == #Playing then
		End = true;
	end;
	return End;
end;
function Round:PlayerTagged(Player)
	Players[Player].IsTagger = true;
	if Round:CheckTaggers() == false then
		-- Clone their selected weapon.
	elseif Round:CheckTaggers() == true then
		Round:End({Services.ReplicatedStorage.Assets.Misc.CurrentMap.Value,game.Workspace:FindFirstChild("TaggerCabin")});
	end;
end;
Services.ReplicatedStorage.Assets.Lobby.RoundActive.Changed:Connect(function()
	if Services.ReplicatedStorage.Assets.Lobby.RoundActive.Value == true then
		if Services.ReplicatedStorage.Assets.Lobby.CanStart.Value == true then
			local GameMode = Round:ChooseGameMode();
			if GameMode:lower() == "classic" then
				Counter = true;
				local Map = Round:ChooseMap();
				local Cabin = Services.ServerStorage.Assets.Lobby.TaggerCabin:Clone();
				Map.Parent = game.Workspace;
				Cabin.Parent = game.Workspace;
				Event:FireAllClients("hcl");
				for _,Player in pairs(Services.Players:GetPlayers()) do
					if Player.Character then
						if Player.Backpack:FindFirstChild("IsReady").Value == true then
							Event:FireClient(Player, "rbb");
							Players[Player] = {
								IsReady = true;
								IsTagger = false;
							};
						end;
					end;
				end;
				wait(3);
				local Plrs = {}
				for Plr,_ in pairs(Players) do
					if Plr.Character then
						Event:FireClient(Plr, "apli", {Map.MapLighting});
						table.insert(Plrs, Plr);
					end;
				end;
				local Tagger = Plrs[math.random(#Plrs)];
				if Tagger.Character then 
					Players[Tagger].IsTagger = true;
					Tagger.TeamColor = Services.Teams.Tagger.TeamColor;
					Tagger.Character.HumanoidRootPart.CFrame = Cabin.Spawner.CFrame;
				end;
				TotalTaggers.Value = 1;
				if Tagger.Character then
					Services.ServerStorage.Players[Tagger.Name].Health.Value = 0;
					Event:FireClient(Tagger, "apli", {Cabin.MapLighting});
					Event:FireClient(Tagger, "ctx", {"THE PLAYERS ARE HIDING!"});
				end
				for Plr,_ in pairs(Players) do
					if Players[Plr].IsTagger == false then
						if Plr.Character then
							Plr.TeamColor = Services.Teams.Hider.TeamColor;
							local XPos, ZPos = math.random(1, Map.SpawnBoundaries.Size.X/2), math.random(1, Map.SpawnBoundaries.Size.Z/2);
							Plr.Character.HumanoidRootPart.CFrame = Map.SpawnBoundaries.CFrame * CFrame.new(XPos, 0, ZPos)
							Plr.Character.Humanoid.WalkSpeed = 20;
							Event:FireClient(Plr, "ctx", {"HIDE! THE TAGGER IS COMING!"});
							local PlrHealth = Services.ServerStorage.Players[Plr.Name].Health
							PlrHealth.Changed:Connect(function()
								if PlrHealth.Value <= 0 then
									Round:PlayerTagged(Plr);
								end;
							end);
						end;
					end;
				end;
				wait(2);
				Event:FireAllClients("lbb");
				wait(5);
				for Plr,_ in pairs(Players) do
					if Plr.Character then
						if Players[Plr].IsTagger == false then
							Plr.Character.Humanoid.WalkSpeed = 16;
							Event:FireClient(Plr, "ctx", {""});
							print("okbye");
						end;
					end;
				end;
				if Tagger.Character then
					Event:FireClient(Tagger, "rbb");
					wait(3)
					Tagger.Character.HumanoidRootPart.CFrame = Map.SpawnBoundaries.CFrame;
					Event:FireClient(Tagger, "ctx", {""});
					Event:FireClient(Tagger, "apli", {Map.MapLighting});
				end;
				wait(2);
				spawn(function()
					while Counter == true do
						wait(1);
						RoundProgressed.Value = RoundProgressed.Value + 1;
					end;
				end);
				if Tagger.Character then
						Event:FireClient(Tagger, "lbb");
				end;
			elseif GameMode:lower() == "" then
				-- uHHH more game modes ayyyee
			end;
		end;
	end;
end);
Services.Players.PlayerRemoving:Connect(function(Player)
	local Plrs = Services.Players:GetPlayers();
	if #Plrs >= 2 then
		if Players[Player].IsTagger == true then
			TotalTaggers.Value = TotalTaggers.Value - 1;
			Players[Player].IsReady = false;
			if TotalTaggers.Value <= 0 then
				if RoundActive.Value == true then
					Round:PlrLeft({Services.ReplicatedStorage.Assets.Misc.CurrentMap.Value,game.Workspace:FindFirstChild("TaggerCabin")}, "tgl");
				end;
			end;
		end;
	elseif #Plrs < 2 then
		CanStart.Value = false;
		if Players[Player].IsTagger == true then
			TotalTaggers.Value = TotalTaggers.Value - 1;
			Players[Player].IsReady = false;
			if TotalTaggers.Value <= 0 then
				if RoundActive.Value == true then
					Round:PlrLeft({Services.ReplicatedStorage.Assets.Misc.CurrentMap.Value,game.Workspace:FindFirstChild("TaggerCabin")}, "tgl");
					if CanStart.Value == false then
						Event:FireAllClients("nep");
					end;
				end;
			end;
		elseif Players[Player].IsTagger == false then
			if RoundActive.Value == true then
				Round:PlrLeft({Services.ReplicatedStorage.Assets.Misc.CurrentMap.Value,game.Workspace:FindFirstChild("TaggerCabin")}, "nep");
				if CanStart.Value == false then
					Event:FireAllClients("nep");
				end;
			end;
		end;
	end;
end);
