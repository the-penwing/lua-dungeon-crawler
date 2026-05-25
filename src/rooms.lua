local enemies = require("src.enemies")
local items = require("src.items")

-- Helper function to create an enemy instance
local function createEnemy(enemyTemplate)
	return {
		name = enemyTemplate.name,
		health = enemyTemplate.maxHealth,
		maxHealth = enemyTemplate.maxHealth,
		damage = enemyTemplate.damage,
		hitChance = enemyTemplate.hitChance,
		loot = enemyTemplate.loot,
		attackPhase = enemyTemplate.attackPhase or 0,
	}
end

local rooms = {
	[1] = {
		description = "A dark smelly stone hall.",
		enemies = {},
		loot = {
			{ name = items.weapons.rusty_sword.name, quantity = 1 },
			{ name = items.consumables.healing_potion.name, quantity = 1 },
		},
		exits = { north = 2 },
	},
	[2] = {
		description = "A small square room.",
		enemies = {
			createEnemy(enemies.bat),
			createEnemy(enemies.bat),
			createEnemy(enemies.goblin),
		},
		loot = {},
		exits = { east = 3 },
	},
	[3] = {
		description = "A medium-sized room.",
		enemies = {
			createEnemy(enemies.goblin),
			createEnemy(enemies.skeleton),
		},
		loot = {
			{ name = items.consumables.healing_potion.name, quantity = 2 },
			{ name = items.loot.gold_coin.name, quantity = 5 },
		},
		exits = { east = 4 },
	},
	[4] = {
		description = "A large room.",
		enemies = {
			createEnemy(enemies.dragon),
		},
		loot = {
			{ name = items.consumables.healing_potion.name, quantity = 1 },
			{ name = items.consumables.arrow.name, quantity = 15 },
		},
		exits = nil,
	},
}

return rooms
