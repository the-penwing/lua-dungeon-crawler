local items = require("items")

local enemies = {
	bat = {
		name = "Bat",
		maxHealth = 5,
		damage = 1,
		loot = {},
	},
	goblin = {
		name = "Goblin",
		maxHealth = 20,
		damage = 5,
		loot = {
			{ name = items.loot.gold_coin.name, quantity = 1 },
		},
	},
	skeleton = {
		name = "Skeleton",
		maxHealth = 30,
		damage = 7,
		loot = {
			{ name = items.weapons.bow.name, quantity = 1 },
			{ name = items.consumables.arrow.name, quantity = 15 },
		},
	},
	dragon = {
		name = "Dragon",
		maxHealth = 75,
		damage = {
			small = 5,
			big = 15,
		},
		loot = {
			{ name = items.loot.gold_coin.name, quantity = 100 },
			{ name = items.weapons.longsword.name, quantity = 1 },
		},
	},
}

return enemies
