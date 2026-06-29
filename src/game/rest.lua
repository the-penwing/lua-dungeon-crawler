local gameState = require('game.gameState')
local function rest()
  local hpHealAmt = math.floor(gameState.player.maxHP * 0.10)
  local mpRegenAmt = math.floor(gameState.player.maxMP * 0.05)
  gameState.player.hp = math.min(gameState.player.hp + hpHealAmt, gameState.player.maxHP)
  gameState.player.mp = math.min(gameState.player.mp + mpRegenAmt, gameState.player.maxMP)
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
