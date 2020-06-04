local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CanStart, LobbyTimer = ReplicatedStorage.Assets.Lobby.CanStart, ReplicatedStorage.Assets.Lobby.LobbyTimer;
local Timer = require(script.TimerModule);
local VPF = script.Parent;
local Camera = Instance.new("Camera");
local Watch = game:GetService("ReplicatedStorage").Assets.Misc.Watch:Clone();
local Event = game:GetService("ReplicatedStorage").Assets.Events.GE;
local Bars = game:GetService("ReplicatedStorage").Assets.Events.Bars;
local Frame1 = Instance.new("Frame");
local Frame2 = Instance.new("Frame");

Frame1.Size, Frame2.Size = UDim2.new(1, 0, 0.5, 0), UDim2.new(1, 0, 0.5, 0)
Frame1.Position, Frame2.Position = UDim2.new(0, 0, -0.4, 0), UDim2.new(0, 0, 0.9, 0);
Frame1.BorderSizePixel, Frame2.BorderSizePixel = 0, 0;
Frame1.BackgroundColor3, Frame2.BackgroundColor3 = Color3.new(0,0,0),Color3.new(0,0,0);
Frame1.Parent, Frame2.Parent = script.Parent.Parent, script.Parent.Parent;
VPF.CurrentCamera = Camera;
Watch.Parent = VPF;
Camera.CoordinateFrame = Watch.Base.CFrame * CFrame.new(25,-15,0) * CFrame.Angles(math.rad(-90),math.rad(120),math.rad(0));
script.Parent.Visible = false;

local function CheckCall(Call)
	if Call:lower() == "scl" then
		if CanStart.Value == true then
			if LobbyTimer.Value > 0 then
				script.Parent.Visible = true;
				Timer:StartTimer({Watch.BigHand, Watch.LittleHand, ReplicatedStorage.Assets.Lobby.LobbyTimer.Value});
			end;
		end;
	elseif Call:lower() == "hcl" then
		script.Parent.Visible = false;
	elseif Call:lower() == "rbb" then
		spawn(function()
			Frame1:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 2, true)
		end);
		Frame2:TweenPosition(UDim2.new(0, 0, 0.5, 0), "Out", "Quad", 2, true)
	elseif Call:lower() == "lbb" then
		spawn(function()
			Frame1:TweenPosition(UDim2.new(0, 0, -0.5, 0), "Out", "Quad", 2, true)
		end);
		Frame2:TweenPosition(UDim2.new(0, 0, 1, 0), "Out", "Quad", 2, true)
	elseif Call:lower() == "nrbb" then
		spawn(function()
			Frame1:TweenPosition(UDim2.new(0, 0, -0.4, 0), "Out", "Quad", 2, true);
		end);
		Frame2:TweenPosition(UDim2.new(0, 0, 0.9, 0), "Out", "Quad", 2, true);
	end;
end

Event.OnClientEvent:Connect(function(Call)
	CheckCall(Call);
end);

Bars.Event:Connect(function(Call)
	CheckCall(Call);
end);

--old code, might need later. not sure. keep it for now.
--local t=80;
--local total=t/60;
--local m,s = math.modf(total); s=s*60;
--Watch.LittleHand:SetPrimaryPartCFrame(Watch.LittleHand.PrimaryPart.CFrame * CFrame.Angles(math.rad(-6*m),0,0));
--Watch.BigHand:SetPrimaryPartCFrame(Watch.BigHand.PrimaryPart.CFrame * CFrame.Angles(math.rad(-6*s),0,0));
--local cd,cdt=true,t
--while cd do
--	wait(1)
--	Watch.BigHand:SetPrimaryPartCFrame(Watch.BigHand.PrimaryPart.CFrame * CFrame.Angles(math.rad(6),math.rad(0),math.rad(0)))
--	cdt=cdt-1
--	if cdt%59==0 then
--		if cdt==0 then
--			cd=false;
--		else
--			Watch.LittleHand:SetPrimaryPartCFrame(Watch.LittleHand.PrimaryPart.CFrame * CFrame.Angles(math.rad(6),0,0));
--		end
--	end
--end

--Watch.BigHand:SetPrimaryPartCFrame(Watch.BigHand.PrimaryPart.CFrame * CFrame.Angles(math.rad(20),math.rad(0),math.rad(0)))

--while wait(1) do
--	Watch.BigHand:SetPrimaryPartCFrame(Watch.BigHand.PrimaryPart.CFrame * CFrame.Angles(math.rad(6),math.rad(0),math.rad(0)))
--end
