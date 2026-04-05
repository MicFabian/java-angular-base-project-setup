#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <feature-name>"
  echo "Example: $0 billing"
  exit 1
fi

RAW_FEATURE="$1"
FEATURE="$(echo "$RAW_FEATURE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/_/g; s/^_+|_+$//g')"

if [[ -z "$FEATURE" ]]; then
  echo "Feature name '$RAW_FEATURE' is invalid after normalization."
  exit 1
fi

if [[ ! "$FEATURE" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Feature name '$FEATURE' must start with a letter and contain only lowercase letters, numbers, and underscores."
  exit 1
fi

MAIN_BASE="server/src/main/java/com/example/baseproject/api/features/$FEATURE"
TEST_BASE="server/src/test/groovy/com/example/baseproject/api/features/$FEATURE"

if [[ -d "$MAIN_BASE" ]]; then
  echo "Feature '$FEATURE' already exists at $MAIN_BASE"
  exit 1
fi

MAIN_DIRS=(
  "domain"
  "application/port/in"
  "application/port/out"
  "application/usecase"
  "infrastructure/config"
  "infrastructure/persistence"
  "infrastructure/client"
  "presentation/rest"
  "presentation/dto"
  "presentation/mapper"
)

TEST_DIRS=(
  "unit"
  "integration"
  "contract"
  "presentation/rest"
)

for dir in "${MAIN_DIRS[@]}"; do
  mkdir -p "$MAIN_BASE/$dir"
  touch "$MAIN_BASE/$dir/.gitkeep"
done

for dir in "${TEST_DIRS[@]}"; do
  mkdir -p "$TEST_BASE/$dir"
  touch "$TEST_BASE/$dir/.gitkeep"
done

cat > "$MAIN_BASE/README.md" <<EOF
# ${FEATURE^} Feature

Clean architecture structure:
- domain: entities, value objects, domain rules
- application: use cases and input/output ports
- infrastructure: adapters for persistence and external systems
- presentation: REST controllers, DTOs, and mappers

Rules:
- Keep infrastructure communication behind output ports.
- Use explicit *UseCase classes as entry points.
- Avoid generic *Service classes.
EOF

echo "Created backend feature scaffold:"
echo "  $MAIN_BASE"
echo "  $TEST_BASE"
echo "Next: implement ports/use cases and run ./gradlew :server:test"
