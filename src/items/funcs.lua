local function getItemById(itemId)
  for _, v in pairs(require('items.data')) do
    for _, itemData in pairs(v) do
      if itemData.id == itemId then
        return itemData
      end
    end
  end
  return nil
end

local function switchWeapon()
  local inventory = require('game').player.inventory
  -- make sure they have items / weapons
  if #inventory == 0 then
    print('you have no items!')
    print('returning to game menu.')
    return false
  end

  -- build weapon list
  local weaponsInInventory = {}
  for i, inventoryItem in ipairs(inventory) do
    local itemData = getItemById(inventoryItem.id)
    -- check if the item is a weapon
    if itemData and itemData.type == 'weapon' then
      table.insert(weaponsInInventory, {
        index = i,
        id = inventoryItem.id,
        data = itemData,
      })
    end
  end

  if #weaponsInInventory == 0 then
    print('you have no weapons!')
    print('returning to game menu.')
    return false
  end

  print('choose your weapon:')
  for i, weapon in ipairs(weaponsInInventory) do
    -- "  i) <weapon-name> - <x-dmg>DMG & <x-hit-chance>% Hit Chance"
    print(
      '  '
        .. i
        .. ') '
        .. weapon.data.name
        .. ' - '
        .. weapon.data.damage
        .. 'DMG & '
        .. weapon.data.hitChance
        .. '% Hit Chance'
    )
  end
  print('  ' .. (#weaponsInInventory + 1) .. ') return to game menu')
  -- get item choice
  io.write('choice (1-' .. (#weaponsInInventory + 1) .. '): ')
  local choice = tonumber(io.read('*l'))
  if choice == #weaponsInInventory + 1 then
    print('returning to game menu.')
    return false
  elseif choice and choice >= 1 and choice <= #weaponsInInventory then
    require('game').player.equippedWeapon = weaponsInInventory[choice].id
    return true
  else
    print('invaild choice!')
    return false
  end
end

return {
  getItemById = getItemById,
  switchWeapon = switchWeapon,
}
