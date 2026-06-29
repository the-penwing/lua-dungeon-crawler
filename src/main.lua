-- src/main.lua
local combat = require('combat')
local game = require('game')
local itemFuncs = require('items.funcs')
local menus = require('menus')
local navigation = require('navigation')
local generator = require('navigation.generator')
local mapVisualiser = require('ui.map')
local function mainLoop()
  while true do
    local choice = menus.main.mainMenu()
    local enterGame = false

    if choice == 1 then
      -- 2. Generate the dynamic map on New Game
      generator.generateDungeon()
      enterGame = true
    elseif choice == 2 then
      if game.save.loadGame('save.json') then
        enterGame = true
      else
        print('Error: Failed to load save file!')
      end
    elseif choice == 3 then
      os.exit(0)
    end

    if enterGame then
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
          mapVisualiser.renderMinimap()
        elseif gameMenuChoice == 6 then
          game.rest.rest()
        elseif gameMenuChoice == 7 then
          game.save.saveGame('save.json')
          break
        end
      until false
    end
  end
end

mainLoop()
