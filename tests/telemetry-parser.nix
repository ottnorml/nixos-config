let
  lib = {
    filter = builtins.filter;
    listToAttrs = builtins.listToAttrs;
    splitString = separator: value: builtins.filter builtins.isString (builtins.split separator value);
  };
  parser = import ../modules/shared/telemetry-parser.nix { inherit lib; };
  local = import ../modules/shared/telemetry-local.nix;
  telemetryModule = import ../modules/shared/telemetry.nix {
    config.privacy.telemetry = {
      enable = true;
      extraVariables = { };
      overrides = { };
      disabled = [ ];
    };
    lib = lib // {
      mkIf = _: value: value;
      mkOption = option: option;
      types = {
        attrsOf = _: null;
        bool = null;
        listOf = _: null;
        str = null;
      };
    };
  };

  parsed = parser.parse ''
    # comment
    DO_NOT_TRACK=1
    EMPTY=
    # IGNORED=1
    VALUE_WITH_EQUALS=a=b
  '';

  effective = parser.applyOptions {
    upstreamVariables = {
      SHARED = "upstream";
      DISABLED = "upstream";
    };
    localVariables = {
      SHARED = "local";
      LOCAL_ONLY = "local";
      DISABLED = "local";
    };
    extraVariables = {
      SHARED = "extra";
      EXTRA_ONLY = "extra";
      DISABLED = "extra";
    };
    overrides = {
      SHARED = "override";
      OVERRIDE_ONLY = "override";
      DISABLED = "override";
    };
    disabled = [ "DISABLED" ];
  };

  disabledWhenOff = parser.applyOptions {
    upstreamVariables = parsed;
    enable = false;
  };

  upstream = parser.parse (builtins.readFile ../modules/shared/config/do-not-track.env);
in
assert builtins.pathExists ../modules/shared/telemetry-local.nix;
assert local.COCOINDEX_DISABLE_USAGE_TRACKING == "1";
assert local.OPENSPEC_TELEMETRY == "0";
assert local.SERENA_USAGE_REPORTING == "false";
assert
  telemetryModule.config.privacy.telemetry.effectiveVariables.COCOINDEX_DISABLE_USAGE_TRACKING == "1";
assert parsed.DO_NOT_TRACK == "1";
assert parsed.EMPTY == "";
assert parsed.VALUE_WITH_EQUALS == "a=b";
assert !(parsed ? IGNORED);
assert effective.SHARED == "override";
assert effective.LOCAL_ONLY == "local";
assert effective.EXTRA_ONLY == "extra";
assert effective.OVERRIDE_ONLY == "override";
assert !(effective ? DISABLED);
assert disabledWhenOff == { };
assert upstream.DO_NOT_TRACK == "1";
assert upstream.HOMEBREW_NO_ANALYTICS == "1";
assert upstream.HOMEBREW_NO_ANALYTICS_THIS_RUN == "1";
assert upstream.GOTELEMETRY == "off";
assert !(upstream ? COCOINDEX_DISABLE_USAGE_TRACKING);
assert !(upstream ? OPENSPEC_TELEMETRY);
assert !(upstream ? SERENA_USAGE_REPORTING);
assert !(upstream ? HF_HUB_OFFLINE);
assert builtins.length (builtins.attrNames upstream) > 100;
effective
