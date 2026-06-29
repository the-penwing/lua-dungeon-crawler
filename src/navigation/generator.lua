local gameState = require('game.gameState')
local function generateDungeon()
  local restoreSeed = math.random(1, 1000000)
  math.randomseed(gameState.dungeonSeed)
  local cx, cy = 1, 1
  local roomsPlaced = 1
  local totalRooms = 6
  local directions = {
    [1] = 'north',
    [2] = 'south',
    [3] = 'east',
    [4] = 'west',
  }
  local directionsData = {
    north = { dx = 0, dy = 1, opposite = 'south' },
    south = { dx = 0, dy = -1, opposite = 'north' },
    east = { dx = 1, dy = 0, opposite = 'west' },
    west = { dx = -1, dy = 0, opposite = 'east' },
  }
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
  while roomsPlaced < totalRooms do
    local randomDirection = math.random(1, 4)
    local dirString = directions[randomDirection]
    local info = directionsData[dirString]

    local tx = cx + info.dx
    local ty = cy + info.dy
    local currentKey = cx .. ',' .. cy
    local targetKey = tx .. ',' .. ty

    if not dungeonMap[targetKey] then
      dungeonMap[targetKey] = {
        isCleared = false,
        enemies = {},
        loot = {},
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
