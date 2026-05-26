local items = {
	weapons = {
		rusty_sword = { name = "Rusty Sword", id = "rustysword", hitChance = 75, damage = 5 },
		bow = { name = "Bow", id = "bow", hitChance = 80, damage = 10 },
		longsword = { name = "Longsword", id = "longsword", hitChance = 95, damage = 15 },
	},
	consumables = {
		healing_potion = { name = "Healing Potion", id = "healingpotion", heal = 15, type = "consumable" },
		arrow = { name = "Arrow", id = "arrow" },
	},
	loot = {
		gold_coin = { name = "Gold Coin", id = "goldcoin" },
	},
}
local function getItemById(itemId)
	for _, v in pairs(items) do
		for _, itemData in pairs(v) do
			if itemData.id == itemId then
				return itemData
			end
		end
	end
	return nil
end

return {
	items,
	getItemById = getItemById,
}
