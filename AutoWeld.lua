local Model = script.Parent;
local Current,Prev;
for _, Child in pairs(Model:GetChildren()) do
	if Child:IsA("BasePart") then
		Current = Child;
		if Prev then
			local Weld = Instance.new("WeldConstraint");
			Weld.Parent = Prev
			Weld.Part0 = Prev;
			Weld.Part1 = Current;
			Current.Anchored = false;
			Prev.Anchored = false;
		end;
		Prev = Child;
	end;
end;
