local game = require('game')
local magic = require('combat.magic')
local enemy_module = require('combat.enemy')
local targeting = require('combat.targeting')

local function castFireball(target)
  if game.player.mp < 3 then
    print("you don't have enough MP to cast fireball.")
    return false
  end
  game.player.mp = game.player.mp - 3

  target.health = target.health - 20
  print('fireball was a success!!')
  if math.random(1, 100) <= 5 then
    print('but you got burned!!')
    local selfDamage = math.floor(game.player.hp * 0.05)
    game.player.hp = game.player.hp - selfDamage
    print('you took ' .. selfDamage .. ' damage from the backfire!')
  end
  return true
end

local function castHealingWhisper()
  if game.player.mp < 3 then
    print("you don't have enough MP to cast healing whisper.")
    return false
  end
  game.player.mp = game.player.mp - 3

  local oldHealth = game.player.hp
  game.player.hp = math.min(game.player.hp + 20, game.player.maxHP)
  local healedAmount = game.player.hp - oldHealth

  print('you healed ' .. healedAmount .. ' HP')
  print('healing whisper was a success!!')
  return true
end
local function choiceSpell(enemies)
  local spellValid = false
  if game.player.spellCooldown then
    print("you can't cast spells this turn, wait until next turn")
    return false
  else
    repeat
      print('\nselect a spell: ')
      print('\n1) ' .. magic.fireball.name .. ' - ' .. magic.fireball.cost .. 'MP')
      print('  ' .. magic.fireball.description)
      print('\n2) ' .. magic.healing_whisper.name .. ' - ' .. magic.healing_whisper.cost .. 'MP')
      print('  ' .. magic.healing_whisper.description)
      print('\n3) return to action menu')

      io.write('spell (1-3): ')
      local spellChoice = tonumber(io.read('*l'))

      if spellChoice == 1 then
        if game.player.mp >= 3 then
          local targetIndex, target = targeting.selectTarget(enemies)
          if not target or not targetIndex then
            print('error: invalid target!!')
            return false
          end
          castFireball(target)
          game.player.spellCooldown = true
          if target.health <= 0 then
            enemy_module.awardLoot(target)
            table.remove(enemies, targetIndex)
          end
          spellValid = true
        else
          print('not enough MP!')
        end
      elseif spellChoice == 2 then
        if game.player.mp >= 3 then
          castHealingWhisper()
          game.player.spellCooldown = true
          spellValid = true
        else
          print('not enough MP!')
        end
      elseif spellChoice == 3 then
        print('returning to action menu')
        return false
      else
        print('invalid spell!')
      end
    until spellValid == true
  end
  return true
end

return {
  castFireball = castFireball,
  castHealingWhisper = castHealingWhisper,
  choiceSpell = choiceSpell,
}
