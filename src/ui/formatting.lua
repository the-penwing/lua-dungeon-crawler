local function formatInventory(inventory)
  local inventoryItems = {}
  for _, item in ipairs(inventory) do
    local itemData = require('items.funcs').getItemById(item.id)
    if itemData then
      table.insert(inventoryItems, itemData.name .. ' (x' .. item.quantity .. ')')
    end
  end
  return table.concat(inventoryItems, ', ')
end
local function formatEnemies(enemies)
  local opponents = {}
  for _, opponent in ipairs(enemies) do
    table.insert(opponents, opponent.name .. ' ' .. opponent.health .. '/' .. opponent.maxHealth)
  end
  return table.concat(opponents, '\n')
end

return {
  formatEnemies = formatEnemies,
  formatInventory = formatInventory,
}
