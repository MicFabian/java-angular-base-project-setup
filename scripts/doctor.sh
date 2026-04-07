#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib/starter.sh
source "$SCRIPT_DIR/lib/starter.sh"

QUIET=false
REQUIRE_DOCKER=false

usage() {
  cat <<'EOF'
Usage: ./scripts/doctor.sh [--quiet] [--require-docker]

Checks whether this machine matches the starter baseline:
- git
- Node.js 22.15.1+ on the 22.x line
- pnpm or corepack
- Java 21+
- optional Docker availability
EOF
}

log() {
  if [[ "$QUIET" != "true" ]]; then
    echo "$@"
  fi
}

fail() {
  echo "$@" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet)
      QUIET=true
      ;;
    --require-docker)
      REQUIRE_DOCKER=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown option: $1"
      ;;
  esac
  shift
done

load_starter_config

require_command git "git is required for this repository." || exit 1
require_command node "Node.js 22.x is required. Run 'nvm use' to pick up .nvmrc." || exit 1
require_command java "Java 21 is required for the backend toolchain." || exit 1

if ! node -e 'const [major, minor, patch] = process.versions.node.split(".").map(Number); const ok = major === 22 && (minor > 15 || (minor === 15 && patch >= 1)); process.exit(ok ? 0 : 1);'; then
  fail "Node.js 22.15.1 or newer on the 22.x line is required. Run 'nvm use' before continuing."
fi

if ! command -v pnpm >/dev/null 2>&1 && ! command -v corepack >/dev/null 2>&1; then
  fail "pnpm or corepack is required to run workspace commands."
fi

JAVA_VERSION_RAW="$(java -version 2>&1 | head -n 1)"

if ! java -version 2>&1 | awk -F '"' '/version/ { split($2, parts, "."); major = parts[1]; if (major == 1) major = parts[2]; exit !(major >= 21) }'; then
  fail "Java 21 or newer is required. Current runtime: $JAVA_VERSION_RAW"
fi

if [[ "$REQUIRE_DOCKER" == "true" ]]; then
  require_command docker "Docker is required for this workflow." || exit 1
  if ! docker info >/dev/null 2>&1; then
    fail "Docker is installed but not responding. Start Docker Desktop or the Docker daemon."
  fi
fi

log "Doctor check passed for $STARTER_DISPLAY_NAME ($STARTER_PROJECT_NAME)"
log "Node: $(node --version)"
log "Java: $JAVA_VERSION_RAW"
if command -v pnpm >/dev/null 2>&1; then
  log "pnpm: $(pnpm --version)"
else
  log "pnpm: available via corepack"
fi
if [[ "$REQUIRE_DOCKER" == "true" ]]; then
  log "Docker: available"
fi
