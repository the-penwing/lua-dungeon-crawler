local game = require("game")
local item = require("items")
local function getPlayerAction()
	print("\n--- Your Turn ---")
	print("1. Attack")
	print("2. Use Item")
	print("3. Flee")
	io.write("Enter choice (1-3): ")
	local choice = io.read()
	return tonumber(choice)
end

local function playerAttack(enemy)
	local weapon = game.player.equippedWeapon
	local damage = weapon.damage
	local hitChance = weapon.hitChance

	if math.random(1, 100) <= hitChance then
		enemy.health = enemy.health - damage
		print("You hit " .. enemy.name .. " for " .. damage .. " damage!")
	else
		print("Attack Missed!!")
	end
end
local function useItem(itemName)
	-- Find the item in inventory
	local itemIndex = nil
	local usedItem = nil

	for i, item in ipairs(game.player.inventory) do
		if item.name == itemName then
			itemIndex = i
			usedItem = item
			break
		end
	end

	-- If found and has quantity
	if usedItem and usedItem.quantity > 0 then
		usedItem.quantity = usedItem.quantity - 1

		-- Apply effect based on item
		if itemName == items.consumables.healing_potion.name then
			game.player.health = math.min(game.player.health + 15, game.player.maxHealth)
			print("Used " .. itemName .. ". Health restored to " .. game.player.health .. "!")
		end

		-- Remove item if quantity hits 0
		if usedItem.quantity == 0 then
			table.remove(game.player.inventory, itemIndex)
		end
	else
		print("You don't have that item!")
	end
end

local function attemptFlee()
	if math.random(1, 100) <= 25 then
		print("You fled successfully")
		return true
	else
		print("uh oh, you failed to flee")
		return false
	end
end
local function enemyAttack(enemy)
	local damage = enemy.damage

	game.player.health = game.player.health - damage
	print("ouch, " .. enemy.name .. " did " .. damage .. " to you")

	if game.player.health <= 0 then
		game.playerAlive = false
		print("oh snap, that blow killed you.")
	end
end
local function combatLoop(enemy)
	while enemy.health > 0 and game.player.health > 0 do
		-- Show state
		-- Get player action
		-- Execute action
		-- Enemy turn
	end
	-- Check win/lose
end

print(getPlayerAction())
