local rooms = require("rooms")
local items = require("items")

local game = {
	player = {
		health = 100,
		maxHealth = 100,
		mp = 20,
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
