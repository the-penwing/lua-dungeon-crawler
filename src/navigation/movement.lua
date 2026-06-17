local rooms = require('navigation.rooms')
local gameState = require('game.gameState')
local ui = require('ui.ui-funcs')
local combat = require('combat')
local function nextRoom()
  if rooms[gameState.player.currentRoom + 1] then
    gameState.player.currentRoom = gameState.player.currentRoom + 1
    local currentRoom = gameState.player.currentRoom
    print('You move to the next room...')
    ui.displayRoomDescription()
    if #rooms[currentRoom].enemies > 0 then
      combat.loop.combatLoop(rooms[gameState.player.currentRoom].enemies)
      return true
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
  if rooms[gameState.player.currentRoom - 1] then
    gameState.player.currentRoom = gameState.player.currentRoom - 1
    local currentRoom = gameState.player.currentRoom
    print('You move back to the previous room...')
    ui.displayRoomDescription()
    if #rooms[currentRoom].enemies > 0 then
      combat.loop.combatLoop(rooms[gameState.player.currentRoom].enemies)
      return true
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
