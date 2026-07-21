#!/bin/sh
set -eu

for script in apps/aarch64-darwin/build apps/x86_64-darwin/build; do
  grep -F 'build .#$FLAKE_SYSTEM --print-out-paths "$@"' "$script" >/dev/null
done

if grep -Eq 'pkgs\.system([^[:alnum:]_]|$)' modules/shared/packages.nix; then
  echo "deprecated pkgs.system reference found" >&2
  exit 1
fi
