CAS = {}

CAS.DopList = { -- Additional things to the kit
    {
        id = 1,
        name = 'Medkit',
        weapon = 'weapon_medkit',
        money = 15000,
    },
    {
        id = 2,
        name = 'Crowbar',
        weapon = 'weapon_crowbar',
        money = 74000,
    },
}

CAS.List = { -- Kits
    {
        id = 1,
        name = 'The beginning of the path',
        weapon = {
            'weapon_357',
            'weapon_bugbait',
            'weapon_fists',
        },
        health = 100,
        armor = 0,
        rank = {
            'user',
        },
    },
    {
        id = 2,
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
        id = 3,
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
        id = 4,
        name = 'Instant explosion',
        weapon = {
            'weapon_frag',
            'weapon_rpg',
            'weapon_fists',
        },
        health = 200,
        armor = 80,
        rank = {
            'user',
        },
        money = 24000,
        time = true,
    },
}
