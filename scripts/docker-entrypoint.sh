#!/bin/sh
set -e

DB="/data/escola.db"

if [ ! -f "$DB" ]; then
  echo "[lyvia] Banco nao encontrado. Criando $DB ..."
  sqlite3 "$DB" < /opt/lyvia/init.sql
  echo "[lyvia] Banco criado com sucesso."
fi

exec npm start --cache /data/.npm --userDir /data "$@"
