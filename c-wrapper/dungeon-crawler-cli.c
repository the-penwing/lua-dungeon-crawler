#include "dungeon-crawler.h"
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <stdio.h>

int main() {
  lua_State *L = luaL_newstate();

  luaL_openlibs(L);

  // Hyphens switched to underscores here:
  int load_result =
      luaL_loadbuffer(L, (const char *)dungeon_crawler_luac,
                      dungeon_crawler_luac_len, "dungeon-crawler");

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
