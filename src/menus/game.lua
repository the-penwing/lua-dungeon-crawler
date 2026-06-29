local ui = require('ui')
local gameState = require('game.gameState')
local roomsModule = require('navigation.rooms')
local rooms = roomsModule.rooms
local function gameMenu()
  local coords = gameState.player.roomCoordinates
  local currentKey = coords.x .. ',' .. coords.y
  local currentRoom = gameState.dungeonMap[currentKey]
  local roomDescription = currentRoom.name

  print('\n--- ' .. roomDescription .. ' (' .. currentKey .. ') ---\n')
  ui.display.displayGameState()
  print('\nGame Menu:')
  print('  1) Use Item')
  print('  2) Switch Weapon')
  print('  3) Move')
  print('  4) Loot Room')
  print('  5) Rest')
  print('  6) Save and Main Menu')
  local validChoice = false
  local choice
  repeat
    io.write('\nEnter choice (1-6): ')
    io.flush()
    choice = tonumber(io.read('*l'))
    if choice and choice >= 1 and choice <= 6 then
      validChoice = true
    else
      print('Invaild choice!')
      print('Enter 1-6')
    end
  until validChoice == true
  return choice
end

return {
  gameMenu = gameMenu,
}
