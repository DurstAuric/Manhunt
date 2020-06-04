local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Event = ReplicatedStorage.Assets.Events.GE;
local SetCam = ReplicatedStorage.Assets.Events.SetCam;
local Cam = game.Workspace.CurrentCamera;
local GameEnded = ReplicatedStorage.Assets.Lobby.GameEnded;
local Tween = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0);
--Cam.CFrame = LoadingScreen.CameraOffset.CFrame * CFrame.Angles(math.rad(200),math.rad(0),math.rad(180));
local function CheckCall(Call, Args)
	if Call:lower() == "rnen" then
		if Args[1].IsReady == true then
			Cam.CameraType = Enum.CameraType.Scriptable;
			Cam.CFrame = Args[2].CFrame * CFrame.Angles(0,0,0)*CFrame.Angles(math.rad(0),math.rad(10),math.rad(0));
			spawn(function()
				local Pos = Cam.CFrame
				repeat
					local Sin = math.sin(tick()+-5)/75;
					Cam.CFrame = Pos * CFrame.Angles(Sin,0,Sin)
					wait(0);
				until GameEnded.Value == false;
			end);
		end;
	elseif Call:lower() == "fnsh" then
		if Args[1].IsReady == true then
			Cam.CameraSubject = Args[2].Character:FindFirstChild("Humanoid");
			Cam.CameraType = Enum.CameraType.Custom;
			Cam.CFrame = Args[2].Character.HumanoidRootPart.CFrame;
		end
	elseif Call:lower() == "mplc" then
		if Args[1] == false then
			local Destination = TweenService:Create(Cam, Tween, {CFrame = Args[2].CFrame * CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))});
			Cam.CameraType = Enum.CameraType.Scriptable;
			Destination:Play();
		end
	elseif Call:lower() == "mplclv" then
		if Args[1] == true then
			Cam.CameraSubject = Args[2].Character:FindFirstChild("Humanoid");
			Cam.CameraType = Enum.CameraType.Custom;
			Cam.CFrame = Args[2].Character.HumanoidRootPart.CFrame;
		end;
	end;
end;
Event.OnClientEvent:Connect(function(Call, Args)
	CheckCall(Call, Args);
end);
SetCam.Event:Connect(function(Call, Args)
	CheckCall(Call, Args);
end);
