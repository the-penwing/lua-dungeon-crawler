local rooms = require('navigation.rooms')
local gameState = require('game.gameState')
local ui = require('ui')
local combat = require('combat')

local function nextRoom()
  local targetRoomIndex = gameState.player.currentRoom + 1

  -- Use loadRoom to dynamically spawn fresh enemies for the target room
  local currentRoomData = rooms.loadRoom(targetRoomIndex)

  if currentRoomData then
    -- Safely update player position now that we verified the room exists
    gameState.player.currentRoom = targetRoomIndex

    print('You move to the next room...')
    ui.display.displayRoomDescription()

    -- Check the freshly populated enemies table
    if #currentRoomData.enemies > 0 then
      local success, result = pcall(function()
        return combat.loop.combatLoop(currentRoomData.enemies)
      end)
      if not success then
        print('COMBAT ERROR: ' .. tostring(result))
        return false
      end
    else
      print('no enemies here.')
      return true
    end
  else
    print("you can't go this way!")
    return false
  end
end

local function prevRoom()
  local targetRoomIndex = gameState.player.currentRoom - 1

  -- Use loadRoom to dynamically spawn fresh enemies for the target room
  local currentRoomData = rooms.loadRoom(targetRoomIndex)

  if currentRoomData then
    -- Safely update player position now that we verified the room exists
    gameState.player.currentRoom = targetRoomIndex

    print('You move back to the previous room...')
    ui.display.displayRoomDescription()

    -- Check the freshly populated enemies table
    if #currentRoomData.enemies > 0 then
      local success, result = pcall(function()
        return combat.loop.combatLoop(currentRoomData.enemies)
      end)
      if not success then
        print('COMBAT ERROR: ' .. tostring(result))
        return false
      end
    else
      print('no enemies here.')
      return true
    end
  else
    print("you can't go this way!")
    return false
  end
end

return {
  nextRoom = nextRoom,
  prevRoom = prevRoom,
}
