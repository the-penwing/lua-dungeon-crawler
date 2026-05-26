local enemies = {
	bat = {
		name = "Bat",
		maxHealth = 5,
		damage = 1,
		hitChance = 65,
		loot = {},
	},
	goblin = {
		name = "Goblin",
		maxHealth = 20,
		damage = 5,
		hitChance = 70,
		loot = {
			{ id = "goldcoin", quantity = 1 },
		},
	},
	skeleton = {
		name = "Skeleton",
		maxHealth = 30,
		damage = 7,
		hitChance = 75,
		loot = {
			{ id = "arrow", quantity = 5 },
		},
	},
	dragon = {
		name = "Dragon",
		maxHealth = 75,
		damage = {
			small = 5,
			big = 15,
		},
		hitChance = 80,
		attackPhase = 0,
		loot = {
			{ id = "goldcoin", quantity = 100 },
			{ id = "longsword", quantity = 1 },
		},
	},
}

return enemies
