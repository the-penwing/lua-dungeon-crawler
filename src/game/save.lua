local gameState = require('game.gameState')
local json = require('libs.json')

local function saveGame(filename)
  local encodedData = json.encode(gameState.player)
  local saveFile = io.open(filename, 'w')

  if saveFile then
    saveFile:write(encodedData)
    saveFile:close()
  else
    print('Error: Failed to save game!')
  end
end

local function loadGame(filename)
  local saveFile = io.open(filename, 'r')

  if saveFile then
    local loadedData = json.decode(saveFile:read('*a'))
    saveFile:close()
    gameState.player = loadedData
    return gameState
  else
    print('Error: Failed to load game!')
    return nil
  end
end

return {
  saveGame = saveGame,
  loadGame = loadGame,
}
