local Data = {
	Player = nil;
	PlayerName = "";
	Coins = 0;
	GoldBars = 0;
	IsReady = false;
	InStore = false;
	Health = 100;
	Tags = 0;
	IsTagger = false;
	Selected = "Knife";
	Skin = "";
};

local Weapons = {
	Knife = {
		Owned = true;
		Skins = {};
	};
	Bat = {
		Owned = false;
		Skins = {};
	};
	Mace = {
		Owned = false;
		Skins = {};
	};
	Axe = {
		Owned = false;
		Skins = {};
	};
	Katana = {
		Owned = false;
		Skins = {};
	};
	Hammer = {
		Owned = false;
		Skins = {};
	};
	GiantKnife = {
		Owned = false;
		Skins = {};
	};
};

return {Data,Weapons};
