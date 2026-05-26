local rooms = require("src.rooms")

local game = {
	player = {
		health = 100,
		maxHealth = 100,
		mp = 20,
		maxMP = 20,
		spellCooldown = false,
		currentRoom = 1,
		equippedWeapon = "rustysword",
		inventory = {
			{ id = "rustysword", quantity = 1 },
			{ id = "healingpotion", quantity = 1 },
		},
	},
	rooms = rooms,
	bossBeat = false,
	playerAlive = true,
}

return game
