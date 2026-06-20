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

  -- Increment dragon's attack cycle (whether hit or miss)
  if enemy.name == 'Dragon' then
    enemy.attackPhase = (enemy.attackPhase + 1) % 4 -- Cycles 0,1,2,3,0,1,2,3...
  end

  if gameState.player.hp <= 0 then
    gameState.playerAlive = false
    print('oh snap, that blow killed you.')
  end
end

local function awardLoot(enemy)
  if #enemy.loot > 0 then
    print('\n' .. enemy.name .. ' dropped:')
    for _, lootItem in ipairs(enemy.loot) do
      local itemData = require('items.funcs').getItemById(lootItem.id)

      if itemData then
        print('  - ' .. itemData.name .. ' (x' .. lootItem.quantity .. ')')

        -- Check if item already in inventory
        local found = false
        for _, invItem in ipairs(gameState.player.inventory) do
          if invItem.id == lootItem.id then -- Change .name to .id
            -- Item exists, add quantity
            invItem.quantity = invItem.quantity + lootItem.quantity
            found = true
            break
          end
        end

        -- If not found, add new item
        if not found then
          table.insert(
            gameState.player.inventory,
            { id = lootItem.id, quantity = lootItem.quantity }
          ) -- Change .name to .id
        end
      else
        print('error: loot item "' .. lootItem.id .. '" not found in the items table!')
      end
    end
  end
end

return {
  enemyAttack = enemyAttack,
  awardLoot = awardLoot,
}
