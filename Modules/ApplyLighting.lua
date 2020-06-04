local Resources = require(script.Parent.Resources);
local Lighting = {};
function Lighting:ApplyLighting(Args)
	Resources.Lighting.Ambient = Args[1];
	Resources.Lighting.Brightness = Args[2];
	Resources.Lighting.ColorShift_Bottom = Args[3];
	Resources.Lighting.OutdoorAmbient = Args[4];
end;
return Lighting;
