local gameState = require('game.gameState')
local function mainLoop()
  while true do
    local choice = require('menus').main.mainMenu() -- Returns: 1 (new), 2 (load), 3 (exit)

    if choice == 2 then
      local playerState = require('game.save').loadGame('save.json')
      if playerState then
        gameState.player = playerState
      else
        print('Error: Failed to load save file!')
      end
    end

    if choice == 3 then
      os.exit(0)
    end -- Exit game

    -- Either new game or load game (game state already set)
    repeat
      -- gameMenu() displays options and returns choice
      -- gameMenu() handles: use item, change weapon, move rooms, rest, save & quit to main menu
      local gameMenuChoice = require('menus').game.gameMenu()
      if gameMenuChoice == 1 then
        -- use item
        require('combat').utilise.choiceItem()
      elseif gameMenuChoice == 2 then
        -- switch weapon
        require('items.funcs').switchWeapon()
      elseif gameMenuChoice == 3 then
        -- next room
        require('navigation.movement').nextRoom()
      elseif gameMenuChoice == 4 then
        -- previous room
        require('navigation.movement').prevRoom()
      elseif gameMenuChoice == 5 then
        -- rest
        require('game.rest').rest()
      elseif gameMenuChoice == 6 then
        -- save and main menu
        require('game.save').saveGame('save.json')
        break
      end
    -- Handle other choices (use item, change weapon, rest, move room)
    until false -- Loop until player quits to main menu
  end
end

mainLoop()
