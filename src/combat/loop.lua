local gameState = require('game.gameState')
local actions = require('combat.actions')
local casting = require('combat.casting')
local utilise = require('combat.utilise')
local enemy_module = require('combat.enemy')

local function regenMP()
  gameState.player.mp = math.min(gameState.player.mp + 2, gameState.player.maxMP)
end

local function combatLoop(enemies)
  while #enemies > 0 and gameState.player.hp > 0 do
    require('ui.display').displayCombatState(enemies)

    local choice = actions.getPlayerAction()
    local actionFinished = false

    if choice == 1 then
      actionFinished = actions.choiceAttack(enemies)
    elseif choice == 2 then
      actionFinished = casting.choiceSpell(enemies)
    elseif choice == 3 then
      actionFinished = utilise.choiceItem()
    elseif choice == 4 then
      if actions.attemptFlee() then
        local penalty = math.floor(gameState.player.hp * 0.20)
        gameState.player.hp = math.max(1, gameState.player.hp - penalty)
        print('You escaped with your life but lost ' .. penalty .. ' HP running away!')

        gameState.player.roomCoordinates = { x = 1, y = 1 }
        return 'fled'
      end
    end

    if actionFinished then
      for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        if enemy.hp > 0 then
          enemy_module.enemyAttack(enemy)
        end
      end
    end

    if choice ~= 2 then
      gameState.player.spellCooldown = false
    end

    regenMP()
  end

  if gameState.player.hp <= 0 then
    return false
  else
    return true
  end
end

return {
  regenMP = regenMP,
  combatLoop = combatLoop,
}
