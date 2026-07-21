let
  lib = {
    filter = builtins.filter;
    listToAttrs = builtins.listToAttrs;
    splitString = separator: value: builtins.filter builtins.isString (builtins.split separator value);
  };
  parser = import ../modules/shared/telemetry-parser.nix { inherit lib; };

  parsed = parser.parse ''
    # comment
    DO_NOT_TRACK=1
    EMPTY=
    # IGNORED=1
    VALUE_WITH_EQUALS=a=b
  '';

  effective = parser.applyOptions {
    upstreamVariables = parsed;
    extraVariables = {
      EXTRA = "true";
    };
    overrides = {
      DO_NOT_TRACK = "0";
    };
    disabled = [ "EMPTY" ];
  };

  upstream = parser.parse (builtins.readFile ../modules/shared/config/do-not-track.env);
in
assert parsed.DO_NOT_TRACK == "1";
assert parsed.EMPTY == "";
assert parsed.VALUE_WITH_EQUALS == "a=b";
assert !(parsed ? IGNORED);
assert effective.DO_NOT_TRACK == "0";
assert effective.EXTRA == "true";
assert !(effective ? EMPTY);
assert upstream.DO_NOT_TRACK == "1";
assert upstream.HOMEBREW_NO_ANALYTICS == "1";
assert upstream.HOMEBREW_NO_ANALYTICS_THIS_RUN == "1";
assert upstream.GOTELEMETRY == "off";
assert upstream.COCOINDEX_DISABLE_USAGE_TRACKING == "1";
assert upstream.OPENSPEC_TELEMETRY == "0";
assert !(upstream ? HF_HUB_OFFLINE);
assert builtins.length (builtins.attrNames upstream) > 100;
effective
