local rooms = require("src.rooms")
local items = require("src.items")

local game = {
	player = {
		health = 100,
		maxHealth = 100,
		mp = 20,
		maxMP = 20,
		spellCooldown = false,
		currentRoom = 1,
		equippedWeapon = items.weapons.rusty_sword,
		inventory = {
			{ name = items.weapons.rusty_sword.name, quantity = 1 },
			{ name = items.consumables.healing_potion.name, quantity = 1 },
		},
	},
	rooms = rooms,
	bossBeat = false,
	playerAlive = true,
}

return game
