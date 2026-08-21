{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "dungeon-crawler-cli";
  version = "0.1.0";

  src = pkgs.lib.fileset.toSource {
    root = ../.;
    fileset = pkgs.lib.fileset.unions [
      ../src
    ];
  };

  nativeBuildInputs = [pkgs.makeWrapper];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/dungeon-crawler $out/bin
    cp -r src/* $out/share/dungeon-crawler/

    makeWrapper ${pkgs.lua5_5}/bin/lua $out/bin/dungeon-crawler-cli \
      --add-flags "$out/share/dungeon-crawler/main.lua" \
      --set LUA_PATH "$out/share/dungeon-crawler/?.lua;$out/share/dungeon-crawler/?/init.lua;;"
  '';

  meta = {
    description = "A CLI Dungeon Crawler written in Lua";
    license = pkgs.lib.licenses.agpl3Only;
    maintainers = [
      {
        name = "Ben van Leeuwen";
        email = "benvanleeuwen01@gmail.com";
        github = "the-penwing";
      }
    ];
  };
}
