local gameState = require('game.gameState')
local items = require('items')
local targeting = require('combat.targeting')
local enemy_module = require('combat.enemy')

local function getPlayerAction()
  local validChoice = false
  local choice
  repeat
    print('\n--- Your Turn ---')
    print('1) Attack')
    print('2) Cast Spell')
    print('3) Use Item')
    print('4) Flee')
    io.write('Enter choice (1-4): ')
    choice = tonumber(io.read('*l'))
    if choice == 1 or choice == 2 or choice == 3 or choice == 4 then
      validChoice = true
    else
      print('please choose a valid option(1-4)')
    end
  until validChoice == true
  return choice
end

local function playerAttack(enemy)
  local weapon = items.funcs.getItemById(gameState.player.equippedWeapon)
  if not weapon then
    print('error: equipped weapon not found!!')
    return
  end

  local damage = weapon.damage
  local hitChance = weapon.hitChance

  if math.random(1, 100) <= hitChance then
    enemy.health = enemy.health - damage
    print('You hit ' .. enemy.name .. ' for ' .. damage .. ' damage!')
  else
    print('Attack Missed!!')
  end
end

local function choiceAttack(enemies)
  local targetIndex, target = targeting.selectTarget(enemies)
  if target == nil then
    print('returning to action menu.')
    return false
  end
  playerAttack(target)
  if target.health <= 0 then
    enemy_module.awardLoot(target)
    table.remove(enemies, targetIndex)
  end
  return true
end
local function attemptFlee()
  if math.random(1, 100) >= 25 then
    print('You fled successfully')
    return true
  else
    print('uh oh, you failed to flee')
    return false
  end
end

return {
  getPlayerAction = getPlayerAction,
  playerAttack = playerAttack,
  choiceAttack = choiceAttack,
  attemptFlee = attemptFlee,
}
