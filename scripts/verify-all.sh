#!/usr/bin/env bash
set -euo pipefail

WITH_E2E=false
export GRADLE_USER_HOME="${GRADLE_USER_HOME:-$PWD/.gradle-user}"

if [[ "${1:-}" == "--with-e2e" ]]; then
  WITH_E2E=true
fi

echo "Verifying skills..."
./scripts/verify-skills.sh

echo "Running frontend lint..."
./scripts/pnpmw.sh nx run-many -t lint --projects=client,client-e2e

echo "Running frontend tests..."
./scripts/pnpmw.sh nx test client

echo "Building frontend..."
./scripts/pnpmw.sh nx build client

echo "Running backend tests..."
./gradlew :server:test

echo "Building backend..."
./gradlew :server:build

if [[ "$WITH_E2E" == "true" ]]; then
  echo "Running frontend e2e..."
  ./scripts/pnpmw.sh nx e2e client-e2e
fi

echo "Verification completed."
