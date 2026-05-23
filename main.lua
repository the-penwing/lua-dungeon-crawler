local game = {
	player = {
		health = 100,
		maxHealth = 100,
		inventory = {},
		currentRoom = 1,
	},
	rooms = {
		-- [1] = { description = "...", enemies = {...}, loot = {...} },
		-- [2] = { ... }
	},
	bossBeat = false,
	playerAlive = true,
}

local function displayGameState()
	print("Player Stats:")
	if game.player.health > 0 then
		print("  Health: " .. game.player.health .. "/" .. game.player.maxHealth)
		print("  Inventory: " .. table.concat(game.player.inventory, ", "))
		print("  Current Room: " .. game.player.currentRoom)
	else
		print("Your dead boo")
	end
	print("Game Stats:")
	if game.bossBeat == false then
		print("  Boss Dead: Nope")
	else
		print("  Boss Dead: Yep, Congrats")
	end
end

displayGameState()
