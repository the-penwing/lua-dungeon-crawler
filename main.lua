local combat = require('src.combat')
local game = require('src.game')
local rooms = require('src.rooms')
local items = require('src.items')
local ui = require('src.ui')

local function mainMenu()
  ui.clear()
  local validChoice = false
  repeat
    print('--- lua dungeon crawler ---')
    print('\n  1) new game')
    print('  2) load game')
    print('  3) exit')
    io.write('choice (1-3): ')
    choice = tonumber(io.read())
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
  repeat
    io.write('Enter choice (1-6): ')
    choice = tonumber(io.read())
    if choice > 1 and choice <= 6 then
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
  local weaponsInInventory = {}

  for i, inventoryItem in ipairs(game.player.inventory) do
    local itemData = items.getItemById(inventoryItem.id)
    -- check if the item is a weapon
    if itemData and items.items.weapons[itemData.id] then
      table.insert(weaponsInInventory, {
        index = i,
        id = inventoryItem.id,
        data = itemData,
      })
    end
  end
  print(ui.formatInventory(game.player.inventory))
end

local function mainLoop()
  local choice = mainMenu() -- Returns: 1 (new), 2 (load), 3 (exit)

  if choice == 3 then
    return
  end -- Exit game

  if choice == 2 then
    game = require('src.save').loadGame('save.json') or require('src.game')
    -- If load fails, fall back to fresh game
  end
  -- Either new game or load game (game state already set)
  repeat
    -- gameMenu() displays options and returns choice
    -- gameMenu() handles: use item, change weapon, move rooms, rest, save & quit to main menu
    local menuChoice = gameMenu()

    if menuChoice == 'quit' then
      -- Return to main menu
      break
    elseif menuChoice == 'enter_room' then
      -- Check if room has enemies
      if #rooms[game.player.currentRoom].enemies > 0 then
        local result = combat.loop.combatLoop(rooms[game.player.currentRoom].enemies)
        -- Show post-combat flow (loot, rest, use items, save)
      else
        -- Show room, no enemies
      end
    end
  -- Handle other choices (use item, change weapon, rest, move room)
  until false -- Loop until player quits to main menu
end
