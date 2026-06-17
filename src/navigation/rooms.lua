local enemies = require('enemies')

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
    enemies = {
      createEnemy(enemies.bat),
      createEnemy(enemies.bat),
      createEnemy(enemies.goblin),
    },
    loot = {},
    exits = { east = 3 },
  },
  [3] = {
    description = 'A medium-sized room.',
    enemies = {
      createEnemy(enemies.goblin),
      createEnemy(enemies.skeleton),
    },
    loot = {
      { name = 'healingpotion', quantity = 2 },
      { name = 'goldcoin', quantity = 5 },
    },
    exits = { east = 4 },
  },
  [4] = {
    description = 'A large room.',
    enemies = {
      createEnemy(enemies.dragon),
    },
    loot = {
      { name = 'healingpotion', quantity = 1 },
      { name = 'arrow', quantity = 15 },
    },
    exits = nil,
  },
}

return rooms
