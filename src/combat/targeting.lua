local function selectTarget(enemies)
  while true do
    -- Display enemies
    print('Choose target:')
    for i, enemy in ipairs(enemies) do
      print(i .. ') ' .. enemy.name .. ' (' .. enemy.health .. '/' .. enemy.maxHealth .. ')')
    end
    print((#enemies + 1) .. ') return to action menu')

    -- Get target choice
    io.write('Target (1-' .. #enemies + 1 .. '): ')
    local targetIndex = tonumber(io.read())

    -- Validate
    if targetIndex == #enemies + 1 then
      return nil, nil -- Signal: they picked back
    elseif targetIndex and targetIndex >= 1 and targetIndex <= #enemies then
      return targetIndex, enemies[targetIndex]
    else
      print('invalid target!')
    end
  end
end

return {
  selectTarget = selectTarget,
}
