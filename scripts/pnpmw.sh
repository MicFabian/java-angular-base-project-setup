#!/usr/bin/env bash
set -euo pipefail

if command -v pnpm >/dev/null 2>&1; then
  exec pnpm "$@"
fi

if command -v corepack >/dev/null 2>&1; then
  exec corepack pnpm "$@"
fi

echo "pnpm was not found and corepack is unavailable." >&2
exit 1
