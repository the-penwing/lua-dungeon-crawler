{
  pkgs,
  lib,
  stdenv,
  lunar-bundler,
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
  stdenv.mkDerivation (finalAttrs: (
    {
      pname = "dungeon-crawler-cli";
      version = "0.1.0";

      src = ./.;

      nativeBuildInputs = with pkgs; [
        zig
        lua5_5
        xxd
        coreutils
        gnumake
        lunar-bundler
      ];

      buildPhase = ''
            runHook preBuild

            mkdir -p .build
            cp c-wrapper/dungeon-crawler-cli.c .build/
            cp -R src/ .build/src/

            cd .build

            lunar-bundler src/main.lua dungeon-crawler.lua

            luac -s -o dungeon-crawler.luac dungeon-crawler.lua
            xxd -i dungeon-crawler.luac > dungeon-crawler.h

            mkdir -p lua
            tar -xf ${pkgs.lua5_5.src} --strip-components=1 -C lua
            chmod -R +w lua/
            ZIG_FLAGS="-O3 -s"
            if [ -n "''${target-}" ]; then
              ZIG_FLAGS="$ZIG_FLAGS -target $target"
            fi

            if [[ "$target" == "x86-linux-musl" ]]; then
              ZIG_FLAGS="$ZIG_FLAGS -mcpu=i686"
            fi

            if [ -n "''${sdkRoot-}" ]; then
              ZIG_FLAGS="$ZIG_FLAGS -isysroot $sdkRoot"
              ZIG_FLAGS="$ZIG_FLAGS -mmacosx-version-min=11.0"
            fi

            echo "Generating temporary Makefile for parallel Lua compilation..."
            cat << 'EOF' > lua/src/Makefile
        SRCS = lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c \
               lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c \
               lundump.c lvm.c lzio.c lauxlib.c lbaselib.c lcorolib.c ldblib.c liolib.c \
               lmathlib.c loadlib.c loslib.c lstrlib.c ltablib.c lutf8lib.c linit.c
        OBJS = $(SRCS:.c=.o)

        all: liblua.a

        %.o: %.c
        	zig cc $(ZIG_FLAGS) -c $< -o $@

        liblua.a: $(OBJS)
        	zig ar rcs liblua.a $(OBJS)
        EOF

            echo "Building static Lua core for $targetName in parallel..."
            export ZIG_FLAGS
            make -C lua/src -j8

            echo "Linking dungeon-crawler-cli..."
            LINK_FLAGS="-lm"
            if [[ "$ZIG_FLAGS" == *"windows"* ]]; then
              LINK_FLAGS="-lws2_32"
            fi
            if [[ "$ZIG_FLAGS" == *"musl"* ]]; then
              LINK_FLAGS="-static -lm"
            fi

            zig cc $ZIG_FLAGS -I lua/src -o "dungeon-crawler-cli${binarySuffix}" dungeon-crawler-cli.c lua/src/liblua.a $LINK_FLAGS

            cd ..

            runHook postBuild
      '';
      installPhase = ''
        mkdir -p $out/bin
        mv .build/dungeon-crawler-cli${binarySuffix} $out/bin/
      '';
    }
    // (lib.optionalAttrs (target != null) {inherit target;})
    // (lib.optionalAttrs (sdkRoot != null) {inherit sdkRoot;})
  ))
