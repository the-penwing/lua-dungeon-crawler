local enemies = require('game.enemies')

-- Helper function to create an enemy instance
local function createEnemy(enemyTemplate)
  return {
    name = enemyTemplate.name,
    health = enemyTemplate.maxHealth,
    maxHealth = enemyTemplate.maxHealth,
    damage = enemyTemplate.damage,
    hitChance = enemyTemplate.hitChance,
    loot = enemyTemplate.loot,
    attackPhase = enemyTemplate.attackPhase or 0,
  }
end

local rooms = {
  [1] = {
    description = 'A dark smelly stone hall.',
    enemies = {},
    loot = {
      { name = 'rustysword', quantity = 1 },
      { name = 'bow', quantity = 1 },
      { name = 'arrow', quantity = 5 },
      { name = 'healingpotion', quantity = 1 },
    },
    exits = { north = 2 },
  },
  [2] = {
    description = 'A small square room.',
    enemyTemplates = { enemies.bat, enemies.bat, enemies.goblin },
    enemies = {},
    loot = {},
    exits = { east = 3 },
  },
  [3] = {
    description = 'A medium-sized room.',
    enemyTemplates = { enemies.goblin, enemies.skeleton },
    enemies = {},
    loot = {
      { name = 'healingpotion', quantity = 2 },
      { name = 'goldcoin', quantity = 5 },
    },
    exits = { east = 4 },
  },
  [4] = {
    description = 'A large room.',
    enemyTemplates = { enemies.dragon },
    enemies = {},
    loot = {
      { name = 'healingpotion', quantity = 1 },
      { name = 'arrow', quantity = 15 },
    },
    exits = nil,
  },
}

local function loadRoom(roomNum)
  local room = rooms[roomNum]
  if room and room.enemyTemplates then
    room.enemies = {}
    for _, template in ipairs(room.enemyTemplates) do
      table.insert(room.enemies, createEnemy(template))
    end
  end
  return room
end

return {
  rooms = rooms,
  loadRoom = loadRoom,
}
