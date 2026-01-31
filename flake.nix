{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Core tools
    agenix.url = "github:ryantm/agenix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin-specific
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew integration
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Homebrew taps
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    crumbyte-noxdir = {
      url = "github:crumbyte/homebrew-noxdir";
      flake = false;
    };
    FelixKratz-formulae = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };
    koekeishiya-formulae = {
      url = "github:koekeishiya/homebrew-formulae";
      flake = false;
    };
    ottnorml-tap = {
      url = "github:ottnorml/homebrew-tap";
      flake = false;
    };
    richard-fairthorne-tap = {
      url = "github:richard-fairthorne/homebrew-tap";
      flake = false;
    };

    # Private configurations
    secrets = {
      url = "git+ssh://git@github.com/OttNorml/nixos-config.git";
      flake = false;
    };
  };
  outputs = { self, darwin, nix-homebrew, crumbyte-noxdir, FelixKratz-formulae, homebrew-bundle, homebrew-core, homebrew-cask, koekeishiya-formulae, ottnorml-tap, richard-fairthorne-tap, home-manager, nixpkgs, disko, agenix, secrets } @inputs:
    let
      user = "spt";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell = system:
        let pkgs = nixpkgs.legacyPackages.${system}; in {
          default = with pkgs; mkShell {
            nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
            shellHook = with pkgs; ''
              export EDITOR=vim
            '';
          };
        };
      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName} "$@"
        '')}/bin/${scriptName}";
      };
      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "clean" = mkApp "clean" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "install" = mkApp "install" system;
        "install-with-secrets" = mkApp "install-with-secrets" system;
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "clean" = mkApp "clean" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "rollback" = mkApp "rollback" system;
      };
    in
    {
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          specialArgs = inputs;
          modules = [
            { nixpkgs.hostPlatform = system; }
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "crumbyte/homebrew-noxdir" = crumbyte-noxdir;
                  "FelixKratz/homebrew-formulae" = FelixKratz-formulae;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-core" = homebrew-core;
                  "koekeishiya/homebrew-formulae" = koekeishiya-formulae;
                  "ottnorml/homebrew-tap" = ottnorml-tap;
                  "richard-fairthorne/homebrew-tap" = richard-fairthorne-tap;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        });

      nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system: nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          { nixpkgs.hostPlatform = system; }
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ./modules/nixos/home-manager.nix;
            };
          }
          ./hosts/nixos
        ];
      });
    };
}
