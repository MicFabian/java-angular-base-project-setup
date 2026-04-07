#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib/starter.sh
source "$SCRIPT_DIR/lib/starter.sh"

WITH_DB=false
RUN_VERIFY=false
SKIP_INSTALL=false

usage() {
  cat <<'EOF'
Usage: ./scripts/bootstrap.sh [--with-db] [--verify] [--skip-install]

Bootstraps this starter for local development:
- checks required tooling
- installs Node dependencies
- restores project-scoped skills
- optionally starts the local PostgreSQL container
- optionally runs the standard verification flow
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-db)
      WITH_DB=true
      ;;
    --verify)
      RUN_VERIFY=true
      ;;
    --skip-install)
      SKIP_INSTALL=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

load_starter_config
cd "$ROOT_DIR"

if ! command -v pnpm >/dev/null 2>&1 && command -v corepack >/dev/null 2>&1; then
  corepack enable >/dev/null 2>&1 || true
fi

echo "Bootstrapping $STARTER_DISPLAY_NAME ($STARTER_PROJECT_NAME)"
echo "Checking local toolchain..."
if [[ "$WITH_DB" == "true" ]]; then
  ./scripts/doctor.sh --require-docker
else
  ./scripts/doctor.sh
fi

if [[ "$SKIP_INSTALL" != "true" ]]; then
  echo "Installing frontend dependencies..."
  ./scripts/pnpmw.sh install --frozen-lockfile
fi

echo "Restoring project-scoped skills..."
./scripts/pnpmw.sh run skills:restore

echo "Validating skill metadata..."
./scripts/pnpmw.sh run skills:verify

if [[ "$WITH_DB" == "true" ]]; then
  echo "Starting local PostgreSQL..."
  docker compose -f docker/compose.yaml up -d db
fi

if [[ "$RUN_VERIFY" == "true" ]]; then
  echo "Running verification..."
  ./scripts/pnpmw.sh run verify
fi

cat <<EOF
Bootstrap completed.

Next commands:
  pnpm run personalize -- --project-name your-project --display-name "Your Project" --java-base-package com.yourorg.yourproject
  pnpm run doctor:db
  pnpm run infra:up
  pnpm nx serve client
  ./gradlew :server:bootRun
EOF
