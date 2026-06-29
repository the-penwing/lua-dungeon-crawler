local gameState = {
  player = {
    hp = 100,
    maxHP = 100,
    mp = 20,
    maxMP = 20,
    spellCooldown = false,
    roomCoordinates = { x = 1, y = 1 },
    activeEquipment = {
      weapon = 'rustysword',
      armor = 'none',
    },
    inventory = {
      { id = 'rustysword', quantity = 1 },
      { id = 'healingpotion', quantity = 1 },
    },
    bossBeat = false,
    playerAlive = true,
  },
  dungeonSeed = 69, -- Store Raw integer Seed for Dungeon Generation
  dungeonMap = {}, -- Auto Generated Dungeon Based on Seed
}

return gameState
