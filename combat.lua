local game = require("game")
local items = require("items")
local ui = require("ui")
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

local function useItem(itemIndex)
	-- Get the item from inventory
	local usedItem = game.player.inventory[itemIndex]

	-- Check if it exists and has quantity
	if usedItem and usedItem.quantity > 0 then
		-- Apply effect based on item name
		if usedItem.name == items.consumables.healing_potion.name then
			game.player.health = math.min(game.player.health + 15, game.player.maxHealth)
			print(
				"Used " .. items.consumables.healing_potion.name .. ". Health restored to " .. game.player.health .. "!"
			)
		end

		-- Decrement and remove if empty
		usedItem.quantity = usedItem.quantity - 1
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
	if math.random(1, 100) <= enemy.hitChance then
		local damage
		if enemy.name == "Dragon" then
			if enemy.attackPhase < 3 then
				damage = enemy.damage.small
			else
				damage = enemy.damage.big
			end
		else
			damage = enemy.damage
		end

		game.player.health = game.player.health - damage
		print("ouch, " .. enemy.name .. " did " .. damage .. " to you")
	else
		print(enemy.name .. "'s attack missed!")
	end

	-- Increment dragon's attack cycle (whether hit or miss)
	if enemy.name == "Dragon" then
		enemy.attackPhase = (enemy.attackPhase + 1) % 4 -- Cycles 0,1,2,3,0,1,2,3...
	end

	if game.player.health <= 0 then
		game.playerAlive = false
		print("oh snap, that blow killed you.")
	end
end

local function awardLoot(enemy)
	for _, lootItem in ipairs(enemy.loot) do
		-- Check if item already in inventory
		local found = false
		for _, invItem in ipairs(game.player.inventory) do
			if invItem.name == lootItem.name then
				-- Item exists, add quantity
				invItem.quantity = invItem.quantity + lootItem.quantity
				found = true
				break
			end
		end

		-- If not found, add new item
		if not found then
			table.insert(game.player.inventory, { name = lootItem.name, quantity = lootItem.quantity })
		end
	end
end

local function combatLoop(enemies)
	while #enemies > 0 and game.player.health > 0 do
		-- 1. Display state
		ui.displayCombatState(enemies)

		-- 2. Get player action (1-3)
		local choice = getPlayerAction()

		-- 3. Execute action based on choice
		if choice == 1 then
			local targetValid = false
			repeat
				-- Clear screen
				-- Display enemies
				print("Choose target:")
				for i, enemy in ipairs(enemies) do
					print(i .. ") " .. enemy.name .. " (" .. enemy.health .. "/" .. enemy.maxHealth .. ")")
				end

				-- Get target choice
				io.write("Target (1-" .. #enemies .. "): ")
				local targetIndex = tonumber(io.read())

				-- Validate and attack
				if targetIndex and targetIndex >= 1 and targetIndex <= #enemies then
					playerAttack(enemies[targetIndex])
					if enemies[targetIndex].health <= 0 then
						-- Remove the enemy and award loot
						awardLoot(enemies[targetIndex])
						table.remove(enemies, targetIndex)
					end
					targetValid = true
				else
					print("Invalid target!")
				end
			until targetValid == true
		elseif choice == 2 then
			-- Display items
			local inventory = game.player.inventory
			print("Select an item:")
			for i, item in ipairs(inventory) do
				print(i .. ") " .. item.name .. " (x" .. item.quantity .. ")")
			end

			-- Get item choice
			io.write("Item (1-" .. #inventory .. "): ")
			local itemIndex = tonumber(io.read())

			-- Validate and use
			useItem(itemIndex)
		elseif choice == 3 then
			if attemptFlee() then
				game.player.health = math.ceil(game.player.health * 1.5)
				return "fled"
			end
			-- If flee fails, just continue to enemy turn
		end

		-- 4. Enemy turn (if enemies remain)
		for _, enemy in ipairs(enemies) do
			enemyAttack(enemy)
		end
	end

	-- After loop: check result
	if game.player.health <= 0 then
		return false
	else
		return true
	end
end
return {
	combatLoop = combatLoop,
}
