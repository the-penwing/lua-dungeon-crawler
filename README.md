# Lua Dungeon Crawler

A Dungeon Crawler written in Lua compiled as standalone binaries.

<img src="./ai-free-badge.svg" width="150">

## Playing the Game

There are 3 ways to install / play the game:

- [Running via Lua 5.5.0](#running-via-lua)
- [Nix (Recommended)](#nix)
- [Building the C Wrapper Natively](./c-wrapper/building.md)

### Running via Lua

**Requirements:**
- Lua 5.5 in your path

```bash
# Run the bundled script
lua ./src/main.lua
```

---

### Nix

If you are using Nix, you don't need to manually clone, bundle, or compile anything. Nix uses my cross-compilation matrix to automagically spit out an optimized executable tailored to your system.

**Run Instantly Without Installation**

```bash
nix run github:benvl/dungeonCrawler
```

**Install to Profile**

```bash
nix profile add github:benvl/dungeonCrawler
dungeon-crawler
```

**Uninstall**

```bash
nix profile remove dungeon-crawler
```

#### Using the Flake in Your System Configuration (Optional)

1. **Add the game to your `flake.nix` inputs:**

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  dungeon-crawler-cli.url = "github:benvl/dungeonCrawler";
};
```

2. **Pass `inputs.dungeon-crawler-cli` to your outputs and declare it in your system packages:**

```nix
outputs = { self, nixpkgs, dungeon-crawler-cli, ... }: {
  nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ({ pkgs, ... }: {
        environment.systemPackages = [
          dungeon-crawler-cli.packages.${system}.default
        ];
      })
    ];
  };
};
```
