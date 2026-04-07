#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib/starter.sh
source "$SCRIPT_DIR/lib/starter.sh"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <feature-name>"
  echo "Example: $0 billing"
  exit 1
fi

load_starter_config

RAW_FEATURE="$1"
FEATURE="$(echo "$RAW_FEATURE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/_/g; s/^_+|_+$//g')"

if [[ -z "$FEATURE" ]]; then
  echo "Feature '$RAW_FEATURE' is invalid after normalization."
  exit 1
fi

if [[ ! "$FEATURE" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Feature name '$FEATURE' must start with a letter and contain only lowercase letters, numbers, and underscores."
  exit 1
fi

PACKAGE_PATH="$(package_to_path "$STARTER_JAVA_BASE_PACKAGE")"
MAIN_BASE="server/src/main/java/$PACKAGE_PATH/api"
TEST_BASE="server/src/test/groovy/$PACKAGE_PATH/api"
FEATURE_TITLE="$(derive_display_name "$FEATURE")"

if [[ -d "$MAIN_BASE/domain/$FEATURE" || -d "$MAIN_BASE/controller/$FEATURE" || -d "$MAIN_BASE/accessor/$FEATURE" ]]; then
  echo "Feature '$FEATURE' already exists in one of the backend roots."
  exit 1
fi

MAIN_DIRS=(
  "controller/$FEATURE"
  "domain/$FEATURE"
  "accessor/$FEATURE"
)

TEST_DIRS=(
  "controller/$FEATURE"
  "domain/$FEATURE"
)

for dir in "${MAIN_DIRS[@]}"; do
  mkdir -p "$MAIN_BASE/$dir"
  touch "$MAIN_BASE/$dir/.gitkeep"
done

for dir in "${TEST_DIRS[@]}"; do
  mkdir -p "$TEST_BASE/$dir"
  touch "$TEST_BASE/$dir/.gitkeep"
done

cat > "$MAIN_BASE/domain/$FEATURE/README.md" <<EOT
# $FEATURE_TITLE Backend Slice

Simple hexagonal structure:
- controller/$FEATURE: inbound HTTP classes and transport DTOs
- domain/$FEATURE: core model, use cases, and accessor interfaces
- accessor/$FEATURE: Spring wiring and outbound implementations

Rules:
- Keep Spring and infrastructure code out of domain/$FEATURE.
- Keep controllers thin and map transport models explicitly.
- Implement domain-owned accessor interfaces in accessor/$FEATURE.
- Avoid generic *Service classes.
EOT

echo "Created backend feature scaffold:"
echo "  $MAIN_BASE/controller/$FEATURE"
echo "  $MAIN_BASE/domain/$FEATURE"
echo "  $MAIN_BASE/accessor/$FEATURE"
echo "  $TEST_BASE/controller/$FEATURE"
echo "  $TEST_BASE/domain/$FEATURE"
echo "Next: implement the domain use case and accessor, then run ./gradlew :server:test"
