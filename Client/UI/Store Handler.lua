--reverse():gsub("%d%d%d", "%1,"):gsub(",$", ""):reverse()
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Player = game.Players.LocalPlayer;
local ShopGui = Player.PlayerGui:WaitForChild("Shop");
local Camera = game.Workspace.CurrentCamera;
local NewCamera = Instance.new("Camera");
local IsReady = ReplicatedStorage.Players:WaitForChild(Player.Name).IsReady;
local Event = ReplicatedStorage.Assets.Events.GE;
local Bars = ReplicatedStorage.Assets.Events.Bars;
local SetCam = ReplicatedStorage.Assets.Events.SetCam;
local CTX = ReplicatedStorage.Assets.Events.CTX;
local MPShack = game.Workspace.MarketShack;
local Button = script.Parent;
local InStore = ReplicatedStorage.Players:WaitForChild(Player.Name).InStore
local OnStore = false;
local Children = game.Workspace.MarketShack:GetDescendants();
local Models = ReplicatedStorage.Assets.Misc.WeaponModels;
local Detector = game.Workspace.Detector
--local Stats = require(Models.WeaponStats);
local Click = {};
local Focus = false;

local Group = {};
local Index = 1;
local Changing = false;

ShopGui.Buy.Item.CurrentCamera = NewCamera;

local Tween = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0);
for _, Child in pairs(Children) do
	if Child:IsA("ClickDetector") then
		table.insert(Click, Child);
	end;
end;

local function SortByPrice(Tab)
	local Num = 1;
	local Temp = {};
	for _,v in pairs(Tab) do
		table.insert(Temp ,{["skin"] = v; ["price"] = v.WeaponStats.PRICE;});
		Num = Num + 1;
	end;
	Tab = Temp;
	local Sorted = true;
	local N = 0;
	while Sorted do
		Sorted = false;
		local Prev;
		for i = 1, #Tab - N do
			if Tab[i + 1] and Tab[i]["price"].Value < Tab[i + 1]["price"].Value then
				Sorted = true;
				Temp = Tab[i];
				Tab[i] = Tab[i + 1];
				Tab[i + 1] = Temp;
			end;
		end;
		N = N +1;
	end;
	return Tab;
end;

local function Next()
	if Focus then
		Index = (Index >= #Group) and 1 or Index + 1;
	end;
end;
local function Back()
	if Focus then
		Index = (Index <= 1) and #Group or Index - 1;
	end;
end;

Button.MouseButton1Click:Connect(function()
	if InStore.Value == false or not OnStore then
		if IsReady.Value == true then
			Event:FireServer("mprd");
			Bars:Fire("rbb");
			wait(3);
			SetCam:Fire("mplc", {IsReady.Value, MPShack.Cams.Cam});
			script.Parent.Active = false;
			script.Parent.Visible = false;
			CTX:Fire("ep");
			wait(2);
			Bars:Fire("nrbb");
		end;
	end;
end);

ShopGui.Buy.Next.MouseButton1Click:Connect(function()
	if ShopGui.Buy.Next.Active then
		if Changing == false then
			Changing = true;
			Next();
			local Model = Group[Index]["skin"]:Clone();
			local Stats = Model.WeaponStats;
			local Name = Stats.NAME.Value;
			local Price = Stats.PRICE.Value;
			local OldPos = NewCamera.CFrame;
			local OldModel = ShopGui.Buy.Item:FindFirstChildOfClass("Model")
			local OldPos = OldModel:GetPrimaryPartCFrame();
			Model:SetPrimaryPartCFrame(OldPos * CFrame.new(0, 0, 0));
			OldModel:Destroy();
			Model.Parent = ShopGui.Buy.Item;
			ShopGui.Buy.ItemName.Text = Name;
			ShopGui.Buy.ItemPrice.Text = tostring(Price):reverse():gsub("%d%d%d", "%1,"):gsub(",$", ""):reverse()
			Changing = false;
			--local NewPos = CamPart.CFrame * CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0));
		end;
	end;
end);

ShopGui.Buy.Prev.MouseButton1Click:Connect(function()
	if ShopGui.Buy.Next.Active then
		if Changing == false then
			Changing = true;
			Back();
			local Model = Group[Index]["skin"]:Clone();
			local Stats = Model.WeaponStats;
			local Name = Stats.NAME.Value;
			local Price = Stats.PRICE.Value;
			local OldPos = NewCamera.CFrame;
			local OldModel = ShopGui.Buy.Item:FindFirstChildOfClass("Model")
			local OldPos = OldModel:GetPrimaryPartCFrame();
			Model:SetPrimaryPartCFrame(OldPos * CFrame.new(0, 0, 0));
			OldModel:Destroy();
			Model.Parent = ShopGui.Buy.Item;
			ShopGui.Buy.ItemName.Text = Name;
			ShopGui.Buy.ItemPrice.Text = tostring(Price):reverse():gsub("%d%d%d", "%1,"):gsub(",$", ""):reverse()
			Changing = false;
			--local NewPos = CamPart.CFrame * CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0));
		end;
	end;
end);

ShopGui.Back.MouseButton1Click:Connect(function()
	if ShopGui.Back.Active then
		if InStore.Value == true or OnStore then
			if Focus == true then
				Focus = false;
				local OldPos = Camera.CFrame
				local NewPos = MPShack.Cams.Cam.CFrame * CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0));
				local Destination = TweenService:Create(Camera, Tween, {CFrame = NewPos});
				Destination:Play();
				spawn(function()for i = 20, 0, -1 do
					Camera.Blur.Size = i;
					wait(0);
				end;end);
				for i = -0.05, 1.1, 0.1 do
					ShopGui.Buy.Item.ImageTransparency, ShopGui.Buy.Next.ImageTransparency, ShopGui.Buy.Prev.ImageTransparency, ShopGui.Back.ImageTransparency, ShopGui.Buy.ItemName.TextTransparency, ShopGui.Buy.ItemPrice.TextTransparency, ShopGui.Buy.Currency.ImageTransparency = i,i,i,i,i,i,i;
					wait(0);
				end
				ShopGui.Enabled = false;
				ShopGui.Buy.Item.Visible = false;
				ShopGui.Back.Active, ShopGui.Back.Visible = false, false;
				ShopGui.Buy.Next.Visible, ShopGui.Buy.Prev.Visible = false, false;
				ShopGui.Buy.Next.Active, ShopGui.Buy.Prev.Active = false, false;
				ShopGui.Buy.ItemName.Visible, ShopGui.Buy.ItemPrice.Visible, ShopGui.Buy.Currency.Visible = false, false, false;
				for _, Child in pairs(ShopGui.Buy.Item:GetChildren()) do
					Child:Destroy();
				end;
			end;
		end;
	end;
end);

for _, Child in pairs(Click) do
	Child.MouseClick:Connect(function()
		if InStore.Value == true or OnStore then
			if not Focus then
				Focus = true;
				ShopGui.Enabled = true;
				Index = 1;
				local Model = Child.Parent;
				local Model2 = Models[Model.Name][Model.Name]:Clone();
				local CamPart = MPShack.Cams[Model.Name.."Cam"];
				local Stats = Model2.WeaponStats;
				local Name = Stats.NAME.Value;
				local Price = Stats.PRICE.Value;
				local OldPos = Camera.CFrame;
				local NewPos = CamPart.CFrame * CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0));
				local ModCF,ModSize=Model2:GetBoundingBox();
				local Destination = TweenService:Create(Camera, Tween, {CFrame = NewPos});
				Group = SortByPrice(Models[Model.Name]:GetChildren());
				if Camera:FindFirstChild("Blur") then
					Camera.Blur:Destroy();
				end;
				ShopGui.Buy.ItemName.Text = Name;
				ShopGui.Buy.ItemPrice.Text = tostring(Price):reverse():gsub("%d%d%d", "%1,"):gsub(",$", ""):reverse()
				local Blur = Instance.new("BlurEffect");
				Blur.Parent = Camera;
				Blur.Size = 0;
				Destination:Play();
				Model2.Parent = ShopGui.Buy.Item;
				ShopGui.Buy.Item.Visible = true;
				ShopGui.Back.Active, ShopGui.Back.Visible = true, true;
				ShopGui.Buy.Next.Visible, ShopGui.Buy.Prev.Visible = true, true;
				ShopGui.Buy.Next.Active, ShopGui.Buy.Prev.Active = true, true;
				ShopGui.Buy.ItemName.Visible, ShopGui.Buy.ItemPrice.Visible, ShopGui.Buy.Currency.Visible = true, true, true;
				spawn(function()for i = 1, -0.05, -0.05 do
					ShopGui.Buy.Item.ImageTransparency, ShopGui.Buy.Next.ImageTransparency, ShopGui.Buy.Prev.ImageTransparency, ShopGui.Back.ImageTransparency, ShopGui.Buy.ItemName.TextTransparency, ShopGui.Buy.ItemPrice.TextTransparency, ShopGui.Buy.Currency.ImageTransparency = i,i,i,i,i,i,i;
					wait(0);
				end; end);
				spawn(function() for i = 0, 20 do
					Blur.Size = i;
					wait(0);
				end; end);
				NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.X)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(135));
				if Model2.WeaponStats.WeaponType.Value == "Sword" then
					NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.Y-2)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(45));
					Model2:SetPrimaryPartCFrame(Model2.PrimaryPart.CFrame * CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0)));
				elseif Model2.WeaponStats.WeaponType.Value == "Hammer" then
					NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.X-1.7)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(135));
					Model2:SetPrimaryPartCFrame(Model2.PrimaryPart.CFrame * CFrame.Angles(math.rad(60),math.rad(0),math.rad(0)));
				elseif Model2.WeaponStats.WeaponType.Value == "BigKnife" then
					NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.X-2)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(120));
				elseif Model2.WeaponStats.WeaponType.Value == "Axe" then
					NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.X-0.8)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(135));
				elseif Model2.WeaponStats.WeaponType.Value == "Knife" then
					NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.X-.8)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(135));
					Model2:SetPrimaryPartCFrame(Model2.PrimaryPart.CFrame * CFrame.Angles(math.rad(60),math.rad(0),math.rad(0)));
				elseif Model2.WeaponStats.WeaponType.Value == "Mace" then
					NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.X-1.8)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(135));
				elseif Model2.WeaponStats.WeaponType.Value == "Bat" then
					NewCamera.CoordinateFrame = ModCF*CFrame.new(0,0,ModSize.X-1.8)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(135));
				end
				--Model2:SetPrimaryPartCFrame(Model2.PrimaryPart.CFrame * CFrame.Angles(math.rad(90),math.rad(-45),math.rad(0)))
			end;
		end;
	end);
end;

--IsReady.Changed:Connect(function()
--	Event:FireServer("rdup");
--end);

Player.Character.Humanoid.Changed:Connect(function()
	local Magnitude = math.floor((Detector.Position - Player.Character.HumanoidRootPart.Position).magnitude);
	if Magnitude <=8 then
		if not OnStore then
			Button.Visible = false;
			Button.Active = false;
			CTX:Fire("ep");
			SetCam:Fire("mplc", {OnStore, MPShack.Cams.Cam});
			OnStore = true;
		end;
	else
		Button.Visible = true;
		Button.Active = true;
		CTX:Fire("nep");
		SetCam:Fire("mplclv",{OnStore, Player});
		OnStore = false;
	end
end)

Event.OnClientEvent:Connect(function(Call)
	if Call:lower() == "dsbstr" then
		print("goodbye??");
		script.Parent.Visible = false;
		script.Parent.Active = false;
	elseif Call:lower() == "enbstr" then
		print("wait uhh?");
		script.Parent.Visible = true;
		script.Parent.Active = true;
	end;
end);
