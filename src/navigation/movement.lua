local gameState = require('game.gameState')
local ui = require('ui')
local combat = require('combat')

local function moveDirection(direction)
  local coords = gameState.player.roomCoordinates
  local currentKey = coords.x .. ',' .. coords.y
  local currentRoomData = gameState.dungeonMap[currentKey]

  if not currentRoomData.exits or not currentRoomData.exits[direction] then
    print("You can't go that way!")
    return false
  end

  -- The exit value itself contains the target coordinate string (e.g., "1,2")
  local targetKey = currentRoomData.exits[direction]

  -- Extract x and y from the "x,y" string to move the player's position
  local tx, ty = targetKey:match('([^,]+),([^,]+)')
  gameState.player.roomCoordinates.x = tonumber(tx)
  gameState.player.roomCoordinates.y = tonumber(ty)

  -- Fetch our newly stepped-into dynamic room node
  local targetRoomData = gameState.dungeonMap[targetKey]

  if targetRoomData then
    print('\nYou move ' .. direction .. '...')

    -- Display description (adjust if displayRoomDescription expects old indices)
    if ui.display.displayRoomDescription then
      ui.display.displayRoomDescription()
    else
      print('Location: ' .. targetRoomData.name)
    end

    -- Trigger combat if the room isn't cleared and has live enemies
    if not targetRoomData.isCleared and #targetRoomData.enemies > 0 then
      local success, result = pcall(function()
        return combat.loop.combatLoop(targetRoomData.enemies)
      end)

      if not success then
        print('COMBAT ERROR: ' .. tostring(result))
        return false
      end

      -- If combat concludes successfully, mark room cleared
      if result == true then
        targetRoomData.isCleared = true
      end
      return result
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
