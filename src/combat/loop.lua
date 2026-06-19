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
    -- 1. Display state and clear spell spell cooldown
    require('ui.display').displayCombatState(enemies)

    -- 2. Get player action (1-4)
    local choice = actions.getPlayerAction()
    local actionFinished = false
    -- 3. Execute action based on choice
    if choice == 1 then
      actionFinished = actions.choiceAttack(enemies)
    elseif choice == 2 then
      actionFinished = casting.choiceSpell(enemies)
    elseif choice == 3 then
      actionFinished = utilise.choiceItem()
    elseif choice == 4 then
      if actions.attemptFlee() then
        gameState.player.hp = math.ceil(gameState.player.hp * 1.5)
        return 'fled'
      end
      -- If flee fails, just continue to enemy turn
    end

    -- 4. Enemy turn (if enemies remain and action compleated)
    if actionFinished then
      for _, enemy in ipairs(enemies) do
        enemy_module.enemyAttack(enemy)
      end
    end
    if choice ~= 2 then
      gameState.player.spellCooldown = false
    end

    -- Regen MP every turn
    regenMP()
  end

  -- After loop: check result
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
