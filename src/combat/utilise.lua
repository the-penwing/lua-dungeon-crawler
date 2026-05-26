local game = require("src.game")
local items = require("src.items")

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
	return true
end
local function choiceItem()
	local inventory = game.player.inventory
	if #inventory == 0 then
		print("you have no items!")
		print("returning to action menu.")
		return false
	end

	-- Build consumable-only list
	local consumables = {}
	for i, item in ipairs(inventory) do
		local itemData = items.getItemById(item.id)
		if itemData and itemData.type == "consumable" then
			table.insert(consumables, { index = i, data = item, info = itemData })
		end
	end

	if #consumables == 0 then
		print("you have no consumable items!")
		print("returning to action menu.")
		return false
	end

	print("Select an item:")
	for i, consumable in ipairs(consumables) do
		print(i .. ") " .. consumable.info.name .. " (x" .. consumable.data.quantity .. ")")
	end
	print((#consumables + 1) .. ") return to action menu")

	-- Get item choice
	io.write("Item (1-" .. (#consumables + 1) .. "): ")
	local choice = tonumber(io.read())
	if choice == #consumables + 1 then
		print("returning to action menu.")
		return false
	elseif choice and choice >= 1 and choice <= #consumables then
		useItem(consumables[choice].index)
		return true
	else
		print("invalid choice!")
		return false
	end
end

return {
	choiceItem = choiceItem,
	useItem = useItem,
}
