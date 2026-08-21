{pkgs}:
pkgs.mkShell {
  nativeBuildInputs = [pkgs.lua5_5];
}
