{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Resolve the package/cask name used for sorting Homebrew entries.
  #
  # nix-darwin accepts Homebrew entries either as plain strings:
  #
  #   "jq"
  #
  # or as attrsets when extra Homebrew arguments are required:
  #
  #   {
  #     name = "headlamp";
  #     args = { no_quarantine = true; };
  #   }
  #
  # Always compare by the effective Homebrew name so both forms sort
  # consistently.
  brewEntryName = entry: if builtins.isAttrs entry then entry.name else entry;

  # Match the ordering produced by `brew bundle dump`: regular Homebrew entries
  # first, tapped entries such as `owner/tap/name` second, and alphabetical order
  # within each group.
  brewEntrySortKey =
    entry:
    let
      name = brewEntryName entry;
    in
    {
      inherit name;
      isTapped = lib.hasInfix "/" name;
    };

  sortBrewfileEntries = lib.sort (
    a: b:
    let
      aKey = brewEntrySortKey a;
      bKey = brewEntrySortKey b;
    in
    if aKey.isTapped == bKey.isTapped then aKey.name < bKey.name else !aKey.isTapped && bKey.isTapped
  );

  homebrewTelemetryVariables = lib.filterAttrs (
    name: _: lib.hasPrefix "HOMEBREW_" name
  ) config.privacy.telemetry.effectiveVariables;

  homebrewTelemetryEnvironment = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: "${name}=${value}") homebrewTelemetryVariables
  );
in
{
  # Homebrew-specific environment. Prefer Homebrew's own env file over global
  # shell variables so these settings apply consistently to all brew invocations
  # without polluting the general user/session environment.
  #
  # Note: Homebrew treats these variables as detected when they have a value.
  # For boolean-style `HOMEBREW_NO_*` variables, do not use `0` to mean false;
  # leave the variable unset instead.
  environment.etc."homebrew/brew.env".text = ''
    HOMEBREW_AUTO_UPDATE_SECS=300
    HOMEBREW_BAT=1
    HOMEBREW_CLEANUP_MAX_AGE_DAYS=7
    HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=7
    HOMEBREW_LOGS=~/.local/var/homebrew/logs
    HOMEBREW_NO_ANALYTICS=1
    HOMEBREW_NO_INSECURE_REDIRECT=1
    HOMEBREW_NO_INSTALL_FROM_API=1
    HOMEBREW_SBOM=1
    HOMEBREW_VERBOSE_USING_DOTS=1
    HOMEBREW_VERIFY_ATTESTATIONS=1
    ${homebrewTelemetryEnvironment}
  '';

  # This is included so that the Homebrew packages are available in the PATH.
  environment.systemPath = [ "${config.homebrew.prefix}/bin" ];

  homebrew = {
    enable = true;

    taps = [
      "adembc/tap"
      "alexstrnik/browserino"
      "anomalyco/tap"
      "aprilnea/tap"
      # "asmvik/formulae"
      "crumbyte/noxdir"
      "darrylmorley/whatcable"
      "deskflow/tap"
      "felixkratz/formulae"
      "fluxcd/tap"
      "hrzlgnm/tap"
      "hyperb1iss/tap"
      "jetbrains/junie"
      "jordond/tap"
      "kdash-rs/kdash"
      "lablup/tap"
      "masawada/tap"
      "matthart1983/tap"
      "oven-sh/bun"
      "owenthereal/upterm"
      "richard-fairthorne/tap"
      "rtk-ai/tap"
      "sozercan/repo"
      "toobuntu/cask-tools"
    ];

    brews = sortBrewfileEntries (pkgs.callPackage ./brews.nix { });
    casks = sortBrewfileEntries (pkgs.callPackage ./casks.nix { });

    greedyCasks = true;

    onActivation = {
      # Update Homebrew only when nix-darwin runs brew bundle during activation.
      autoUpdate = true;
      # cleanup = "zap"; # Uninstall packages/casks not in Brewfile
      upgrade = true;
      extraFlags = [
        # "--debug"
        "--jobs=auto" # Parallel formula installations using available CPU cores (max 4)
        "--verbose"
      ];
    };

    global = {
      brewfile = true;
      # Keep automatic updates disabled for manually invoked brew commands.
      autoUpdate = false;
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

    # NOTE: masApps disabled due to compatibility issues with brew bundle and mas CLI.
    # TODO: Re-enable after mas nix module is available.
    # masApps = {
    #   "AusweisApp" = 948660805;
    #   "Draw Things" = 6444050820;
    #   "eduVPN" = 1317704208;
    #   "Moonfin" = 6761283970;
    #   "uBlock Origin Lite" = 6745342698;
    #   "WireGuard" = 1451685025;
    #   "Xcode" = 497799835;
    # };
  };
}
