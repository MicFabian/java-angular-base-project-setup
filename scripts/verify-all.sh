#!/usr/bin/env bash
set -euo pipefail

WITH_E2E=false
export GRADLE_USER_HOME="${GRADLE_USER_HOME:-$PWD/.gradle-user}"

if [[ "${1:-}" == "--with-e2e" ]]; then
  WITH_E2E=true
fi

echo "Verifying skills..."
./scripts/verify-skills.sh

echo "Checking formatting..."
./scripts/pnpmw.sh run format:check

echo "Running frontend lint..."
./scripts/pnpmw.sh nx run-many -t lint --projects=client,client-e2e

echo "Running frontend tests..."
./scripts/pnpmw.sh nx test client

echo "Building frontend..."
./scripts/pnpmw.sh nx build client

echo "Running backend tests..."
./scripts/gradlew-local.sh :server:test

echo "Building backend..."
./scripts/gradlew-local.sh :server:build

if [[ "$WITH_E2E" == "true" ]]; then
  echo "Running frontend e2e..."
  ./scripts/pnpmw.sh nx e2e client-e2e
fi

echo "Verification completed."
