local game = require("src.game")
local spells = require("src.spells")
local items = require("src.items")
local ui = require("src.ui")
local function getPlayerAction()
	local validChoice = false
	repeat
		print("\n--- Your Turn ---")
		print("1) Attack")
		print("2) Cast Spell")
		print("3) Use Item")
		print("4) Flee")
		io.write("Enter choice (1-4): ")
		choice = tonumber(io.read())
		if choice == 1 or choice == 2 or choice == 3 or choice == 4 then
			validChoice = true
		else
			print("please choose a valid option(1-4)")
		end
	until validChoice == true
	return choice
end

local function playerAttack(enemy)
	local weapon = items.getItemById(game.player.equippedWeapon)
	if not weapon then
		print("error: equipped weapon not found!!")
		return
	end

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
	-- Get the inventory slot
	local inventorySlot = game.player.inventory[itemIndex]

	if not inventorySlot then
		print("you don't have that item!")
		return
	end

	-- Get the full item data
	local usedItem = items.getItemById(inventorySlot.id)

	if not usedItem then
		print("error: item not found!")
		return
	end

	-- Check if it exists and has quantity
	if inventorySlot.quantity > 0 then
		-- Apply effect based on item ID
		if usedItem.id == "healingpotion" then
			game.player.health = math.min(game.player.health + usedItem.heal, game.player.maxHealth)
			print("used " .. usedItem.name .. ". health restored to " .. game.player.health .. "!")
		end

		-- Decrement and remove if empty
		inventorySlot.quantity = inventorySlot.quantity - 1
		if inventorySlot.quantity == 0 then
			table.remove(game.player.inventory, itemIndex)
		end
	else
		print("you don't have that item!")
	end
end

local function attemptFlee()
	if math.random(1, 100) >= 25 then
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
local function regenMP()
	game.player.mp = math.min(game.player.mp + 2, game.player.maxMP)
end

local function selectTarget(enemies)
	while true do
		-- Display enemies
		print("Choose target:")
		for i, enemy in ipairs(enemies) do
			print(i .. ") " .. enemy.name .. " (" .. enemy.health .. "/" .. enemy.maxHealth .. ")")
		end
		print((#enemies + 1) .. ") return to action menu")

		-- Get target choice
		io.write("Target (1-" .. #enemies + 1 .. "): ")
		local targetIndex = tonumber(io.read())

		-- Validate
		if targetIndex == #enemies + 1 then
			return nil, nil -- Signal: they picked back
		elseif targetIndex and targetIndex >= 1 and targetIndex <= #enemies then
			return targetIndex, enemies[targetIndex]
		else
			print("invalid target!")
		end
	end
end

local function choiceAttack(enemies)
	local targetIndex, target = selectTarget(enemies)
	if target == nil then
		print("returning to action menu.")
		return false
	end
	playerAttack(target)
	if target.health <= 0 then
		awardLoot(target)
		table.remove(enemies, targetIndex)
	end
	return true
end

local function choiceSpell(enemies)
	local spellValid = false
	if game.player.spellCooldown then
		print("you can't cast spells this turn, wait until next turn")
		return false
	else
		repeat
			print("\nselect a spell: ")
			print("\n1) " .. spells.fireball.name .. " - " .. spells.fireball.cost .. "MP")
			print("  " .. spells.fireball.description)
			print("\n2) " .. spells.healing_whisper.name .. " - " .. spells.healing_whisper.cost .. "MP")
			print("  " .. spells.healing_whisper.description)
			print("\n3) return to action menu")

			io.write("spell (1-3): ")
			local spellChoice = tonumber(io.read())

			if spellChoice == 1 then
				if game.player.mp >= 3 then
					local targetIndex, target = selectTarget(enemies)
					if not target or not targetIndex then
						print("error: invalid target!!")
						return false
					end
					spells.castFireball(target)
					game.player.spellCooldown = true
					if target.health <= 0 then
						awardLoot(target)
						table.remove(enemies, targetIndex)
					end
					spellValid = true
				else
					print("not enough MP!")
				end
			elseif spellChoice == 2 then
				if game.player.mp >= 3 then
					spells.castHealingWhisper()
					game.player.spellCooldown = true
					spellValid = true
				else
					print("not enough MP!")
				end
			elseif spellChoice == 3 then
				print("returning to action menu")
				return false
			else
				print("invalid spell!")
			end
		until spellValid == true
	end
	return true
end

local function choiceItem()
	-- Display items
	local inventory = game.player.inventory
	if #inventory == 0 then
		print("you have no items!")
		print("returning to action menu.")
		return false
	end
	print("Select an item:")
	for i, item in ipairs(inventory) do
		local itemData = items.getItemById(item.id)
		if itemData then
			print(i .. ") " .. itemData.name .. " (x" .. item.quantity .. ")")
		end
	end
	print((#inventory + 1) .. ") return to action menu")

	-- Get item choice
	io.write("Item (1-" .. #inventory + 1 .. "): ")
	local itemIndex = tonumber(io.read())
	if itemIndex == #inventory + 1 then
		print("returning to action menu.")
		return false
	end
	-- Validate and use
	useItem(itemIndex)
	return true
end
local function combatLoop(enemies)
	while #enemies > 0 and game.player.health > 0 do
		-- 1. Display state and clear spell spell cooldown
		ui.displayCombatState(enemies)

		-- 2. Get player action (1-4)
		local choice = getPlayerAction()
		local actionFinished = false
		-- 3. Execute action based on choice
		if choice == 1 then
			actionFinished = choiceAttack(enemies)
		elseif choice == 2 then
			actionFinished = choiceSpell(enemies)
		elseif choice == 3 then
			actionFinished = choiceItem()
		elseif choice == 4 then
			if attemptFlee() then
				game.player.health = math.ceil(game.player.health * 1.5)
				return "fled"
			end
			-- If flee fails, just continue to enemy turn
		end

		-- 4. Enemy turn (if enemies remain and action compleated)
		if actionFinished then
			for _, enemy in ipairs(enemies) do
				enemyAttack(enemy)
			end
		end
		if choice ~= 2 then
			game.player.spellCooldown = false
		end

		-- Regen MP every turn
		regenMP()
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
