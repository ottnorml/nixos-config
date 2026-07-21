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

# nixos-config local telemetry additions: begin
# Local tool
LOCAL_TELEMETRY=0
# nixos-config local telemetry additions: end

# Serverless & FaaS
# BLOCK_NETWORK=1

# Aggressive / Opt-in
EOF

cat > "$fixture/upstream.env" <<'EOF'
# do_not_track.env
# upstream new value
EXAMPLE_TELEMETRY=new

# Serverless & FaaS
# BLOCK_NETWORK=1

# Aggressive / Opt-in
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
grep -Fx 'LOCAL_TELEMETRY=0' "$fixture/modules/shared/config/do-not-track.env"
grep -Fx '# BLOCK_NETWORK=1' "$fixture/modules/shared/config/do-not-track.env"

if grep -Fx 'EXAMPLE_TELEMETRY=old' "$fixture/modules/shared/config/do-not-track.env"; then
  echo "old upstream value survived update" >&2
  exit 1
fi
