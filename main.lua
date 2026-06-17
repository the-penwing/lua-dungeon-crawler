local combat = require('src.combat')
local game = require('src.game')
local navigation = require('src.navigation.movement')
local items = require('src.items')

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
        items.funcs.switchWeapon()
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
