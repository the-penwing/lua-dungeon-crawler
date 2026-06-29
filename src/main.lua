local combat = require('combat')
local game = require('game')
local itemFuncs = require('items.funcs')
local menus = require('menus')
local navigation = require('navigation')
local function mainLoop()
  while true do
    local choice = menus.main.mainMenu()

    if choice == 2 then
      if not game.save.loadGame('save.json') then
        print('Error: Failed to load save file!')
      end
    end

    if choice == 3 then
      os.exit(0)
    end

    repeat
      local gameMenuChoice = require('menus').game.gameMenu()
      if gameMenuChoice == 1 then
        combat.utilise.choiceItem()
      elseif gameMenuChoice == 2 then
        itemFuncs.switchWeapon()
      elseif gameMenuChoice == 3 then
        navigation.movement.navMenu()
      elseif gameMenuChoice == 4 then
        navigation.loot.searchRoom()
      elseif gameMenuChoice == 5 then
        game.rest.rest()
      elseif gameMenuChoice == 6 then
        game.save.saveGame('save.json')
        break
      end
    until false
  end
end

mainLoop()
