
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local Event = ReplicatedStorage.Assets.Events.GE;
Event.OnClientEvent:Connect(function(Call, Args)
	if Call:lower() == "apli" then
		if Args[1]:IsA("Configuration") then
			Lighting.Ambient = Args[1].Ambient.Value;
			Lighting.Brightness = Args[1].Brightness.Value;
			Lighting.ColorShift_Bottom = Args[1].ColorShift_Bottom.Value;
			Lighting.OutdoorAmbient = Args[1].OutdoorAmbient.Value;
			Lighting.ClockTime = Args[1].ClockTime.Value;
		end;
	end;
end);
