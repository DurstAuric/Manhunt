local Services = require(game:GetService("ServerStorage").Services);
local Core = require(Services.ServerStorage.Core)();
local PlayerStats = require("PlayerStats");
local DataStore = Services.DataStoreService:GetDataStore("PlayerStats");

local Event = Services.ReplicatedStorage.Assets.Events.GE;

Services.Players.PlayerAdded:Connect(function(Player)
	local PlayerData = Services.HttpService:JSONDecode(DataStore:GetAsync(Player.UserId));
	if PlayerData then
		warn(Player.Name .. " DATA FOUND, LOADING");
	else
		warn(Player.Name .. " DATA NOT FOUND, CREATING NEW DATA");
	end
	PlayerStats:CreatePlayer(Player, PlayerData);
end);

Services.Players.PlayerRemoving:Connect(function(Player)
	local Plr = PlayerStats:FindPlayer(Player);
	Plr:SaveData();
end);
