# Building the Dungeon Crawler

## Requirements

- **C compiler** (`gcc`, `clang`, or `zig`)
- **xxd** (Hex dump utility)
- **lunar-bundler** (Rust crate to merge multi-file Lua projects)
- **Lua 5.5.0 source files**

[Lunar Bundler](https://github.com/colourlabs/lunar-bundler)

---

## Setup (One-Time)

Download and extract the Lua 5.5.0 runtime source package into the same parent folder as this repository:

```bash
curl -L -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz
tar zxf lua-5.5.0.tar.gz
```

Your directory structure must match this layout for paths to align:

```text
├── lua-5.5.0/
└── dungeonCrawler
    ├── c-wrapper/
    │   ├── dungeon-crawler-cli.c
    │   └── building.md
    ├── src/
    │   ├── dungeon-crawler.lua   # Core entry point
    │   └── (other game modules)
    ├── README.md
    └── LICENSE
```

---

## Manual Step-by-Step Build

If you are not using the automatic `nix build .#all` multi-target engine, you can build manually inside the `c-wrapper` directory following these steps:

### 1. Bundle Multi-file Source Into One File

```bash
lunar-bundler ../src/dungeon-crawler.lua --output dungeon-crawler.lua
```

### 2. Compile Consolidated Script to Bytecode

```bash
luac -s -o dungeon-crawler.luac dungeon-crawler.lua
```

### 3. Generate the C Header Embed Archive

```bash
xxd -i dungeon-crawler.luac dungeon-crawler.h
```

### 4. Build the Local Static Lua Core Runtime

```bash
cd ../../lua-5.5.0
make all
cd ../dungeonCrawler/c-wrapper
```

### 5. Link the Executable Core Binary

```bash
mkdir -p bin
gcc -O3 \
  -I ../../lua-5.5.0/src \
  -L ../../lua-5.5.0/src \
  -o bin/dungeon-crawler-cli \
  dungeon-crawler-cli.c \
  -llua -lm
```

Your fully playable standalone binary is availiable at `bin/dungeon-crawler-cli`.
