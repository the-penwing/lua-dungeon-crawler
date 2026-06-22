#include "dungeonCrawler.h"
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <stdio.h>

int main() {
  lua_State *L = luaL_newstate();

  luaL_openlibs(L);

  int load_result = luaL_loadbuffer(L, (const char *)dungeonCrawler_luac,
                                    dungeonCrawler_luac_len, "dungeonCrawler");

  if (load_result != 0) {
    printf("Error loading bytecode: %s\n", lua_tostring(L, -1));
    lua_close(L);
    return 1;
  }

  int exec_result = lua_pcall(L, 0, 0, 0);

  if (exec_result != 0) {
    printf("Error running script: %s\n", lua_tostring(L, -1));
    lua_close(L);
    return 1;
  }

  lua_close(L);
  return 0;
}
