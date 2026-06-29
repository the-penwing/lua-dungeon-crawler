local gameState = require('game.gameState')
local enemyDb = require('game.enemies')

local enemyPool = { 'bat', 'goblin', 'skeleton' }

local lootPool = {
  { id = 'healingpotion', chance = 40, maxQty = 2 },
  { id = 'arrow', chance = 50, maxQty = 5 },
  { id = 'goldcoin', chance = 60, maxQty = 15 },
}

local function generateDungeon()
  local dungeonMap = {}
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
  local cx, cy = 1, 1
  local history = { { x = 1, y = 1 } }
  local roomsPlaced = 1
  local totalRooms = 10
  local directionsData = {
    north = { dx = 0, dy = 1, opposite = 'south' },
    south = { dx = 0, dy = -1, opposite = 'north' },
    east = { dx = 1, dy = 0, opposite = 'west' },
    west = { dx = -1, dy = 0, opposite = 'east' },
  }
  local dirKeys = { 'north', 'south', 'east', 'west' }

  while roomsPlaced < totalRooms do
    local currentKey = cx .. ',' .. cy
    local validExits = {}

    for _, dir in ipairs(dirKeys) do
      local info = directionsData[dir]
      local tx = cx + info.dx
      local ty = cy + info.dy
      local targetKey = tx .. ',' .. ty

      if not dungeonMap[targetKey] then
        table.insert(validExits, { dir = dir, x = tx, y = ty, key = targetKey })
      end
    end

    if #validExits > 0 then
      local choice = validExits[math.random(1, #validExits)]

      local spawnedEnemies = {}
      local spawnedLoot = {}
      local roomName = 'Dark Chamber'

      if roomsPlaced == totalRooms - 1 then
        roomName = "The Dragon's Lair"
        table.insert(spawnedEnemies, {
          id = 'dragon',
          name = enemyDb.dragon.name,
          hp = enemyDb.dragon.maxHealth,
          maxHealth = enemyDb.dragon.maxHealth,
          damage = enemyDb.dragon.damage,
          hitChance = enemyDb.dragon.hitChance,
          loot = enemyDb.dragon.loot,
          attackPhase = 0,
        })
      else
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

        for _, item in ipairs(lootPool) do
          if math.random(1, 100) <= item.chance then
            local qty = math.random(1, item.maxQty)
            table.insert(spawnedLoot, { id = item.id, quantity = qty })
          end
        end
      end

      dungeonMap[choice.key] = {
        name = roomName,
        isCleared = (#spawnedEnemies == 0),
        enemies = spawnedEnemies,
        loot = spawnedLoot,
        exits = {},
      }

      dungeonMap[currentKey].exits[choice.dir] = choice.key
      dungeonMap[choice.key].exits[directionsData[choice.dir].opposite] = currentKey

      cx = choice.x
      cy = choice.y
      table.insert(history, { x = cx, y = cy })
      roomsPlaced = roomsPlaced + 1
    else
      if #history > 1 then
        table.remove(history)
        local backtrackNode = history[#history]
        cx = backtrackNode.x
        cy = backtrackNode.y
      else
        break
      end
    end
  end

  gameState.dungeonMap = dungeonMap
end

return {
  generateDungeon = generateDungeon,
}
