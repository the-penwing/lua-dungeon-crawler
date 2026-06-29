local roomsModule = require('navigation.rooms')
local rooms = roomsModule.rooms

local gameState = {
  player = {
    hp = 100,
    maxHP = 100,
    mp = 20,
    maxMP = 20,
    spellCooldown = false,
    currentRoom = 1,
    activeEquipment = {
      weapon = 'rustysword',
      armor = 'none',
    },
    inventory = {
      { id = 'rustysword', quantity = 1 },
      { id = 'healingpotion', quantity = 1 },
    },
  },
  rooms = rooms,
  bossBeat = false,
  playerAlive = true,
}

return gameState
