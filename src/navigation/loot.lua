-- src/navigation/loot.lua
local gameState = require('game.gameState')
local itemFuncs = require('items.funcs')

local function searchRoom()
  local coords = gameState.player.roomCoordinates
  local currentKey = coords.x .. ',' .. coords.y
  local currentRoomData = gameState.dungeonMap[currentKey]

  -- Safety check if room has no loot or it's empty
  if not currentRoomData.loot or #currentRoomData.loot == 0 then
    print('\nYou search the room thoroughly but find nothing of value.')
    return false
  end

  print('\nYou search the room and find:')

  -- Iterate through items in the room's loot table
  for _, lootEntry in ipairs(currentRoomData.loot) do
    -- Support checking via the 'name' field in your room data or fallback to 'id'
    local itemSearchId = lootEntry.id or lootEntry.name
    local itemDetails = itemFuncs.getItemById(itemSearchId)
    local printableName = itemDetails and itemDetails.name or itemSearchId

    print('  - ' .. printableName .. ' (x' .. lootEntry.quantity .. ')')

    -- Find if the item already exists in the player's structured inventory array
    local foundInInventory = false
    for _, invItem in ipairs(gameState.player.inventory) do
      if invItem.id == itemSearchId then
        invItem.quantity = invItem.quantity + lootEntry.quantity
        foundInInventory = true
        break
      end
    end

    -- If it's a new item, insert a new structured slot
    if not foundInInventory then
      table.insert(gameState.player.inventory, {
        id = itemSearchId,
        quantity = lootEntry.quantity,
      })
    end
  end

  -- Wipe out the room's loot so it can't be looted repeatedly
  currentRoomData.loot = {}
  return true
end

return {
  searchRoom = searchRoom,
}
