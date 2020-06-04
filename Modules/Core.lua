local Requires = {};
function Require(String)
	local Succ, Err = pcall(function()
		if not Requires[String] then
			if typeof(String) == "Instance" then
				Requires[String] = require(String);
				return Requires[String];
			elseif typeof(String) == "string" then
				Requires[String] = require(game:FindFirstChild(String, true));
				return Requires[String];
			else
				warn("Cannot require object of type ", typeof(String))
			end;
		else
			return Requires[String];
		end;
	end);
	if not Succ then
		warn(String, "failed to load because of", Err, "called from", getfenv(2).script.Name)
	end
	return Err;
end;

return function()
	local NewFenv = {require = Require};
	local OldFenv = getfenv(2);
	setmetatable(NewFenv, {__index = getfenv(2)})
	setfenv(2, NewFenv)
end;
