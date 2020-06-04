local Player = {};
function Player:TakeDamage(Player, Damage, TaggerVal)
	Player.Health.Value = Player.Health.Value - Damage;
	if Player.Health.Value <= 0 then
		TaggerVal.Value = TaggerVal.Value + 1;
	end;
end;
function Player:Heal(Player, Health)
	Player.Health.Value = Player.Health.Value + Health;
end;
return Player;
