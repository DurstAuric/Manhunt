local Services = require(game:GetService("ServerScriptService").Scripts.Modules.Resources);
local Maps = Services.ServerStorage.Assets.Maps:GetChildren();
local Event = Services.ReplicatedStorage.Assets.Events.GE;
local RoundActive = Services.ReplicatedStorage.Assets.Lobby.RoundActive;
local GameEnded = Services.ReplicatedStorage.Assets.Lobby.GameEnded;
local RoundProgressed = Services.ReplicatedStorage.Assets.Lobby.RoundProgressed;
local CanStart = Services.ReplicatedStorage.Assets.Lobby.CanStart;
local Round = {};
local Players = {};
local Plrs = {};
local PlrFolder = Services.ReplicatedStorage.Players
local Counter = Services.ServerStorage.Assets.Misc.Counter;
local TotalTaggers = Services.ServerStorage.Assets.Misc.TotalTaggers;

function Round:ChooseMap()
	math.randomseed(tick()*math.random());
	local Map = Maps[math.random(1,#Maps)]:Clone();
	Services.ReplicatedStorage.Assets.Misc.CurrentMap.Value = Map;
	return Map;
end;

local Map = Round:ChooseMap();
local Cabin = Services.ServerStorage.Assets.Lobby.TaggerCabin:Clone();
Map.Parent = game.Workspace;
Cabin.Parent = game.Workspace;
Event:FireAllClients("hcl");

for _,Player in pairs(Services.Players:GetPlayers()) do
	if Player.Character then
		if PlrFolder[Player.Name].IsReady.Value == true then
			Event:FireClient(Player, "rbb");
			Players[Player] = {
				IsReady = true;
				IsTagger = false;
			};
		end;
	end;
end;

wait(3);

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
		end;
	end;
end;
wait(2);
for Plr,_ in pairs(Players) do
	if Plr.Character then
		if Players[Plr].IsReady == true then
			Event:FireClient(Plr, "lbb");
		end;
	end;
end;
wait(5);
for Plr,_ in pairs(Players) do
	if Plr.Character then
		if Players[Plr].IsTagger == false then
			Plr.Character.Humanoid.WalkSpeed = 16;
			Event:FireClient(Plr, "ctx", {""});
		end;
	end;
end;
if Tagger.Character then
	Event:FireClient(Tagger, "rbb");
	Services.ReplicatedStorage.Assets.Lobby.Hiding.Value = false;
	wait(3)
	Tagger.Character.HumanoidRootPart.CFrame = Map.SpawnBoundaries.CFrame;
	Event:FireClient(Tagger, "ctx", {""});
	Event:FireClient(Tagger, "apli", {Map.MapLighting});
end;
wait(2);
Event:FireClient(Tagger, "lbb");
Services.ReplicatedStorage.Assets.Lobby.Hiding.Value = false
