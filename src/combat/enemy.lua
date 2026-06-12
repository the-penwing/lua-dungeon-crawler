local game = require('src.game')

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

    game.player.health = game.player.health - damage
    print('ouch, ' .. enemy.name .. ' did ' .. damage .. ' to you')
  else
    print(enemy.name .. "'s attack missed!")
  end

  -- Increment dragon's attack cycle (whether hit or miss)
  if enemy.name == 'Dragon' then
    enemy.attackPhase = (enemy.attackPhase + 1) % 4 -- Cycles 0,1,2,3,0,1,2,3...
  end

  if game.player.health <= 0 then
    game.playerAlive = false
    print('oh snap, that blow killed you.')
  end
end

local function awardLoot(enemy)
  for _, lootItem in ipairs(enemy.loot) do
    -- Check if item already in inventory
    local found = false
    for _, invItem in ipairs(game.player.inventory) do
      if invItem.id == lootItem.id then -- Change .name to .id
        -- Item exists, add quantity
        invItem.quantity = invItem.quantity + lootItem.quantity
        found = true
        break
      end
    end

    -- If not found, add new item
    if not found then
      table.insert(game.player.inventory, { id = lootItem.id, quantity = lootItem.quantity }) -- Change .name to .id
    end
  end
end

return {
  enemyAttack = enemyAttack,
  awardLoot = awardLoot,
}
