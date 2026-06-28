local gameState = require('game.gameState')
local json = require('libs.json')

local function saveGame(filename)
  -- Create a clean snapshot of the game data fields we want to persist
  local saveData = {
    player = gameState.player,
    bossBeat = gameState.bossBeat,
    playerAlive = gameState.playerAlive,
  }

  local encodedData = json.encode(saveData)
  local saveFile = io.open(filename, 'w')

  if saveFile then
    saveFile:write(encodedData)
    saveFile:close()
    print('Game saved successfully!')
  else
    print('Error: Failed to save game!')
  end
end
local function loadGame(filename)
  local saveFile = io.open(filename, 'r')

  if saveFile then
    local decodedData = json.decode(saveFile:read('*a'))
    saveFile:close()

    -- Safely restore the state pieces individually
    if decodedData then
      gameState.player = decodedData.player or gameState.player
      gameState.bossBeat = decodedData.bossBeat or false
      gameState.playerAlive = decodedData.playerAlive ~= false -- default to true if missing
    end

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
