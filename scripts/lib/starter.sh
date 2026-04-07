#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STARTER_CONFIG_FILE="$ROOT_DIR/.starter/project-metadata.env"

load_starter_config() {
  if [[ ! -f "$STARTER_CONFIG_FILE" ]]; then
    echo "Starter config not found at $STARTER_CONFIG_FILE" >&2
    return 1
  fi

  # shellcheck disable=SC1090
  source "$STARTER_CONFIG_FILE"

  local required_vars=(
    STARTER_PROJECT_NAME
    STARTER_DISPLAY_NAME
    STARTER_JAVA_BASE_PACKAGE
    STARTER_SERVER_APP_NAME
    STARTER_DB_NAME
    STARTER_DB_USERNAME
    STARTER_DB_PASSWORD
    STARTER_DB_CONTAINER_NAME
  )

  local var_name
  for var_name in "${required_vars[@]}"; do
    if [[ -z "${!var_name:-}" ]]; then
      echo "Starter config variable '$var_name' is missing." >&2
      return 1
    fi
  done
}

require_command() {
  local command_name="$1"
  local help_text="$2"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "$help_text" >&2
    return 1
  fi
}

derive_display_name() {
  printf '%s' "$1" | sed 's/[-_]/ /g' | awk '{
    for (i = 1; i <= NF; i++) {
      $i = toupper(substr($i, 1, 1)) tolower(substr($i, 2))
    }
    print
  }'
}

package_to_path() {
  printf '%s' "$1" | tr '.' '/'
}

is_personalizable_text_file() {
  case "$1" in
    *.env|*.gradle|*.groovy|*.html|*.java|*.json|*.md|*.mjs|*.scss|*.sh|*.toml|*.ts|*.txt|*.yaml|*.yml)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

list_workspace_files() {
  if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$ROOT_DIR" ls-files -z
    return 0
  fi

  find "$ROOT_DIR" \
    \( -path "$ROOT_DIR/.git" -o -path "$ROOT_DIR/node_modules" -o -path "$ROOT_DIR/.gradle-user" -o -path "$ROOT_DIR/.gradle" \) -prune \
    -o -type f -print0
}

write_starter_config() {
  cat > "$STARTER_CONFIG_FILE" <<EOF
STARTER_PROJECT_NAME='$1'
STARTER_DISPLAY_NAME='$2'
STARTER_JAVA_BASE_PACKAGE='$3'
STARTER_SERVER_APP_NAME='$4'
STARTER_DB_NAME='$5'
STARTER_DB_USERNAME='$6'
STARTER_DB_PASSWORD='$7'
STARTER_DB_CONTAINER_NAME='$8'
EOF
}
