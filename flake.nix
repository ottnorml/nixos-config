{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    # Core tools
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "homebrew-brew";
    };

    # Override Homebrew version to prevent nix-homebrew from using its pinned older version
    # (reference: https://github.com/zhaofengli/nix-homebrew/blob/a7760a3a83f7609f742861afb5732210fdc437ed/flake.nix)
    homebrew-brew = {
      url = "github:Homebrew/brew/5.1.8";
      flake = false;
    };

    # Homebrew taps
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    alexstrnik-browserino = {
      url = "github:AlexStrNik/homebrew-Browserino";
      flake = false;
    };
    anomalyco-tap = {
      url = "github:anomalyco/homebrew-tap";
      flake = false;
    };
    crumbyte-noxdir = {
      url = "github:crumbyte/homebrew-noxdir";
      flake = false;
    };
    deskflow-tap = {
      url = "github:deskflow/homebrew-tap";
      flake = false;
    };
    FelixKratz-formulae = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };
    fluxcd-tap = {
      url = "github:fluxcd/homebrew-tap";
      flake = false;
    };
    hyperb1iss-tap = {
      url = "github:hyperb1iss/homebrew-tap";
      flake = false;
    };
    jetbrains-junie = {
      url = "github:jetbrains/homebrew-junie";
      flake = false;
    };
    kdash-rs-kdash = {
      url = "github:kdash-rs/homebrew-kdash";
      flake = false;
    };
    koekeishiya-formulae = {
      url = "github:koekeishiya/homebrew-formulae";
      flake = false;
    };
    oven-sh-bun = {
      url = "github:oven-sh/homebrew-bun";
      flake = false;
    };
    ottnorml-mdns-browser = {
      url = "github:ottnorml/homebrew-mdns-browser";
      flake = false;
    };
    richard-fairthorne-tap = {
      url = "github:richard-fairthorne/homebrew-tap";
      flake = false;
    };
    rtk-ai-tap = {
      url = "github:rtk-ai/homebrew-tap";
      flake = false;
    };
    toobuntu-cask-tools = {
      url = "github:toobuntu/homebrew-cask-tools";
      flake = false;
    };

    # Private configurations
    secrets = {
      url = "git+ssh://git@github.com/OttNorml/nixos-config.git";
      flake = false;
    };
  };
  outputs =
    { self
      # Core
    , nixpkgs
    , nixpkgs-master
      # Core tools
    , agenix
    , disko
    , home-manager
      # Darwin-specific
    , darwin
      # Homebrew integration
    , nix-homebrew
    , homebrew-brew
      # Homebrew taps
    , alexstrnik-browserino
    , anomalyco-tap
    , crumbyte-noxdir
    , deskflow-tap
    , FelixKratz-formulae
    , fluxcd-tap
    , homebrew-cask
    , homebrew-core
    , hyperb1iss-tap
    , jetbrains-junie
    , kdash-rs-kdash
    , koekeishiya-formulae
    , oven-sh-bun
    , ottnorml-mdns-browser
    , richard-fairthorne-tap
    , rtk-ai-tap
    , toobuntu-cask-tools
      # Private configurations
    , secrets
    } @inputs:
    let
      user = "spt";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];

      flakeLock = builtins.fromJSON (builtins.readFile ./flake.lock);
      brewVersion = flakeLock.nodes.homebrew-brew.original.ref;

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

      mkSpecialArgs = system: inputs // {
        nixpkgs-master = import nixpkgs-master {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          specialArgs = mkSpecialArgs system;
          modules = [
            { nixpkgs.hostPlatform = system; }
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "AlexStrNik/homebrew-Browserino" = alexstrnik-browserino;
                  "anomalyco/homebrew-tap" = anomalyco-tap;
                  "crumbyte/homebrew-noxdir" = crumbyte-noxdir;
                  "deskflow/homebrew-tap" = deskflow-tap;
                  "FelixKratz/homebrew-formulae" = FelixKratz-formulae;
                  "fluxcd/homebrew-tap" = fluxcd-tap;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-core" = homebrew-core;
                  "hyperb1iss/homebrew-tap" = hyperb1iss-tap;
                  "jetbrains/homebrew-junie" = jetbrains-junie;
                  "kdash-rs/homebrew-kdash" = kdash-rs-kdash;
                  "koekeishiya/homebrew-formulae" = koekeishiya-formulae;
                  "oven-sh/homebrew-bun" = oven-sh-bun;
                  "ottnorml/homebrew-mdns-browser" = ottnorml-mdns-browser;
                  "richard-fairthorne/homebrew-tap" = richard-fairthorne-tap;
                  "rtk-ai/homebrew-tap" = rtk-ai-tap;
                  "toobuntu/homebrew-cask-tools" = toobuntu-cask-tools;
                };
                mutableTaps = false;
                autoMigrate = true;

                # Uses the explicitly pinned Homebrew source instead of nix-homebrew’s default.
                # `name` and `version` here are only metadata for Nix/store naming; the actual
                # Homebrew version is determined by the `homebrew-brew` input above.
                package = homebrew-brew // {
                  name = "brew-${brewVersion}";
                  version = brewVersion;
                };
              };
            }
            ./hosts/darwin
          ];
        });

      nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system: nixpkgs.lib.nixosSystem {
        specialArgs = mkSpecialArgs system;
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
