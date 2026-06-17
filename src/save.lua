local game = require('game')
local json = require('libs.json')

local function saveGame(filename)
  local gameState = json.encode(game.player)
  local saveFile = io.open('./' .. filename, 'w')
  if saveFile then
    saveFile:write(gameState)
    saveFile:close()
  else
    print('error: failed to save game!!')
  end
end

local function loadGame(filename)
  local saveFile = io.open('./' .. filename, 'r')
  if saveFile then
    local gameState = json.decode(saveFile:read('*a'))
    game.player = gameState
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
