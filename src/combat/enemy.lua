local gameState = require('game.gameState')

local function enemyAttack(enemy)
  if math.random(1, 100) <= enemy.hitChance then
    local damage
    if enemy.name == 'Dragon' then
      if enemy.attackPhase < 3 then
        damage = enemy.damage.small
      else
        damage = enemy.damage.big
      end
    else
      damage = enemy.damage
    end

    gameState.player.hp = gameState.player.hp - damage
    print('ouch, ' .. enemy.name .. ' did ' .. damage .. ' to you')
  else
    print(enemy.name .. "'s attack missed!")
  end

  if enemy.name == 'Dragon' then
    enemy.attackPhase = (enemy.attackPhase + 1) % 4
  end

  if gameState.player.hp <= 0 then
    gameState.playerAlive = false
    print('oh snap, that blow killed you.')
  end
end

local function handleEnemyDeath(enemyIndex, enemyList)
  local enemy = enemyList[enemyIndex]
  print(enemy.name .. ' was slain!')

  -- Matches both generated 'dragon' IDs and fallback conditions
  if enemy.id == 'dragon' or enemy.name == 'Dragon' then
    gameState.bossBeat = true
    print('\nCongratulations adventurer you have slain the Dragon!')
  end
  table.remove(enemyList, enemyIndex)
end

local function awardLoot(enemy)
  if enemy.loot and #enemy.loot > 0 then
    print('\n' .. enemy.name .. ' dropped:')
    for _, lootItem in ipairs(enemy.loot) do
      local itemData = require('items.funcs').getItemById(lootItem.id)

      if itemData then
        print('  - ' .. itemData.name .. ' (x' .. lootItem.quantity .. ')')

        local found = false
        for _, invItem in ipairs(gameState.player.inventory) do
          if invItem.id == lootItem.id then
            invItem.quantity = invItem.quantity + lootItem.quantity
            found = true
            break
          end
        end

        if not found then
          table.insert(
            gameState.player.inventory,
            { id = lootItem.id, quantity = lootItem.quantity }
          )
        end
      else
        print('error: loot item "' .. lootItem.id .. '" not found in the items table!')
      end
    end
  end
end

return {
  enemyAttack = enemyAttack,
  handleEnemyDeath = handleEnemyDeath,
  awardLoot = awardLoot,
}
