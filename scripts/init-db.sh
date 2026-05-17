#!/usr/bin/env sh
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DB="$ROOT/nodered-data/escola.db"
INIT="$ROOT/db/init.sql"

if [ -f "$DB" ]; then
  echo "Banco ja existe: $DB"
  exit 0
fi

if command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 "$DB" < "$INIT"
  echo "Banco criado: $DB"
  exit 0
fi

if command -v docker >/dev/null 2>&1; then
  docker run --rm \
    -v "$ROOT/nodered-data:/data" \
    -v "$ROOT/db:/db:ro" \
    alpine:3.20 \
    sh -c "apk add --no-cache sqlite >/dev/null && sqlite3 /data/escola.db < /db/init.sql"
  echo "Banco criado via Docker: $DB"
  exit 0
fi

echo "Erro: instale sqlite3 ou Docker para criar o banco." >&2
exit 1
