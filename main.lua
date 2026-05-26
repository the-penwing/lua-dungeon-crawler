local combat = require("src.combat")
local game = require("src.game")
local rooms = require("src.rooms")
local items = require("src.items")

-- Start a test combat
local testEnemies = rooms[2].enemies -- Room 2 has 2 bats + 1 goblin
local result = combat.combatLoop(testEnemies)

print("Combat result:", result)
print("Player health:", game.player.health)
print("\nFinal Inventory:")
for _, item in ipairs(game.player.inventory) do
	print("  " .. items.getItemById(item.id).name .. " (x" .. item.quantity .. ")")
end
