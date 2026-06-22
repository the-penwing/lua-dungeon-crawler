# Building the Game

## Requirements

- **C compiler** (gcc, clang, or zig cc)
- **Lua 5.5.0 source**
- **lunar-bundler** installed and in PATH

## Setup (One-Time)

Download and extract Lua 5.5.0:

```bash
curl -L -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz
tar zxf lua-5.5.0.tar.gz
```

## Manual Build

### 1. Bundle the Lua source

```bash
lunar-bundler ../src/main.lua -o dungeonCrawler.lua
```

### 2. Compile to bytecode

```bash
luac -s -o dungeonCrawler.luac dungeonCrawler.lua
```

### 3. Convert bytecode to C header

```bash
xxd -i dungeonCrawler.luac dungeonCrawler.h
```

### 4. Build Lua library

```bash
cd ../lua-5.5.0
make all
cd ../c-wrapper
```

### 5. Compile the game

```bash
mkdir -p bin
gcc -O2 \
  -I ../lua-5.5.0/src \
  -L ../lua-5.5.0/src \
  -o bin/dungeonCrawler \
  dungeonCrawler.c \
  -llua -lm
```

Binary is at `bin/dungeonCrawler`.
