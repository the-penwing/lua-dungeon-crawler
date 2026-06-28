local function clear()
  io.write('\27[2J\27[H')
  io.flush()
end

return {
  clear = clear,
}
