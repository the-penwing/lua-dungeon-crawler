local gameState = require('game.gameState')
local json = require('libs.json')

local function saveGame(filename)
  local saveData = {
    player = gameState.player,
    bossBeat = gameState.bossBeat,
    dungeonSeed = gameState.dungeonSeed,
    dungeonMap = gameState.dungeonMap,
  }

  local encodedData = json.encode(saveData)

  -- 'wb' ensures binary safety across platform writes
  local saveFile = io.open(filename, 'wb')
  if saveFile then
    saveFile:write(encodedData)
    saveFile:close()
    print('Game saved successfully!')
  else
    print('Error: Failed to save game!')
  end
end

local function loadGame(filename)
  -- 'rb' reads raw bytes exactly as written, completely avoiding trailing garbage bugs
  local saveFile = io.open(filename, 'rb')

  if saveFile then
    local saveData = saveFile:read('*a')
    saveFile:close()

    -- Protects against parser crashes if the file was modified/corrupted
    local success, decodedData = pcall(json.decode, saveData)
    if not success or not decodedData then
      print('Error: Corrupt save file!')
      return nil
    end

    if decodedData and decodedData.player then
      local p = decodedData.player

      -- Apply values directly to the active state table
      gameState.player = p

      -- Fully restore the seed and procedural layout state
      gameState.bossBeat = decodedData.bossBeat or false
      gameState.dungeonSeed = decodedData.dungeonSeed or 69
      gameState.dungeonMap = decodedData.dungeonMap or {}

      return gameState
    else
      print('Error: Corrupt save file!')
      return nil
    end
  else
    print('Error: Failed to load game!')
    return nil
  end
end

return {
  saveGame = saveGame,
  loadGame = loadGame,
}
