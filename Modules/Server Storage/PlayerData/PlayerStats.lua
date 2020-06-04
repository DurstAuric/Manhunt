local Services = require(game:GetService("ServerStorage").Services);
local Core = require(Services.ServerStorage.Core)();

local PlayerHandler = {Players = {}};
local Player = {};
local DefaultData = require("DefaultData");
local DataStore = Services.DataStoreService:GetDataStore("PlayerStats");

local Signal = require("Signal");

local function Update(Data)
	local NewData = Data
	for Index, Value in pairs(DefaultData) do
		if not Data[Index] then
			NewData[Index] = Value;
		end;
	end;
	return NewData;
end;

function PlayerHandler:CreatePlayer(Plr, Data)
	local self = {};
	self.Data = {};
	self.Weapons = {};
	if not Data then
		Data = DefaultData
	else
		Data = Update(Data);
	end;
	self.Data = Data[1];
	self.Weapons = Data[2];
	setmetatable(self.Data, {__index = Player});
	self.OldVal = {};
	self.Events = {};
	self.Name = Plr.Name;
	self.Player = Plr;
	setmetatable(self, {
		__index = self.Data;
		__newindex = function(Tab,Key,Val)
			self.Data[Key] = Val;
			if self.Events[Key] then
				for _,Func in pairs(self.Events[Key]) do
					Func(Val, self.OldVal[Key]);
				end;
			end;
			self.OldVal[Key] = Val;
		end;
	});
	PlayerHandler.Players[Plr.Name] = self;
	return self;
end;

function PlayerHandler:FindPlayer(Plr)
	return PlayerHandler.Players[Plr.Name];
end

function Player:ReadOnly()
	local Proxy = {};
	setmetatable(Proxy, {
		__index = self.Data;
		__newindex = function(Tab,Key,Val)
			error("Attempted to change read-only data");
		end;
		__metatable = false;
	});
	return Proxy;
end

function Player:Listen(Data, func)
	if not self.Events[Data] then
		self.Events[Data] = {};
	end;
	table.insert(self.Events[Data], func);
end;

function Player:SaveData()
	local JSON = Services.HttpService:JSONEncode(self);
	DataStore:UpdateAsync(self.Player.UserId, function()
		return JSON;
	end);
end;

function Player:Damage(Dmg)
	self.Health = self.Health - Dmg;
end
function Player:Heal(HP)
	self.Health = self.Health + HP;
end

return PlayerHandler;
