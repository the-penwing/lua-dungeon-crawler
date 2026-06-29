-- src/navigation/generator.lua
-- Replace your current navigation.generator module definition with this corrected version:
local gameState = require('game.gameState')
local enemyDb = require('game.enemies')

local enemyPool = { 'bat', 'goblin', 'skeleton' }

local lootPool = {
  { id = 'healingpotion', chance = 40, maxQty = 2 },
  { id = 'arrow', chance = 50, maxQty = 5 },
  { id = 'goldcoin', chance = 60, maxQty = 15 },
}

local function generateDungeon()
  local restoreSeed = math.random(1, 1000000)
  math.randomseed(gameState.dungeonSeed)

  local cx, cy = 1, 1
  local roomsPlaced = 1
  local totalRooms = 6

  local directions = { [1] = 'north', [2] = 'south', [3] = 'east', [4] = 'west' }
  local directionsData = {
    north = { dx = 0, dy = 1, opposite = 'south' },
    south = { dx = 0, dy = -1, opposite = 'north' },
    east = { dx = 1, dy = 0, opposite = 'west' },
    west = { dx = -1, dy = 0, opposite = 'east' },
  }

  local dungeonMap = {}

  -- Starting safe zone room
  dungeonMap['1,1'] = {
    name = 'Starting Room',
    isCleared = true,
    enemies = {},
    loot = {
      { id = 'rustysword', quantity = 1 },
      { id = 'bow', quantity = 1 },
      { id = 'arrow', quantity = 5 },
      { id = 'healingpotion', quantity = 1 },
    },
    exits = {},
  }

  while roomsPlaced < totalRooms do
    local randomDirection = math.random(1, 4)
    local dirString = directions[randomDirection]
    local info = directionsData[dirString]

    local tx = cx + info.dx
    local ty = cy + info.dy
    local currentKey = cx .. ',' .. cy
    local targetKey = tx .. ',' .. ty

    if not dungeonMap[targetKey] then
      local spawnedEnemies = {}
      local spawnedLoot = {}
      local roomName = 'Dark Chamber'

      -- If this is the final room being generated, make it the Boss Lair!
      if roomsPlaced == totalRooms - 1 then
        roomName = "The Dragon's Lair"
        table.insert(spawnedEnemies, {
          id = 'dragon', -- Added explicit ID for tracking
          name = enemyDb.dragon.name,
          hp = enemyDb.dragon.maxHealth,
          maxHealth = enemyDb.dragon.maxHealth,
          damage = enemyDb.dragon.damage, -- This is a table {small=5, big=15}
          hitChance = enemyDb.dragon.hitChance,
          loot = enemyDb.dragon.loot,
          attackPhase = 0, -- Needed for special combat mechanics
        })
      else
        -- Regular mob spawn logic
        if math.random(1, 100) <= 75 then
          local enemyId = enemyPool[math.random(1, #enemyPool)]
          local enemyTemplate = enemyDb[enemyId]

          table.insert(spawnedEnemies, {
            id = enemyId,
            name = enemyTemplate.name,
            hp = enemyTemplate.maxHealth,
            maxHealth = enemyTemplate.maxHealth,
            damage = enemyTemplate.damage,
            hitChance = enemyTemplate.hitChance,
            loot = enemyTemplate.loot,
          })
        end

        -- Regular loot generation logic using lootPool
        for _, item in ipairs(lootPool) do
          if math.random(1, 100) <= item.chance then
            local qty = math.random(1, item.maxQty)
            table.insert(spawnedLoot, { id = item.id, quantity = qty })
          end
        end
      end

      dungeonMap[targetKey] = {
        name = roomName,
        isCleared = (#spawnedEnemies == 0),
        enemies = spawnedEnemies,
        loot = spawnedLoot,
        exits = {},
      }
      roomsPlaced = roomsPlaced + 1

      dungeonMap[currentKey].exits[dirString] = targetKey
      local oppString = info.opposite
      dungeonMap[targetKey].exits[oppString] = currentKey
    end
    cx = tx
    cy = ty
  end

  math.randomseed(restoreSeed)
  gameState.dungeonMap = dungeonMap
end

return {
  generateDungeon = generateDungeon,
}
