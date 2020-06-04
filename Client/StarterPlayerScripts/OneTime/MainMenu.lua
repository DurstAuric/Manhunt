local LoadingScreen = game:GetService("ReplicatedStorage").Assets.Misc.LoadingScreen:Clone();
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Event = ReplicatedStorage.Assets.Events.GE;
local Cam = game.Workspace.CurrentCamera;
local Lighting = game:GetService("Lighting");
local LobbyLighting = {}
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame");
local Logo = Instance.new("ImageLabel");
local Logo2 = Instance.new("ImageLabel");
local Logo3;
local Text1 = Instance.new("ImageLabel");
local PlayButton = Instance.new("ImageButton");
local Player = game.Players.LocalPlayer;
local IsPlaying = false;
local Sounds = {
	Ticking = ReplicatedStorage.Assets.Sounds.Ticking:Clone();
	Bell = ReplicatedStorage.Assets.Sounds.Bell:Clone();
	CandleBlow = ReplicatedStorage.Assets.Sounds.CandleBlow:Clone();
};
Sounds.Ticking.Parent, Sounds.Bell.Parent, Sounds.CandleBlow.Parent = Player:WaitForChild("Backpack"), Player:WaitForChild("Backpack"), Player:WaitForChild("Backpack");
ScreenGui.Name = "BlackScreen";
ScreenGui.DisplayOrder = 1;
ScreenGui.IgnoreGuiInset = true;
Frame.BackgroundColor3 = Color3.new(0,0,0);
Frame.Size = UDim2.new(1,0,1,0);
Frame.BorderSizePixel = 0;
Frame.Parent = ScreenGui;
Logo.ZIndex = 0;
Logo.Size = UDim2.new(0.3, 0, 0.2, 0);
Logo.AnchorPoint = Vector2.new(0.5, 0.5);
Logo.Position = UDim2.new(0.5, 0, 0.12, 0);
Logo.BackgroundTransparency = 1;
Logo.BorderSizePixel = 0;
Logo.ScaleType = Enum.ScaleType.Fit;
Logo.Image = "rbxassetid://2803224846";
Logo.Parent = ScreenGui;
PlayButton.BackgroundTransparency = 1;
PlayButton.BorderSizePixel = 0;
PlayButton.ScaleType = Enum.ScaleType.Fit;
PlayButton.AnchorPoint = Vector2.new(0.5, 0.5);
PlayButton.Size = UDim2.new(0.1, 0, 0.1, 0);
PlayButton.Position = UDim2.new(0.5, 0, 0.9, 0);
PlayButton.ZIndex = 0;
PlayButton.Image = "rbxassetid://2803250686";
PlayButton.ImageColor3 = Color3.new(0,0,0);
PlayButton.Active = false;
PlayButton.Parent = ScreenGui;
Logo2.Size = UDim2.new(0.5, 0, 0.5, 0);
Logo2.Position = UDim2.new(0.5, 0, 0.6, 0);
Logo2.AnchorPoint = Vector2.new(0.5,0.5);
Logo2.BackgroundTransparency = 1;
Logo2.BorderSizePixel = 0;
Logo2.ScaleType = Enum.ScaleType.Fit;
Logo2.ImageTransparency = 1;
Logo2.Image = "rbxassetid://2805368868";
Logo2.Parent = ScreenGui;
Logo3 = Logo:Clone();
Logo3.ZIndex = 1;
Logo3.Size = UDim2.new(0.5, 0, 0.3, 0);
Logo3.Position = UDim2.new(0.5, 0, 0.5, 0);
Logo3.ImageTransparency = 1;
Text1.ImageTransparency = 1;
Text1.BackgroundTransparency = 1;
Text1.BorderSizePixel = 0;
Text1.AnchorPoint = Vector2.new(0.5, 0.5);
Text1.Position = UDim2.new(0.5, 0, 0.25, 0);
Text1.Size = UDim2.new(0.5,0,0.2,0);
Text1.ScaleType = Enum.ScaleType.Fit;
Text1.Image = "rbxassetid://2805694087";
Text1.Parent = ScreenGui;
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui;
LobbyLighting.Ambient = Lighting.Ambient; LobbyLighting.Brightness = Lighting.Brightness; LobbyLighting.ColorShift_Bottom = Lighting.ColorShift_Bottom; LobbyLighting.ColorShift_Top = Lighting.ColorShift_Top; LobbyLighting.OutdoorAmbient = Lighting.OutdoorAmbient;
Cam.CameraSubject = LoadingScreen.CameraOffset;
LoadingScreen.Parent = game.Workspace;
Cam.CameraType = Enum.CameraType.Scriptable;
Cam.CFrame = LoadingScreen.CameraOffset.CFrame * CFrame.Angles(math.rad(200),math.rad(0),math.rad(180));
Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness = Color3.fromRGB(22, 10, 0), Color3.new(0,0,0), 1;
PlayButton.MouseEnter:Connect(function()
	if PlayButton.Active==true then
		PlayButton.ImageColor3 = Color3.fromRGB(200,200,200);
	end;
end);
PlayButton.MouseLeave:Connect(function()
	if PlayButton.Active==true then
		PlayButton.ImageColor3 = Color3.fromRGB(255,255,255);
	end
end);
PlayButton.MouseButton1Down:Connect(function()
	if PlayButton.Active == true then
		PlayButton.Active = false;
		PlayButton.ImageColor3 = Color3.new(1,0,0);
		Sounds.CandleBlow:Play();
		LoadingScreen.Candle.Wick.Sound:Stop();
		for i = 1.2, 0, -0.2 do
			wait();
			Frame.BackgroundTransparency = i;
		end;
		IsPlaying = true;
		Lighting.Ambient = LobbyLighting.Ambient;
		Lighting.OutdoorAmbient = LobbyLighting.OutdoorAmbient;
		Lighting.Brightness = LobbyLighting.Brightness;
		wait(2);
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", true);
		Cam.CameraSubject = Player.Character:FindFirstChild("Humanoid");
		Cam.CameraType = Enum.CameraType.Custom;
		Cam.CFrame = Player.Character.HumanoidRootPart.CFrame;
		Logo:Destroy();
		PlayButton:Destroy();
		LoadingScreen:Destroy();
		Sounds.Bell:Destroy();
		Sounds.Ticking:Destroy();
		Sounds.CandleBlow:Destroy();
		Player.PlayerGui.Lobby.Indicator.ImageTransparency = 0;
		Player.PlayerGui.Lobby.Store.Visible = true;
		Event:FireServer("nplr")
		Event:FireServer("rdup");
		for i = 0, 1.1, 0.1 do
			wait();
			Frame.BackgroundTransparency = i;
		end;
		ScreenGui:Destroy()
		SoundService.Crickets:Play();
		SoundService.Wind:Play();
		script:Destroy()
	end;
end);
Sounds.Ticking:Play()
wait(2);
spawn(function()
	for i = 1.02, 0, -0.02 do
		wait()
		Text1.ImageTransparency = i;
	end;
end);
for tn = 1.02, 0, -0.02 do
	wait()
	Logo2.ImageTransparency = tn;
end;
wait(3);
spawn(function()
	for i = 0, 1.02, 0.02 do
		wait()
		Text1.ImageTransparency = i;
	end;
end);
spawn(function()
	for tn = 0, 1.02, 0.02 do
		wait()
		Logo2.ImageTransparency = tn;
	end;
end);
wait(2.4);
Sounds.Ticking:Stop()
wait(1);
Logo3.Parent = ScreenGui;
Logo3.ImageTransparency = 0;
Sounds.Bell:Play();
wait(3);
spawn(function()
	for tn = 0, 1.02, 0.02 do
		wait()
		Logo3.ImageTransparency = tn;
	end;
end);
spawn(function()
	repeat
		local Num = math.random(0, 9)/100;
		LoadingScreen.Candle.Wick.Close.Enabled = false;
		wait(Num);
		LoadingScreen.Candle.Wick.Close.Enabled = true;
		wait(Num);
	until IsPlaying == true;
end);
spawn(function()
	local Pos = Cam.CFrame
	repeat
		local Sin = math.sin(tick()+-5)/75;
		Cam.CFrame = Pos * CFrame.Angles(Sin,0,Sin);
		wait(0);
	until IsPlaying == true;
end);
wait(3);
LoadingScreen.Candle.Wick.Sound:Play();
for i = 0, 1.05, 0.005 do
	wait();
	Frame.BackgroundTransparency = i;
	PlayButton.ImageColor3 = Color3.new(i/2,i/2,i/2);
end;
print("Hey, " .. Player.Name .. "! The game has loaded and is ready to play! Have fun! :)")
PlayButton.Active=true;
PlayButton.ImageColor3 = Color3.new(1,1,1);
