local gameState = require('game.gameState')
local function rest()
  -- heal 10% current hp
  gameState.player.hp =
    math.min(math.floor(gameState.player.hp * (1 + 10 / 100)), gameState.player.maxHP)
  -- regen 5% of current mp
  gameState.player.mp =
    math.min(math.floor(gameState.player.mp * (1 + 5 / 100)), gameState.player.maxMP)
  -- display the results
  print(
    'resting restored your HP to: '
      .. gameState.player.hp
      .. ', and your MP to: '
      .. gameState.player.mp
  )
end

return {
  rest = rest,
}
