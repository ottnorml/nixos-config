#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT

mkdir -p "$fixture/modules/shared/config"
cat > "$fixture/modules/shared/config/do-not-track.env" <<'EOF'
# do_not_track.env
# upstream old value
EXAMPLE_TELEMETRY=old
EOF

cat > "$fixture/upstream.env" <<'EOF'
# do_not_track.env
# upstream new value
EXAMPLE_TELEMETRY=new
EOF

before=$(<"$fixture/modules/shared/config/do-not-track.env")
TELEMETRY_UPDATE_ROOT="$fixture" \
  TELEMETRY_UPDATE_SOURCE="$fixture/upstream.env" \
  "$script_dir/apps/update-telemetry" >/dev/null
after_dry_run=$(<"$fixture/modules/shared/config/do-not-track.env")
test "$before" = "$after_dry_run"

TELEMETRY_UPDATE_ROOT="$fixture" \
  TELEMETRY_UPDATE_SOURCE="$fixture/upstream.env" \
  "$script_dir/apps/update-telemetry" --write >/dev/null

grep -Fx '# upstream new value' "$fixture/modules/shared/config/do-not-track.env"
grep -Fx 'EXAMPLE_TELEMETRY=new' "$fixture/modules/shared/config/do-not-track.env"

if grep -Fq 'nixos-config local telemetry additions' "$fixture/modules/shared/config/do-not-track.env" ||
  grep -Fq 'LOCAL_TELEMETRY' "$fixture/modules/shared/config/do-not-track.env"; then
  echo "local telemetry block survived upstream-only update" >&2
  exit 1
fi

if grep -Fx 'EXAMPLE_TELEMETRY=old' "$fixture/modules/shared/config/do-not-track.env"; then
  echo "old upstream value survived update" >&2
  exit 1
fi

after_write=$(<"$fixture/modules/shared/config/do-not-track.env")
second_run=$(TELEMETRY_UPDATE_ROOT="$fixture" \
  TELEMETRY_UPDATE_SOURCE="$fixture/upstream.env" \
  "$script_dir/apps/update-telemetry")
test "$second_run" = "Telemetry snapshot is already up to date."
test "$after_write" = "$(<"$fixture/modules/shared/config/do-not-track.env")"

cat > "$fixture/invalid-upstream.env" <<'EOF'
# unexpected.env
EXAMPLE_TELEMETRY=invalid
EOF

before_invalid=$(<"$fixture/modules/shared/config/do-not-track.env")
if TELEMETRY_UPDATE_ROOT="$fixture" \
  TELEMETRY_UPDATE_SOURCE="$fixture/invalid-upstream.env" \
  "$script_dir/apps/update-telemetry" --write >/dev/null 2>&1; then
  echo "invalid upstream identity was accepted" >&2
  exit 1
fi
test "$before_invalid" = "$(<"$fixture/modules/shared/config/do-not-track.env")"
