local gameState = require('game.gameState')
local json = require('libs.json')

local function saveGame(filename)
  local gameState = json.encode(gameState.player)
  local saveFile = io.open(filename, 'w')
  if saveFile then
    saveFile:write(gameState)
    saveFile:close()
  else
    print('error: failed to save game!!')
  end
end

local function loadGame(filename)
  local saveFile = io.open(filename, 'r')
  if saveFile then
    local gameState = json.decode(saveFile:read('*a'))
    gameState.player = gameState
    return gameState
  else
    print('error: failed to load game!!')
    return nil
  end
end

return {
  saveGame = saveGame,
  loadGame = loadGame,
}
