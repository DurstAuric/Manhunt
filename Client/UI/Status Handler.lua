local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Player = game.Players.LocalPlayer;
local Event = ReplicatedStorage.Assets.Events.GE;
local CanStart = ReplicatedStorage.Assets.Lobby.CanStart;
local Status = script.Parent
local function CheckCall(Call, Args)
	if Call:lower() == "ctx" then
		Status.Text = Args[1];
	end;
end
Event.OnClientEvent:Connect(function(Call, Args)
	CheckCall(Call, Args);
end);
