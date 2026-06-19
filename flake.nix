{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-master.follows = "nixpkgs";

    # Core tools
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "darwin";
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
    nix-auth = {
      url = "github:numtide/nix-auth";
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
      url = "github:Homebrew/brew/6.0.2";
      flake = false;
    };

    # Private configurations
    secrets = {
      url = "git+ssh://git@github.com/OttNorml/nixos-config.git";
      flake = false;
    };
  };
  outputs =
    {
      self,
      # Core
      nixpkgs,
      nixpkgs-master,
      # Core tools
      agenix,
      disko,
      home-manager,
      nix-auth,
      # Darwin-specific
      darwin,
      # Homebrew integration
      nix-homebrew,
      homebrew-brew,
      # Private configurations
      secrets,
    }@inputs:
    let
      user = "spt";
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default =
            with pkgs;
            mkShell {
              nativeBuildInputs = with pkgs; [
                bashInteractive
                git
                age
                age-plugin-yubikey
              ];
              shellHook = with pkgs; ''
                export EDITOR=vim
              '';
            };
        };
      mkApp = scriptName: system: {
        type = "app";
        program = "${
          (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
            #!/usr/bin/env bash
            PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
            echo "Running ${scriptName} for ${system}"
            exec ${self}/apps/${system}/${scriptName} "$@"
          '')
        }/bin/${scriptName}";
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

      mkSpecialArgs =
        system:
        inputs
        // {
          nix-auth = nix-auth.packages.${system}.default;
          nixpkgs-master = import nixpkgs-master {
            inherit system;
            config.allowUnfree = true;
          };
        };

      flakeLock = builtins.fromJSON (builtins.readFile ./flake.lock);
      brewVersion = flakeLock.nodes.homebrew-brew.original.ref;
    in
    {
      devShells = forAllSystems devShell;
      apps =
        nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (
        system:
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
                mutableTaps = true;
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
            # Align homebrew taps config with nix-homebrew
            ({ config, ... }: {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            })
            ./hosts/darwin
          ];
        }
      );

      nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (
        system:
        nixpkgs.lib.nixosSystem {
          specialArgs = mkSpecialArgs system;
          modules = [
            { nixpkgs.hostPlatform = system; }
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = mkSpecialArgs system;
                users.${user} = import ./modules/nixos/home-manager.nix;
              };
            }
            ./hosts/nixos
          ];
        }
      );
    };
}
