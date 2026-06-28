local gameState = require('game.gameState')
local json = require('libs.json')

-- A simple shift key to scramble the data (0-255)
local ENCRYPTION_KEY = 73

-- Scramble by shifting bytes forward (pure math, no bitwise operators)
local function scramble(data)
  local result = {}
  for i = 1, #data do
    local byte = string.byte(data, i)
    byte = (byte + ENCRYPTION_KEY) % 256
    table.insert(result, string.char(byte))
  end
  return table.concat(result)
end

-- Descramble by shifting bytes backward
local function descramble(data)
  local result = {}
  for i = 1, #data do
    local byte = string.byte(data, i)
    -- Adding 256 keeps the expression positive before the modulo calculation
    byte = (byte - ENCRYPTION_KEY + 256) % 256
    table.insert(result, string.char(byte))
  end
  return table.concat(result)
end

local function saveGame(filename)
  local saveData = {
    player = gameState.player,
    bossBeat = gameState.bossBeat,
    playerAlive = gameState.playerAlive,
  }

  local encodedData = json.encode(saveData)
  local secureData = scramble(encodedData)

  -- 'wb' ensures binary safety across platform writes
  local saveFile = io.open(filename, 'wb')
  if saveFile then
    saveFile:write(secureData)
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
    local secureData = saveFile:read('*a')
    saveFile:close()

    local rawJson = descramble(secureData)

    -- Protects against parser crashes if the file was modified/corrupted
    local success, decodedData = pcall(json.decode, rawJson)
    if not success or not decodedData then
      print('Error: Corrupt or manipulated save file!')
      return nil
    end

    local itemFuncs = require('items.funcs')

    -- Enforce legal limits and sanity check fields
    if decodedData and decodedData.player then
      local p = decodedData.player

      p.maxHP = p.maxHP or 100
      p.maxMP = p.maxMP or 20
      p.hp = math.min(tonumber(p.hp) or p.maxHP, p.maxHP)
      p.mp = math.min(tonumber(p.mp) or p.maxMP, p.maxMP)

      if p.currentRoom and (p.currentRoom < 1 or p.currentRoom > 4) then
        p.currentRoom = 1
      end

      -- Verify items exist and clip unearned stack limits
      local sanitizedInventory = {}
      if type(p.inventory) == 'table' then
        for _, invItem in ipairs(p.inventory) do
          local officialItem = itemFuncs.getItemById(invItem.id)
          if officialItem then
            local qty = tonumber(invItem.quantity) or 1
            if officialItem.type == 'consumable' then
              qty = math.min(qty, 10)
            elseif officialItem.type == 'weapon' then
              qty = 1
            end
            if qty > 0 then
              table.insert(sanitizedInventory, { id = invItem.id, quantity = qty })
            end
          end
        end
      end
      p.inventory = sanitizedInventory

      if not itemFuncs.getItemById(p.equippedWeapon) then
        p.equippedWeapon = 'rustysword'
      end

      -- Apply values directly to the active state table
      gameState.player = p
      gameState.bossBeat = decodedData.bossBeat or false
      gameState.playerAlive = decodedData.playerAlive ~= false
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
