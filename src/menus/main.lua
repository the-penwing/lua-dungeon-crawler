local ui = require('ui')
local function mainMenu()
  ui.clear.clear()
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

return {
  mainMenu = mainMenu,
}
