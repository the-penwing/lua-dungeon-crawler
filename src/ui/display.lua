local formatting = require('ui.formatting')
local itemFuncs = require('items.funcs')
local gameState = require('game.gameState')

local function displayGameState()
  local equippedWeapon = itemFuncs.getItemById(gameState.player.activeEquipment.weapon)
  local equippedArmor = itemFuncs.getItemById(gameState.player.activeEquipment.armor)
  print('Player Stats:')
  if gameState.player.hp > 0 then
    print('  Health: ' .. gameState.player.hp .. '/' .. gameState.player.maxHP)
    print('  MP: ' .. gameState.player.mp .. '/' .. gameState.player.maxMP)
    print('  Equipped Weapon: ' .. (equippedWeapon and equippedWeapon.name or 'None'))
    print('  Equipped Armor: ' .. (equippedArmor and equippedArmor.name or 'None'))
    print('  Inventory: ' .. formatting.formatInventory(gameState.player.inventory))
  else
    print('You have died')
  end
  print('\nGame Stats:')
  if gameState.bossBeat == false then
    print('  Boss Dead: Not yet')
  else
    print('  Boss Dead: Yes, Great Work!!')
  end
end

local function displayRoomDescription()
  local coords = gameState.player.roomCoordinates
  local currentKey = coords.x .. ',' .. coords.y
  print(gameState.dungeonMap[currentKey].name)
end

local function displayEnemies(enemies)
  if #enemies > 0 then
    print('Enemies:')
    print(formatting.formatEnemies(enemies))
  else
    print('No enemies here.')
  end
end

local function displayCombatState(enemies)
  local equippedWeapon = itemFuncs.getItemById(gameState.player.activeEquipment.weapon)
  local equippedArmor = itemFuncs.getItemById(gameState.player.activeEquipment.armor)
  print('Player Stats:')
  print('  Health: ' .. gameState.player.hp .. '/' .. gameState.player.maxHP)
  print('  MP: ' .. gameState.player.mp .. '/' .. gameState.player.maxMP)
  print('  Equipped Weapon: ' .. (equippedWeapon and equippedWeapon.name or 'None'))
  print('  Equipped Armor: ' .. (equippedArmor and equippedArmor.name or 'None'))
  displayEnemies(enemies)
end

return {
  displayCombatState = displayCombatState,
  displayEnemies = displayEnemies,
  displayGameState = displayGameState,
  displayRoomDescription = displayRoomDescription,
}
