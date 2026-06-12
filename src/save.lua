local game = require('src.game')
local json = require('src.libs.json')

local function saveGame(filename)
  local gameState = json.encode(game.player)
  local saveFile = io.open('src/data/' .. filename, 'w')
  if saveFile then
    saveFile:write(gameState)
    saveFile:close()
  else
    print('error: failed to save game!!')
  end
  -- TODO: Serialize game.player to JSON and write to file
  -- Use json.encode() to convert table to string
  -- Use io.open() + file:write() to save
end

local function loadGame(filename)
  local saveFile = io.open('src/data/' .. filename, 'r')
  if saveFile then
    local gameState = json.decode(saveFile:read('*a'))
    game.player = gameState
    return gameState
  else
    print('error: failed to load game!!')
    return nil
  end
  -- TODO: Read file, parse JSON, return player state
  -- Use io.open() + file:read("*a") to load
  -- Use json.decode() to convert string to table
  -- Handle errors gracefully (missing file, corrupt JSON)
end

return {
  saveGame = saveGame,
  loadGame = loadGame,
}
