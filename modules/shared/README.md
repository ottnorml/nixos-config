## Shared

Much of the code running on MacOS or NixOS is actually found here.

This configuration gets imported by both modules. Some configuration examples include `git`, `zsh`, `vim`, and `tmux`.

## Layout

```
.
├── config/            # Config files not written in Nix
├── default.nix        # Shared module entry point and overlays
├── files.nix          # Non-Nix, static configuration files
├── home-manager.nix   # Shared Home Manager configuration
├── packages.nix       # Shared package list
├── telemetry.nix      # Shared telemetry environment module
└── telemetry-parser.nix # Parser and composition of telemetry variables

```

## Telemetry opt-outs

The shared telemetry module imports the active entries from
[`config/do-not-track.env`](./config/do-not-track.env) and exposes them through
`environment.variables` on both Darwin and NixOS. Commented entries remain
available in the snapshot but are not enabled.

The file is a versioned snapshot of the active entries from
[`alloydwhitlock/do-not-track-cli`](https://github.com/alloydwhitlock/do-not-track-cli).
Keeping the snapshot in the repository makes changes reviewable and avoids
changing system configuration merely because the upstream file changed.
The snapshot header records the upstream commit and import timestamp.

Preview an update with:

```sh
nix run .#update-telemetry
```

Apply it explicitly with:

```sh
nix run .#update-telemetry -- --write
```

The command resolves the current `main` commit first and fetches that exact
revision. `--write` is the only mode that changes the working tree. The
snapshot header records the resolved commit and the UTC import time, so every
update can be reviewed and reproduced.

OpenSpec, CocoIndex, and Serena are local additions. They are surrounded by
`nixos-config local telemetry additions` markers and are carried forward when
the upstream snapshot is refreshed.

Values are composed in this order:

1. the upstream catalog
2. `privacy.telemetry.extraVariables`
3. `privacy.telemetry.overrides`
4. names listed in `privacy.telemetry.disabled` are removed

Example:

```nix
{
  privacy.telemetry = {
    extraVariables = {
      MY_TOOL_TELEMETRY = "false";
    };

    overrides = {
      GH_TELEMETRY = "true";
    };

    disabled = [ "HF_HUB_DISABLE_TELEMETRY" ];
  };
}
```

To disable the shared catalog for a host:

```nix
{
  privacy.telemetry.enable = false;
}
```

On Darwin, Homebrew-specific `HOMEBREW_*` values are derived from the same
effective set and written to `homebrew/brew.env`.
