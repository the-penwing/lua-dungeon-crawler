local function clear()
  if os.getenv('OS') == 'Windows_NT' then
    os.execute('cls')
  else
    os.execute('clear')
  end
end

return {
  clear = clear,
}
