{
  config,
  lib,
  ...
}:

let
  parser = import ./telemetry-parser.nix { inherit lib; };
  upstreamVariables = parser.parse (builtins.readFile ./config/do-not-track.env);
  cfg = config.privacy.telemetry;

  effectiveVariables = parser.applyOptions {
    inherit upstreamVariables;
    inherit (cfg)
      enable
      extraVariables
      overrides
      disabled
      ;
  };
in
{
  options.privacy.telemetry = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the shared telemetry opt-out environment is enabled.";
    };

    extraVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional telemetry opt-out environment variables.";
    };

    overrides = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Values overriding variables from the upstream catalog or extraVariables.";
    };

    disabled = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Variable names to remove from the effective telemetry environment.";
    };

    effectiveVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      internal = true;
      readOnly = true;
      description = "The effective telemetry variables after overrides and disabling.";
    };
  };

  config = {
    privacy.telemetry.effectiveVariables = effectiveVariables;
    environment.variables = lib.mkIf cfg.enable effectiveVariables;
  };
}
