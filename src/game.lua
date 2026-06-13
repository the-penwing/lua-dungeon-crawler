local rooms = require('src.navigation.rooms')

local game = {
  player = {
    hp = 100,
    maxHP = 100,
    mp = 20,
    maxMP = 20,
    spellCooldown = false,
    currentRoom = 1,
    equippedWeapon = 'rustysword',
    inventory = {
      { id = 'rustysword', quantity = 1 },
      { id = 'healingpotion', quantity = 1 },
    },
  },
  rooms = rooms,
  bossBeat = false,
  playerAlive = true,
}

return game
