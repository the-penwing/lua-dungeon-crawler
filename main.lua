local combat = require('src.combat')
local game = require('src.game')
local navigation = require('src.navigation.movement')
local items = require('src.items')

local function switchWeapon()
  local inventory = game.player.inventory
  -- make sure they have items / weapons
  if #inventory == 0 then
    print('you have no items!')
    print('returning to game menu.')
    return false
  end

  -- build weapon list
  local weaponsInInventory = {}
  for i, inventoryItem in ipairs(inventory) do
    local itemData = items.getItemById(inventoryItem.id)
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
    game.player.equippedWeapon = weaponsInInventory[choice].id
    return true
  else
    print('invaild choice!')
    return false
  end
end

local function rest()
  -- heal 10% current hp
  game.player.hp = math.min(math.floor(game.player.hp * (1 + 10 / 100)), game.player.maxHP)
  -- regen 5% of current mp
  game.player.mp = math.min(math.floor(game.player.mp * (1 + 5 / 100)), game.player.maxMP)
  -- display the results
  print('resting restored your HP to: ' .. game.player.hp .. ', and your MP to: ' .. game.player.mp)
end

local function mainLoop()
  while true do
    local choice = require('src.menus').main.mainMenu() -- Returns: 1 (new), 2 (load), 3 (exit)

    if choice == 2 then
      local playerState = require('src.save').loadGame('save.json')
      if playerState then
        game.player = playerState
      end
    end

    if choice == 3 then
      os.exit(0)
    end -- Exit game

    -- Either new game or load game (game state already set)
    repeat
      -- gameMenu() displays options and returns choice
      -- gameMenu() handles: use item, change weapon, move rooms, rest, save & quit to main menu
      local gameMenuChoice = require('src.menus').game.gameMenu()
      if gameMenuChoice == 1 then
        -- use item
        combat.utilise.choiceItem()
      elseif gameMenuChoice == 2 then
        -- switch weapon
        switchWeapon()
      elseif gameMenuChoice == 3 then
        -- next room
        navigation.nextRoom()
      elseif gameMenuChoice == 4 then
        -- previous room
        navigation.prevRoom()
      elseif gameMenuChoice == 5 then
        -- rest
        rest()
      elseif gameMenuChoice == 6 then
        -- save and main menu
        require('src.save').saveGame('save.json')
        break
      end
    -- Handle other choices (use item, change weapon, rest, move room)
    until false -- Loop until player quits to main menu
  end
end

mainLoop()
