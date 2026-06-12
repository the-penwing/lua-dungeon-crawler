local combat = require('src.combat')
local game = require('src.game')
local rooms = require('src.rooms')
local items = require('src.items')
local ui = require('src.ui')

local function mainMenu()
  ui.clear()
  local validChoice = false
  local choice
  repeat
    print('--- lua dungeon crawler ---')
    print('\n  1) new game')
    print('  2) load game')
    print('  3) exit')
    io.write('choice (1-3): ')
    choice = tonumber(io.read('*l'))
    if choice == 1 or choice == 2 or choice == 3 then
      validChoice = true
    else
      print('please choose a valid option(1-3)')
    end
  until validChoice == true
  return choice
end
local function gameMenu()
  local currentRoom = game.player.currentRoom
  local roomDescription = rooms[currentRoom].description
  print('--- Room ' .. currentRoom .. ': ' .. roomDescription .. ' ---')
  print()
  ui.displayGameState()
  print('\nGame Menu:')
  print('  1) Use Item')
  print('  2) Switch Weapon')
  print('  3) Next Room')
  print('  4) Prev. Room')
  print('  5) Rest')
  print('  6) Save and Main Menu')
  local validChoice = false
  local choice
  repeat
    io.write('Enter choice (1-6): ')
    choice = tonumber(io.read('*l'))
    if choice >= 1 and choice <= 6 then
      validChoice = true
    else
      print('Invaild choice!')
      print('Enter 1-6')
    end
  until validChoice == true
  return choice
end

local function nextRoom()
  if rooms[game.player.currentRoom + 1] then
    game.player.currentRoom = game.player.currentRoom + 1
    local currentRoom = game.player.currentRoom
    print('You move to the next room...')
    ui.displayRoomDescription()
    if #rooms[currentRoom].enemies > 0 then
      combat.loop.combatLoop(rooms[game.player.currentRoom].enemies)
      return true
    else
      print('No enemies here')
      return true
    end
  else
    print('You cant go this way!')
    return false
  end
end

local function prevRoom()
  if rooms[game.player.currentRoom - 1] then
    game.player.currentRoom = game.player.currentRoom - 1
    local currentRoom = game.player.currentRoom
    print('You move back to the previous room...')
    ui.displayRoomDescription()
    if #rooms[currentRoom].enemies > 0 then
      combat.loop.combatLoop(rooms[game.player.currentRoom].enemies)
      return true
    else
      print('No enemies here')
      return true
    end
  else
    print('You cant go this way!')
    return false
  end
end

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

local function mainLoop()
  local choice = mainMenu() -- Returns: 1 (new), 2 (load), 3 (exit)

  if choice == 2 then
    game = require('src.save').loadGame('save.json') or require('src.game')
    -- If load fails, fall back to fresh game
  end

  if choice == 3 then
    os.exit(0)
  end -- Exit game

  -- Either new game or load game (game state already set)
  repeat
    -- gameMenu() displays options and returns choice
    -- gameMenu() handles: use item, change weapon, move rooms, rest, save & quit to main menu
    local gameMenuChoice = gameMenu()
    if gameMenuChoice == 1 then
      -- use item
      combat.utilise.useItem(combat.utilise.choiceItem())
    elseif gameMenuChoice == 2 then
      -- switch weapon
      switchWeapon()
    elseif gameMenuChoice == 3 then
      -- next room
      nextRoom()
    elseif gameMenuChoice == 4 then
      -- previous room
      prevRoom()
    elseif gameMenuChoice == 5 then
      -- rest
      return
    elseif gameMenuChoice == 6 then
      -- save and main menu
      return
    end
  -- Handle other choices (use item, change weapon, rest, move room)
  until false -- Loop until player quits to main menu
end

mainLoop()
