local gameState = require('game.gameState')
local fileLocation = require('save.fileLocation')
local json = require('libs.json')

local SAVE_FILENAME <const> = 'save.json'

local function saveGame()
  local dir = fileLocation.appDataDir()
  if not dir then
    print('Error: Unknown OS, cannot save!')
    return nil
  end
  fileLocation.ensureDir(dir)
  local filepath = fileLocation.pathJoin(dir, SAVE_FILENAME)
  local saveData = {
    player = gameState.player,
    bossBeat = gameState.bossBeat,
    dungeonSeed = gameState.dungeonSeed,
    dungeonMap = gameState.dungeonMap,
  }

  local encodedData = json.encode(saveData)

  -- 'wb' ensures binary safety across platform writes
  local saveFile = io.open(filepath, 'wb')
  if saveFile then
    saveFile:write(encodedData)
    saveFile:close()
    print('Game saved successfully!')
  else
    print('Error: Failed to save game!')
  end
end

local function loadGame()
  local dir = fileLocation.appDataDir()
  if not dir then
    print('Error: Unknown OS, cannot locate save!')
    return nil
  end
  local filepath = fileLocation.pathJoin(dir, SAVE_FILENAME)
  local saveFile = io.open(filepath, 'rb')

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
