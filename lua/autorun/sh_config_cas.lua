CAS = {}

CAS.DopList = { -- Additional things to the kit
	{
		name = 'Medkit',
		weapon = 'weapon_medkit',
		money = 15000,
	},
	{
		name = 'Crowbar',
		weapon = 'weapon_crowbar',
		money = 74000,
	},
}

CAS.List = { -- Kits
	{
		name = 'The beginning of the path',
		weapon = {
			'weapon_357',
			'weapon_bugbait',
			'weapon_fists',
		},
	},
	{
		name = 'The perfect VIP',
		weapon = {
			'weapon_shotgun',
			'weapon_pistol',
			'weapon_fists',
		},
		health = 150,
		armor = 50,
		rank = {
			'vip',
		},
		donat = true,
	},
	{
		name = 'Admin is not a noob',
		weapon = {
			'weapon_ar2',
			'weapon_pistol',
			'weapon_fists',
		},
		health = 180,
		armor = 100,
		rank = {
			'admin',
		},
		donat = true,
	},
	{
		name = 'Instant explosion',
		weapon = {
			'weapon_frag',
			'weapon_rpg',
			'weapon_fists',
		},
		health = 200,
		armor = 80,
		money = 24000,
		time = true,
	},
}
