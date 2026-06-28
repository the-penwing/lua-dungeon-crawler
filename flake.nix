{
  description = "A CLI Dungeon Crawler written in Lua";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    lunar-bundler-src.url = "github:colourlabs/lunar-bundler";
    lunar-bundler-src.flaked = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    lunar-bundler-src,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};

        lunar-bundler = pkgs.rustPlatform.buildRustPackage {
          pname = "lunar-bundler";
          version = "git";
          src = lunar-bundler-src;
          cargoLock = {
            lockFile = "${lunar-bundler-src}/Cargo.lock";
          };
        };

        envSdkRoot = builtins.getEnv "SDKROOT";
        macOsSdk =
          if envSdkRoot != ""
          then envSdkRoot
          else null;

        makeTarget = target: sdk:
          pkgs.callPackage ./default.nix {
            inherit target;
            inherit lunar-bundler;
            sdkRoot = sdk;
          };
      in {
        packages = {
          linux-x86_64 = makeTarget "x86_64-linux-gnu" null;
          linux-arm64 = makeTarget "aarch64-linux-gnu" null;
          linux-x86_64-musl = makeTarget "x86_64-linux-musl" null;
          linux-arm64-musl = makeTarget "aarch64-linux-musl" null;
          linux-x86-musl = makeTarget "x86-linux-musl" null;

          macos-x86_64 = makeTarget "x86_64-macos" macOsSdk;
          macos-arm64 = makeTarget "aarch64-macos" macOsSdk;

          windows-x86_64 = makeTarget "x86_64-windows-gnu" null;
          windows-arm64 = makeTarget "aarch64-windows-gnu" null;

          default = makeTarget system null;

          all = pkgs.linkFarm "dungeon-crawler-all-targets" [
            {
              name = "linux-x86_64";
              path = self.packages.${system}.linux-x86_64;
            }
            {
              name = "linux-arm64";
              path = self.packages.${system}.linux-arm64;
            }
            {
              name = "linux-x86_64-musl";
              path = self.packages.${system}.linux-x86_64-musl;
            }
            {
              name = "linux-arm64-musl";
              path = self.packages.${system}.linux-arm64-musl;
            }
            {
              name = "linux-x86-musl";
              path = self.packages.${system}.linux-x86-musl;
            }
            {
              name = "macos-x86_64";
              path = self.packages.${system}.macos-x86_64;
            }
            {
              name = "macos-arm64";
              path = self.packages.${system}.macos-arm64;
            }
            {
              name = "windows-x86_64";
              path = self.packages.${system}.windows-x86_64;
            }
            {
              name = "windows-arm64";
              path = self.packages.${system}.windows-arm64;
            }
          ];
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/dungeon-crawler-cli";
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zig
            lua5_5
            xxd
            gnumake
            lunar-bundler
          ];
        };
      }
    );
}
