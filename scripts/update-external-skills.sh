#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$ROOT_DIR/skills-lock.json"
VERIFY_SCRIPT="$ROOT_DIR/scripts/verify-skills.sh"

if [[ ! -f "$LOCK_FILE" ]]; then
  echo "No skills lock file found at $LOCK_FILE. Nothing to update."
  exit 0
fi

if ! command -v node >/dev/null 2>&1; then
  echo "node is required but was not found in PATH."
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "npx is required but was not found in PATH."
  exit 1
fi

MODE="${1:-update}"

validate_lock_file() {
  node -e '
    const fs = require("node:fs");
    const lock = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    if (!lock || typeof lock !== "object" || !lock.skills || typeof lock.skills !== "object") {
      console.error("skills-lock.json is missing a valid \"skills\" object.");
      process.exit(1);
    }
  ' "$LOCK_FILE"
}

run_skill_verification() {
  if [[ ! -x "$VERIFY_SCRIPT" ]]; then
    echo "Skill verification script missing or not executable: $VERIFY_SCRIPT"
    exit 1
  fi
  "$VERIFY_SCRIPT"
}

case "$MODE" in
  update)
    validate_lock_file
    echo "Updating all external skills tracked in skills-lock.json..."
    # Re-installs tracked external skills to the latest source versions while
    # preserving the selected skills from the lock file.
    npx -y skills experimental_install
    echo "Running skill integrity checks..."
    run_skill_verification
    echo "External skills update completed."
    ;;
  list)
    validate_lock_file
    echo "External skill sources tracked in skills-lock.json:"
    node -e '
      const fs = require("node:fs");
      const lock = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
      const skills = lock.skills ?? {};
      const grouped = new Map();
      for (const [name, meta] of Object.entries(skills)) {
        const source = meta?.source ?? "unknown";
        if (!grouped.has(source)) grouped.set(source, []);
        grouped.get(source).push(name);
      }
      for (const [source, names] of [...grouped.entries()].sort((a, b) => a[0].localeCompare(b[0]))) {
        console.log(`- ${source} (${names.length} skills)`);
      }
    ' "$LOCK_FILE"
    ;;
  check)
    validate_lock_file
    echo "Running skill integrity checks..."
    run_skill_verification
    ;;
  *)
    echo "Usage: $0 [update|list|check]"
    exit 1
    ;;
esac
