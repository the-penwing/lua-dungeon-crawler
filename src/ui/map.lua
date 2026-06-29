local gameState = require('game.gameState')

local function renderMinimap()
  local map = gameState.dungeonMap
  local playerCoords = gameState.player.roomCoordinates

  local minX, maxX, minY, maxY = 999, -999, 999, -999
  local roomCount = 0
  for key, _ in pairs(map) do
    local x, y = key:match('([^,]+),([^,]+)')
    x, y = tonumber(x), tonumber(y)
    if x < minX then
      minX = x
    end
    if x > maxX then
      maxX = x
    end
    if y < minY then
      minY = y
    end
    if y > maxY then
      maxY = y
    end
    roomCount = roomCount + 1
  end

  if roomCount == 0 then
    return
  end

  print(
    '\n┌────────────────────────────────────────────────────────┐'
  )
  print('│                  DYNAMIC DUNGEON MAZE                  │')
  print(
    '└────────────────────────────────────────────────────────┘'
  )

  for y = maxY, minY, -1 do
    local lineCeiling = '  '
    local lineRooms = '  '
    local lineFloor = '  '

    for x = minX, maxX do
      local currentKey = x .. ',' .. y
      local room = map[currentKey]

      if room then
        local icon = '.'
        if x == playerCoords.x and y == playerCoords.y then
          icon = 'P'
        elseif room.name == "The Dragon's Lair" then
          icon = 'B'
        elseif #room.enemies > 0 then
          icon = 'X'
        end

        local hasNorth = room.exits and room.exits.north
        local hasSouth = room.exits and room.exits.south
        local hasEast = room.exits and room.exits.east

        -- The trailing space at the end of strings prevents box squishing!
        if hasNorth then
          lineCeiling = lineCeiling .. '┌─ ║ ─┐ '
        else
          lineCeiling = lineCeiling .. '┌─────┐ '
        end

        if hasEast then
          lineRooms = lineRooms .. '│  ' .. icon .. '  ══'
        else
          lineRooms = lineRooms .. '│  ' .. icon .. '  │ '
        end

        if hasSouth then
          lineFloor = lineFloor .. '└─ ║ ─┘ '
        else
          lineFloor = lineFloor .. '└─────┘ '
        end
      else
        -- Draw empty gaps for empty layout space
        lineCeiling = lineCeiling .. '        '
        lineRooms = lineRooms .. '        '
        lineFloor = lineFloor .. '        '
      end
    end

    -- Compass layout mapping
    if y == maxY then
      print(lineCeiling .. '    [ COMPASS ]')
      print(lineRooms .. '         N')
      print(lineFloor .. '         ▲')
    elseif y == maxY - 1 then
      print(lineCeiling .. '     W ◄─┼─► E')
      print(lineRooms .. '         ▼')
      print(lineFloor .. '         S')
    else
      print(lineCeiling)
      print(lineRooms)
      print(lineFloor)
    end
  end
  print(
    '┌────────────────────────────────────────────────────────┐'
  )
  print('│ Legend: ══ / ║ = Halls  [P] You  [.] Clear  [X] Mobs   │')
  print(
    '└────────────────────────────────────────────────────────┘\n'
  )
end

return { renderMinimap = renderMinimap }
