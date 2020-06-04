local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Player = game.Players.LocalPlayer;
local Event = ReplicatedStorage.Assets.Events.GE;
local CTX = ReplicatedStorage.Assets.Events.CTX;
local CanStart = ReplicatedStorage.Assets.Lobby.CanStart;
local Indicator = script.Parent;
local Clock = Indicator.Parent.Clock;
local function CheckCall(Call)
	if Call == "nep" then
		if CanStart.Value == false then
			Indicator.Visible = true;
		end;
	elseif Call == "ep" then
		Indicator.Visible = false;
	end;
end
Event.OnClientEvent:Connect(function(Call)
	CheckCall(Call);
end);
CTX.Event:Connect(function(Call)
	CheckCall(Call);
end)
