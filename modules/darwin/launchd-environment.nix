{ lib, ... }:

let
  user = "spt";
  home = "/Users/${user}";

  xdgEnvironment = {
    XDG_BIN_HOME = "${home}/.local/bin";
    XDG_CACHE_HOME = "${home}/.cache";
    XDG_CONFIG_HOME = "${home}/.config";
    XDG_DATA_HOME = "${home}/.local/share";
    XDG_STATE_HOME = "${home}/.local/state";
  };
in
{
  launchd.user.agents.xdg-environment = {
    script = lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (name: value: "/bin/launchctl setenv ${name} ${lib.escapeShellArg value}")
        xdgEnvironment
    );

    serviceConfig = {
      RunAtLoad = true;
      LaunchOnlyOnce = true;
    };
  };
}
