#!/bin/bash
set -e

# Ждем, пока мастер станет доступен
until pg_isready -h pg_primary -p 5432 -U postgres; do
  echo "Waiting for master..."
  sleep 2
done

# Если данных еще нет, делаем бекап
if [ ! -s "$PGDATA/PG_VERSION" ]; then
  echo "Clearing data directory and starting basebackup..."
  rm -rf "$PGDATA"/*
  PGPASSWORD=pass pg_basebackup -h pg_primary -D "$PGDATA" -U replicator -vP -R
fi

# Запускаем Postgres
exec docker-entrypoint.sh postgres