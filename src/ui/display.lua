local gameState = require('game.gameState')

local function displayGameState()
  print('Player Stats:')
  if gameState.player.hp > 0 then
    print('  Health: ' .. gameState.player.hp .. '/' .. gameState.player.maxHP)
    print('  MP: ' .. gameState.player.mp .. '/' .. gameState.player.maxMP)
    print(
      '  Equipped Weapon: '
        .. require('items.funcs').getItemById(gameState.player.equippedWeapon).name
    )
    print('  Inventory: ' .. require('ui.formatting').formatInventory(gameState.player.inventory))
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
  print(gameState.rooms[gameState.player.currentRoom].description)
end

local function displayEnemies(enemies)
  if #enemies > 0 then
    print('Enemies:')
    print(require('ui.formatting').formatEnemies(enemies))
  else
    print('No enemies here.')
  end
end

local function displayCombatState(enemies)
  print('Player Stats:')
  print('  Health: ' .. gameState.player.hp .. '/' .. gameState.player.maxHP)
  print('  MP: ' .. gameState.player.mp .. '/' .. gameState.player.maxMP)
  print(
    '  Equipped Weapon: '
      .. require('items.funcs').getItemById(gameState.player.equippedWeapon).name
  )
  displayEnemies(enemies)
end

return {
  displayCombatState = displayCombatState,
  displayEnemies = displayEnemies,
  displayGameState = displayGameState,
  displayRoomDescription = displayRoomDescription,
}
