{ config, pkgs, ... }:

let
  user = "spt";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
    ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  environment = {
    # You can configure your usual shell environment for homebrew here.
    variables = {
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1";
      HOMEBREW_NO_ENV_HINTS = "0";
      CLOUDSDK_PYTHON = "${pkgs.python313}/bin/python3";
    };

    # This is included so that the homebrew packages are available in the PATH.
    systemPath = [ "${config.homebrew.prefix}/bin" ];
  };

  homebrew = {
    enable = true;
    brews = pkgs.callPackage ./brews.nix { };
    casks = pkgs.callPackage ./casks.nix { };
    greedyCasks = true;
    onActivation = {
      autoUpdate = true;
      # cleanup = "zap"; # Uninstall packages/casks not in Brewfile
      upgrade = true;
      extraFlags = [ "--all" "--verbose" ];
    };

    global = {
      brewfile = true;
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)

    masApps = {
      "AusweisApp" = 948660805;
      "eduVPN" = 1317704208;
      "wireguard" = 1451685025;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { };
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        # Configure a user-local npm prefix so globally installed npm packages
        # do not require sudo and are kept inside the Home Manager user's home.
        # The matching bin directory is added to PATH so installed CLIs are available.
        sessionVariables = {
          NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.local/share/npm-global";
        };

        sessionPath = [
          "${config.home.homeDirectory}/.local/share/npm-global/bin"
        ];

        stateVersion = "25.05";
      };

      # Extend the zsh configuration
      programs.zsh.initContent = lib.mkOrder 550 ''
        # Make the Delete key work consistently in zsh.
        # Many terminals send the escape sequence ^[[3~ when Delete is pressed.
        # Binding it to delete-char makes Delete remove the character under/right
        # of the cursor, instead of doing nothing or printing unexpected characters like ~.
        # The binding is applied to the default keymap as well as emacs and vi modes.
        bindkey '^[[3~' delete-char
        bindkey -M emacs '^[[3~' delete-char
        bindkey -M viins '^[[3~' delete-char
        bindkey -M vicmd '^[[3~' delete-char

        # Darwin override: shared config sets emacsclient editor defaults.
        export ALTERNATE_EDITOR=""
        export EDITOR="vim"
        export VISUAL="vim"

        e() {
          vim "$@"
        }

        function _brew_shellenv {
          # https://github.com/ohmyzsh/ohmyzsh/blob/a449c0247d69726fe4f3ca4fe88182bdb215a5d3/plugins/brew/brew.plugin.zsh#L1-L24
          if (( ! $+commands[brew] )); then
            if [[ -n "$BREW_LOCATION" ]]; then
              if [[ ! -x "$BREW_LOCATION" ]]; then
                echo "$BREW_LOCATION is not executable"
                return
              fi
            elif [[ -x /opt/homebrew/bin/brew ]]; then
              BREW_LOCATION="/opt/homebrew/bin/brew"
            elif [[ -x /usr/local/bin/brew ]]; then
              BREW_LOCATION="/usr/local/bin/brew"
            elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
              BREW_LOCATION="/home/linuxbrew/.linuxbrew/bin/brew"
            elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
              BREW_LOCATION="$HOME/.linuxbrew/bin/brew"
            else
              return
            fi

            # Only add Homebrew installation to PATH, MANPATH, and INFOPATH if brew is
            # not already on the path, to prevent duplicate entries. This aligns with
            # the behavior of the brew installer.sh post-install steps.
            eval "$("$BREW_LOCATION" shellenv)"
            unset BREW_LOCATION
          fi
        }
        _brew_shellenv
        unset -f _brew_shellenv
      '';

      # Import shared config. Assuming shared/home-manager.nix returns
      # attributes for 'programs' (like { zsh = ...; git = ...; })
      imports = [
        ({ ... }: {
          programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
        })
      ];

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      # manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock = {
      enable = true;
      username = user;
      dockutilPath = "${config.homebrew.prefix}/bin/dockutil";
      entries = [
        { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
        # { path = "/System/Applications/System Settings.app/"; }
        {
          path = "${config.users.users.${user}.home}/Downloads";
          section = "others";
          options = "--sort dateadded --view fan --display stack";
        }
      ];
    };
  };
}
