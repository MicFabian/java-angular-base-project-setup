#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib/starter.sh
source "$SCRIPT_DIR/lib/starter.sh"

NEW_PROJECT_NAME=""
NEW_DISPLAY_NAME=""
NEW_JAVA_BASE_PACKAGE=""
NEW_SERVER_APP_NAME=""
NEW_DB_NAME=""
NEW_DB_USERNAME=""
NEW_DB_PASSWORD=""
NEW_DB_CONTAINER_NAME=""
DRY_RUN=false

usage() {
  cat <<'EOF'
Usage: ./scripts/personalize-template.sh --project-name <kebab-case> --java-base-package <package> [options]

Required:
  --project-name        Project slug used for package.json and Gradle root project name
  --java-base-package   Base Java package without the trailing .api (example: com.acme.orders)

Optional:
  --display-name        Human-readable display name (default: title-cased project name)
  --server-app-name     Spring application name (default: <project-name>-api)
  --db-name             Default local PostgreSQL database name (default: project name in snake_case)
  --db-username         Default local PostgreSQL username (default: db name)
  --db-password         Default local PostgreSQL password (default: db username)
  --db-container-name   Docker container name (default: <project-name>-db)
  --dry-run             Print the planned changes without writing files
EOF
}

validate_project_name() {
  [[ "$1" =~ ^[a-z][a-z0-9-]*$ ]]
}

validate_java_package() {
  [[ "$1" =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$ ]]
}

validate_database_identifier() {
  [[ "$1" =~ ^[a-z][a-z0-9_]*$ ]]
}

replace_across_tracked_text_files() {
  local old_value="$1"
  local new_value="$2"

  if [[ "$old_value" == "$new_value" ]]; then
    return 0
  fi

  while IFS= read -r -d '' file; do
    local relative_file="${file#$ROOT_DIR/}"

    if is_personalizable_text_file "$relative_file"; then
      OLD_VALUE="$old_value" NEW_VALUE="$new_value" perl -0pi -e 's/\Q$ENV{OLD_VALUE}\E/$ENV{NEW_VALUE}/g' "$file"
    fi
  done < <(list_workspace_files)
}

move_package_tree() {
  local source_root="$1"
  local old_package="$2"
  local new_package="$3"

  if [[ "$old_package" == "$new_package" ]]; then
    return 0
  fi

  local old_path="$source_root/$(package_to_path "$old_package")"
  local new_path="$source_root/$(package_to_path "$new_package")"

  if [[ -d "$old_path" ]]; then
    mkdir -p "$(dirname "$new_path")"
    mv "$old_path" "$new_path"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-name)
      NEW_PROJECT_NAME="${2:-}"
      shift
      ;;
    --display-name)
      NEW_DISPLAY_NAME="${2:-}"
      shift
      ;;
    --java-base-package)
      NEW_JAVA_BASE_PACKAGE="${2:-}"
      shift
      ;;
    --server-app-name)
      NEW_SERVER_APP_NAME="${2:-}"
      shift
      ;;
    --db-name)
      NEW_DB_NAME="${2:-}"
      shift
      ;;
    --db-username)
      NEW_DB_USERNAME="${2:-}"
      shift
      ;;
    --db-password)
      NEW_DB_PASSWORD="${2:-}"
      shift
      ;;
    --db-container-name)
      NEW_DB_CONTAINER_NAME="${2:-}"
      shift
      ;;
    --dry-run)
      DRY_RUN=true
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

if [[ -z "$NEW_PROJECT_NAME" || -z "$NEW_JAVA_BASE_PACKAGE" ]]; then
  usage >&2
  exit 1
fi

if [[ -z "$NEW_DISPLAY_NAME" ]]; then
  NEW_DISPLAY_NAME="$(derive_display_name "$NEW_PROJECT_NAME")"
fi

PROJECT_NAME_SNAKE="${NEW_PROJECT_NAME//-/_}"
: "${NEW_SERVER_APP_NAME:=${NEW_PROJECT_NAME}-api}"
: "${NEW_DB_NAME:=$PROJECT_NAME_SNAKE}"
: "${NEW_DB_USERNAME:=$NEW_DB_NAME}"
: "${NEW_DB_PASSWORD:=$NEW_DB_USERNAME}"
: "${NEW_DB_CONTAINER_NAME:=${NEW_PROJECT_NAME}-db}"

if ! validate_project_name "$NEW_PROJECT_NAME"; then
  echo "Project name must be kebab-case." >&2
  exit 1
fi

if ! validate_java_package "$NEW_JAVA_BASE_PACKAGE"; then
  echo "Java base package must look like com.example.project." >&2
  exit 1
fi

if ! validate_database_identifier "$NEW_DB_NAME" || ! validate_database_identifier "$NEW_DB_USERNAME"; then
  echo "Database name and username must use lowercase letters, digits, and underscores." >&2
  exit 1
fi

if [[ -z "$NEW_DB_PASSWORD" ]]; then
  echo "Database password must not be empty." >&2
  exit 1
fi

cat <<EOF
Personalizing starter:
  project name:      $STARTER_PROJECT_NAME -> $NEW_PROJECT_NAME
  display name:      $STARTER_DISPLAY_NAME -> $NEW_DISPLAY_NAME
  java base package: $STARTER_JAVA_BASE_PACKAGE -> $NEW_JAVA_BASE_PACKAGE
  server app name:   $STARTER_SERVER_APP_NAME -> $NEW_SERVER_APP_NAME
  db name:           $STARTER_DB_NAME -> $NEW_DB_NAME
  db username:       $STARTER_DB_USERNAME -> $NEW_DB_USERNAME
  db password:       [updated]
  db container name: $STARTER_DB_CONTAINER_NAME -> $NEW_DB_CONTAINER_NAME
EOF

if [[ "$DRY_RUN" == "true" ]]; then
  exit 0
fi

move_package_tree "$ROOT_DIR/server/src/main/java" "$STARTER_JAVA_BASE_PACKAGE" "$NEW_JAVA_BASE_PACKAGE"
move_package_tree "$ROOT_DIR/server/src/test/groovy" "$STARTER_JAVA_BASE_PACKAGE" "$NEW_JAVA_BASE_PACKAGE"
move_package_tree "$ROOT_DIR/server/src/test/resources/snapshots" "$STARTER_JAVA_BASE_PACKAGE" "$NEW_JAVA_BASE_PACKAGE"

replace_across_tracked_text_files "$STARTER_SERVER_APP_NAME" "$NEW_SERVER_APP_NAME"
replace_across_tracked_text_files "$STARTER_DB_CONTAINER_NAME" "$NEW_DB_CONTAINER_NAME"
replace_across_tracked_text_files "$STARTER_JAVA_BASE_PACKAGE" "$NEW_JAVA_BASE_PACKAGE"
replace_across_tracked_text_files "$STARTER_DISPLAY_NAME" "$NEW_DISPLAY_NAME"
replace_across_tracked_text_files "$STARTER_PROJECT_NAME" "$NEW_PROJECT_NAME"

NEW_VALUE="$NEW_DB_NAME" perl -0pi -e 's/(\$\{APP_DB_NAME:)[^}]+(\})/$1 . $ENV{NEW_VALUE} . $2/ge' "$ROOT_DIR/server/src/main/resources/application.yml"
NEW_VALUE="$NEW_DB_USERNAME" perl -0pi -e 's/(\$\{APP_DB_USERNAME:)[^}]+(\})/$1 . $ENV{NEW_VALUE} . $2/ge' "$ROOT_DIR/server/src/main/resources/application.yml"
NEW_VALUE="$NEW_DB_PASSWORD" perl -0pi -e 's/(\$\{APP_DB_PASSWORD:)[^}]+(\})/$1 . $ENV{NEW_VALUE} . $2/ge' "$ROOT_DIR/server/src/main/resources/application.yml"

NEW_VALUE="$NEW_DB_NAME" perl -0pi -e 's/(POSTGRES_DB:\s+).+/$1$ENV{NEW_VALUE}/m' "$ROOT_DIR/docker/compose.yaml"
NEW_VALUE="$NEW_DB_USERNAME" perl -0pi -e 's/(POSTGRES_USER:\s+).+/$1$ENV{NEW_VALUE}/m' "$ROOT_DIR/docker/compose.yaml"
NEW_VALUE="$NEW_DB_PASSWORD" perl -0pi -e 's/(POSTGRES_PASSWORD:\s+).+/$1$ENV{NEW_VALUE}/m' "$ROOT_DIR/docker/compose.yaml"
NEW_DB_NAME="$NEW_DB_NAME" NEW_DB_USERNAME="$NEW_DB_USERNAME" perl -0pi -e 's/(pg_isready -U )\S+( -d )\S+/$1 . $ENV{NEW_DB_USERNAME} . $2 . $ENV{NEW_DB_NAME}/ge' "$ROOT_DIR/docker/compose.yaml"

NEW_VALUE="$NEW_PROJECT_NAME" perl -0pi -e 's/(jdbc:h2:mem:)[^;]+;/$1 . $ENV{NEW_VALUE} . q(;)/ge' "$ROOT_DIR/server/src/test/resources/application-test.yml"

NEW_VALUE="$NEW_DB_NAME" perl -0pi -e "s/(withDatabaseName\\(')[^']+('\\))/\$1 . \$ENV{NEW_VALUE} . \$2/ge" "$ROOT_DIR/server/src/test/groovy/$(package_to_path "$NEW_JAVA_BASE_PACKAGE")/api/testsupport/container/PostgresContainerConfiguration.groovy"
NEW_VALUE="$NEW_DB_USERNAME" perl -0pi -e "s/(withUsername\\(')[^']+('\\))/\$1 . \$ENV{NEW_VALUE} . \$2/ge" "$ROOT_DIR/server/src/test/groovy/$(package_to_path "$NEW_JAVA_BASE_PACKAGE")/api/testsupport/container/PostgresContainerConfiguration.groovy"
NEW_VALUE="$NEW_DB_PASSWORD" perl -0pi -e "s/(withPassword\\(')[^']+('\\))/\$1 . \$ENV{NEW_VALUE} . \$2/ge" "$ROOT_DIR/server/src/test/groovy/$(package_to_path "$NEW_JAVA_BASE_PACKAGE")/api/testsupport/container/PostgresContainerConfiguration.groovy"

NEW_VALUE="$NEW_DB_NAME" perl -0pi -e 's/(- `APP_DB_NAME` \(default: `)[^`]+(`\))/$1 . $ENV{NEW_VALUE} . $2/ge' "$ROOT_DIR/README.md"
NEW_VALUE="$NEW_DB_USERNAME" perl -0pi -e 's/(- `APP_DB_USERNAME` \(default: `)[^`]+(`\))/$1 . $ENV{NEW_VALUE} . $2/ge' "$ROOT_DIR/README.md"
NEW_VALUE="$NEW_DB_PASSWORD" perl -0pi -e 's/(- `APP_DB_PASSWORD` \(default: `)[^`]+(`\))/$1 . $ENV{NEW_VALUE} . $2/ge' "$ROOT_DIR/README.md"

write_starter_config \
  "$NEW_PROJECT_NAME" \
  "$NEW_DISPLAY_NAME" \
  "$NEW_JAVA_BASE_PACKAGE" \
  "$NEW_SERVER_APP_NAME" \
  "$NEW_DB_NAME" \
  "$NEW_DB_USERNAME" \
  "$NEW_DB_PASSWORD" \
  "$NEW_DB_CONTAINER_NAME"

echo "Starter personalization completed."
echo "Next: run ./scripts/bootstrap.sh --with-db"
