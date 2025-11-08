#!/usr/bin/env bash
set -euo pipefail

# Wait for Postgres to be ready
echo "Waiting for db to be ready..."
until python - <<'PY'
import os, sys, time
import psycopg2
try:
    conn = psycopg2.connect(
        dbname=os.environ.get("POSTGRES_DB"),
        user=os.environ.get("POSTGRES_USER"),
        password=os.environ.get("POSTGRES_PASSWORD"),
        host=os.environ.get("POSTGRES_HOST", "db"),
        port=int(os.environ.get("POSTGRES_PORT","5432")),
        connect_timeout=3,
    )
    conn.close()
except Exception as e:
    sys.exit(1)
PY
do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done
echo "DB is up."

# Apply migrations and start server
python manage.py migrate --noinput || true
python manage.py runserver 0.0.0.0:8000