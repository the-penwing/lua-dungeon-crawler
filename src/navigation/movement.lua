local rooms = require('navigation.rooms')
local game = require('game')
local ui = require('ui.ui-funcs')
local combat = require('combat')
local function nextRoom()
  if rooms[game.player.currentRoom + 1] then
    game.player.currentRoom = game.player.currentRoom + 1
    local currentRoom = game.player.currentRoom
    print('You move to the next room...')
    ui.displayRoomDescription()
    if #rooms[currentRoom].enemies > 0 then
      combat.loop.combatLoop(rooms[game.player.currentRoom].enemies)
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
  if rooms[game.player.currentRoom - 1] then
    game.player.currentRoom = game.player.currentRoom - 1
    local currentRoom = game.player.currentRoom
    print('You move back to the previous room...')
    ui.displayRoomDescription()
    if #rooms[currentRoom].enemies > 0 then
      combat.loop.combatLoop(rooms[game.player.currentRoom].enemies)
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
