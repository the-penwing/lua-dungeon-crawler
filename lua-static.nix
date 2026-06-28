{
  pkgs,
  lib,
  stdenv,
  target ? null,
}: let
  targetName =
    if target != null
    then target
    else stdenv.hostPlatform.config;
in
  stdenv.mkDerivation {
    pname = "lua-static-${targetName}";
    version = "5.5-static";

    inherit target;

    src = pkgs.lua5_5.src;
    nativeBuildInputs = with pkgs; [zig gnumake coreutils];

    dontUnpack = true;

    buildPhase = ''
      mkdir -p lua-source
      tar -xf $src --strip-components=1 -C lua-source

      cd lua-source/src

      # Removed -s (do not strip intermediate objects) and added -fno-addrsig
      ZIG_FLAGS="-O3 -fno-sanitize=undefined -fno-addrsig"
      if [ -n "$target" ]; then
        ZIG_FLAGS="$ZIG_FLAGS -target $target"
      fi
      if [[ "$target" == "x86-linux-musl" ]]; then
        ZIG_FLAGS="$ZIG_FLAGS -mcpu=i686"
      fi

      cat << 'EOF' > Makefile
      SRCS = lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c \
             lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c \
             lundump.c lvm.c lzio.c lauxlib.c lbaselib.c lcorolib.c ldblib.c liolib.c \
             lmathlib.c loadlib.c loslib.c \
             lstrlib.c ltablib.c lutf8lib.c linit.c
      OBJS = $(SRCS:.c=.o)

      all: $(OBJS)

      %.o: %.c
      	zig cc $(ZIG_FLAGS) -c $< -o $@
      EOF

      export ZIG_FLAGS

      make -j8
    '';

    installPhase = ''
      mkdir -p $out/lib $out/include
      cp *.o $out/lib/
      cp *.h $out/include/
    '';
  }
