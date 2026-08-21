local APP_DIR_NAME <const> = 'dungeon-crawler'

local osList = { 'linux', 'macos', 'windows', 'unknown' }
local function whichOS()
  if package.config:sub(1, 1) == [[\]] then
    return osList[3]
  end
  local handle = io.popen('uname -s')
  if not handle then
    return osList[4]
  end
  local result = handle:read('*a')
  result = result:match('^%a+')
  handle:close()
  if result == 'Darwin' then
    return osList[2]
  elseif result == 'Linux' then
    return osList[1]
  end
  return osList[4]
end

local OS <const> = whichOS()

local function pathJoin(...)
  local sepChar
  if OS == osList[3] then
    sepChar = [[\]]
  elseif OS == osList[1] or OS == osList[2] then
    sepChar = '/'
  end
  local pathArgs = { ... }
  return table.concat(pathArgs, sepChar)
end

local function platformDataRoot()
  local path
  if OS == osList[1] then
    path = os.getenv('XDG_DATA_HOME') or pathJoin(os.getenv('HOME'), '.local', 'share')
  elseif OS == osList[2] then
    path = pathJoin(os.getenv('HOME'), 'Library', 'Application Support')
  elseif OS == osList[3] then
    path = os.getenv('APPDATA') or pathJoin(os.getenv('USERPROFILE'), 'AppData', 'Roaming')
  end
  return path
end

local function appDataDir()
  local root = platformDataRoot()
  if root ~= nil then
    return pathJoin(root, APP_DIR_NAME)
  end
  return nil
end

local function ensureDir(path)
  if not path then
    return false
  end
  local cmd
  if OS == osList[3] then
    cmd = 'mkdir ' .. path
  else
    cmd = 'mkdir -p ' .. path
  end
  local ok = os.execute(cmd)
  return ok and true or false
end

return {
  pathJoin = pathJoin,
  platformDataRoot = platformDataRoot,
  appDataDir = appDataDir,
  ensureDir = ensureDir,
}
