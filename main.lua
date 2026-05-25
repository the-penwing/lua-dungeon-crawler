local combat = require("src.combat")
local game = require("src.game")
local rooms = require("src.rooms")

-- Start a test combat
local testEnemies = rooms[2].enemies -- Room 2 has 2 bats + 1 goblin
local result = combat.combatLoop(testEnemies)

print("Combat result:", result)
print("Player health:", game.player.health)
print("\nFinal Inventory:")
for _, item in ipairs(game.player.inventory) do
	print("  " .. item.name .. " (x" .. item.quantity .. ")")
end
