local ui = require('ui')
local game = require('game')
local rooms = require('navigation.rooms')
local function gameMenu()
  local currentRoom = game.player.currentRoom
  local roomDescription = rooms[currentRoom].description
  print('--- Room ' .. currentRoom .. ': ' .. roomDescription .. ' ---')
  print()
  ui.displayGameState()
  print('\nGame Menu:')
  print('  1) Use Item')
  print('  2) Switch Weapon')
  print('  3) Next Room')
  print('  4) Prev. Room')
  print('  5) Rest')
  print('  6) Save and Main Menu')
  local validChoice = false
  local choice
  repeat
    io.write('Enter choice (1-6): ')
    choice = tonumber(io.read('*l'))
    if choice >= 1 and choice <= 6 then
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
