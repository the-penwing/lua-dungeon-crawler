local rooms = require('navigation.rooms')
local gameState = require('game.gameState')
local ui = require('ui')
local combat = require('combat')

local function moveDirection(direction)
  local currentRoomNum = gameState.player.currentRoom
  local currentRoomData = rooms.rooms[currentRoomNum]

  if not currentRoomData.exits or not currentRoomData.exits[direction] then
    print("\nYou can't go " .. direction .. ' from here!')
    return false
  end
  local targetRoomIndex = currentRoomData.exits[direction]
  local targetRoomData = rooms.loadRoom(targetRoomIndex)

  if targetRoomData then
    gameState.player.currentRoom = targetRoomIndex

    print('\nYou move ' .. direction .. '...')
    ui.display.displayRoomDescription()
    if #targetRoomData.enemies > 0 then
      local success, result = pcall(function()
        return combat.loop.combatLoop(targetRoomData.enemies)
      end)
      if not success then
        print('COMBAT ERROR: ' .. tostring(result))
        return false
      end
    else
      print('No enemies here.')
      return true
    end
  else
    print('Error: Target room layout missing!')
    return false
  end
end

local function navMenu()
  local validChoice = false
  local actionResult = false

  repeat
    print('\nWhich Direction?')
    print('  1) North')
    print('  2) South')
    print('  3) East')
    print('  4) West')
    print('  5) Back')
    io.write('Direction (1-5): ')
    io.flush()

    local dirChoice = tonumber(io.read('*l'))

    if dirChoice == 5 then
      print('Returning to game menu.')
      validChoice = true
      actionResult = false
    elseif dirChoice and dirChoice >= 1 and dirChoice <= 4 then
      local directions = {
        [1] = 'north',
        [2] = 'south',
        [3] = 'east',
        [4] = 'west',
      }
      local choosenDir = directions[dirChoice]
      actionResult = moveDirection(choosenDir)
      validChoice = true
    else
      print('Invalid choice! Enter 1-5.')
    end
  until validChoice == true
  return actionResult
end

return {
  moveDirection = moveDirection,
  navMenu = navMenu,
}
