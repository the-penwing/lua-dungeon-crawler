{
  pkgs,
  lib,
  stdenv,
  lunar-bundler,
  luaStatic,
  target ? null,
  sdkRoot ? null,
  ...
}: let
  isWindows = lib.hasInfix "windows" targetName;
  targetName =
    if target != null
    then target
    else stdenv.hostPlatform.config;
  binarySuffix =
    if isWindows
    then ".exe"
    else "";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "dungeon-crawler-cli";
    version = "0.1.0";

    inherit target;

    src = builtins.path {
      path = ./.;
      name = "dungeon-crawler-src";
      filter = path: type: let
        base = baseNameOf path;
        isInAllowedDir = lib.hasInfix "/src" path || lib.hasInfix "/c-wrapper" path;
      in
        base == "src" || base == "c-wrapper" || isInAllowedDir;
    };

    nativeBuildInputs = with pkgs; [
      zig
      lua5_5
      xxd
      coreutils
      lunar-bundler
    ];

    buildPhase = ''
      runHook preBuild

      mkdir -p .build
      cp c-wrapper/dungeon-crawler-cli.c .build/
      cp -R src/ .build/src/
      cd .build

      lunar-bundler src/main.lua --output dungeon-crawler.lua
      luac -s -o dungeon-crawler.luac dungeon-crawler.lua
      xxd -i dungeon-crawler.luac > dungeon-crawler.h

      ZIG_FLAGS="-O3 -s -fno-sanitize=undefined"
      if [ -n "$target" ]; then
        ZIG_FLAGS="$ZIG_FLAGS -target $target"
      fi
      if [[ "$target" == "x86-linux-musl" ]]; then
        ZIG_FLAGS="$ZIG_FLAGS -mcpu=i686"
      fi
      if [ -n "''${sdkRoot-}" ]; then
        ZIG_FLAGS="$ZIG_FLAGS -isysroot $sdkRoot"
        ZIG_FLAGS="$ZIG_FLAGS -mmacosx-version-min=11.0"
      fi

      LINK_FLAGS="-lm"
      if [[ "$ZIG_FLAGS" == *"windows"* ]]; then
        LINK_FLAGS="-lws2_32"
      fi
      if [[ "$ZIG_FLAGS" == *"musl"* ]]; then
        LINK_FLAGS="-static -lm"
      fi
      if [[ "$target" == "x86_64-macos" ]]; then
        LINK_FLAGS="$LINK_FLAGS -Wl,-headerpad_max_install_names"
      fi

      # Link by passing the cached target object files directly to avoid fragile archive files
      zig cc $ZIG_FLAGS -I ${luaStatic}/include dungeon-crawler-cli.c ${luaStatic}/lib/*.o $LINK_FLAGS -o "dungeon-crawler-cli${binarySuffix}"

      cd ..
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv .build/dungeon-crawler-cli${binarySuffix} $out/bin/
    '';
  })
