local game = require('game')
local items = require('items')
local function clear()
  if os.getenv('OS') == 'Windows_NT' then
    os.execute('cls')
  else
    os.execute('clear')
  end
end
local function formatInventory(inventory)
  local inventoryItems = {}
  for _, item in ipairs(inventory) do
    local itemData = items.funcs.getItemById(item.id)
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
local function displayGameState()
  print('Player Stats:')
  if game.player.hp > 0 then
    print('  Health: ' .. game.player.hp .. '/' .. game.player.maxHP)
    print('  MP: ' .. game.player.mp .. '/' .. game.player.maxMP)
    print('  Equipped Weapon: ' .. items.funcs.getItemById(game.player.equippedWeapon).name)
    print('  Inventory: ' .. formatInventory(game.player.inventory))
  else
    print('You have died')
  end
  print('\nGame Stats:')
  if game.bossBeat == false then
    print('  Boss Dead: Not yet')
  else
    print('  Boss Dead: Yes, Great Work!!')
  end
end

local function displayRoomDescription()
  print(game.rooms[game.player.currentRoom].description)
end

local function displayEnemies(enemies)
  if #enemies > 0 then
    print('Enemies:')
    print(formatEnemies(enemies))
  else
    print('No enemies here.')
  end
end

local function displayCombatState(enemies)
  print('Player Stats:')
  print('  Health: ' .. game.player.hp .. '/' .. game.player.maxHP)
  print('  MP: ' .. game.player.mp .. '/' .. game.player.maxMP)
  print('  Equipped Weapon: ' .. items.funcs.getItemById(game.player.equippedWeapon).name)
  displayEnemies(enemies)
end

return {
  displayGameState = displayGameState,
  displayRoomDescription = displayRoomDescription,
  displayEnemies = displayEnemies,
  formatInventory = formatInventory,
  displayCombatState = displayCombatState,
  clear = clear,
}
