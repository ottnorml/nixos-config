{
  agenix,
  config,
  nix-auth,
  nixpkgs-master,
  pkgs,
  ...
}:

let
  user = "spt";
in

{

  imports = [
    # ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/launchd-environment.nix
    ../../modules/shared
    # agenix.darwinModules.default
  ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # Setup user, packages, programs
  nix = {
    package = pkgs.lixPackageSets.stable.lix.overrideAttrs (old: {
      env = (old.env or { }) // {
        NIX_LDFLAGS = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isElf "-z,noexecstack";
      };
    });

    settings = {
      trusted-users = [
        "@admin"
        "${user}"
      ];
      auto-optimise-store = true;
      max-jobs = "auto"; # Default: 1
      sandbox = true;

      substituters = [
        "https://cache.lix.systems"
        "https://cache.nixos.org"
      ];

      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      ];

      trusted-substituters = [
        "https://hydra.nixos.org/"
      ];

      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.numtide.com"
      ];

      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.numtide.com-1:GF3TabtFocLtonIGfz3PD61AgIO8GmjCYhEAmYy4VPY="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };

    gc = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 15;
        Weekday = 7; # Sunday
      };
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      experimental-features = flakes nix-command
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes

  # Load configuration that is shared across systems
  environment.systemPackages =
    with pkgs;
    [
      agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
    ]
    ++ (import ../../modules/shared/packages.nix {
      inherit nix-auth nixpkgs-master pkgs;
    });

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = true;
        launchanim = true;
        orientation = "bottom";
        #tilesize = 48;
        tilesize = 42;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      CustomSystemPreferences = {
        "com.google.Keystone" = {
          # see https://support.google.com/chrome/a/answer/7591084#zippy=%2Cupdate-policy-settings%2Csample-property-list
          updatePolicies = {
            "com.google.Chrome" = {
              UpdateDefault = 2;
            };
            "com.google.drivefs" = {
              UpdateDefault = 2;
            };
            "global" = {
              DownloadPreference = "cacheable";
              UpdateDefault = 3;
            };
          };
        };
      };

      CustomUserPreferences = {
        "com.google.Chrome" = {
          # see https://chromeenterprise.google/policies/#GenAiDefaultSettings
          GenAiDefaultSettings = 1;
          # see https://chromeenterprise.google/policies/#GenAILocalFoundationalModelSettings
          GenAILocalFoundationalModelSettings = 1;
        };
        "org.mozilla.firefox" = {
          # see https://github.com/mozilla/policy-templates/tree/d2090553c2d1e661063bc5d10731b4d43876c13c/mac
          EnterprisePoliciesEnabled = true;
        };
        "com.raycast.macos" = {
          updaterEnabled = false;
        };
      };
    };
  };
}
