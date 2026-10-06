#!/usr/bin/with-contenv bashio

# ============================================================================
# Blinko Home Assistant Addon — Entry Script
# ============================================================================

CONFIG_PATH=/data/options.json

# Create default options.json if not present (e.g. on first run with mounted volume)
if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{"db_url":"","nextauth_url":""}' > "${CONFIG_PATH}"
fi

# --------------------------------------------------------------------------
# Read options from config
# --------------------------------------------------------------------------
DB_URL=$(bashio::config 'db_url')
NEXTAUTH_URL=$(bashio::config 'nextauth_url')

# --------------------------------------------------------------------------
# NEXTAUTH_SECRET — generate once, persist in /data
# --------------------------------------------------------------------------
SECRET_FILE="/data/nextauth_secret"
if [ ! -f "${SECRET_FILE}" ]; then
    head -c 48 /dev/urandom | base64 | tr -d '\n' > "${SECRET_FILE}"
    chmod 600 "${SECRET_FILE}"
fi
export NEXTAUTH_SECRET
NEXTAUTH_SECRET=$(cat "${SECRET_FILE}")

if [ -n "${NEXTAUTH_URL}" ]; then
    export NEXTAUTH_URL
    export NEXT_PUBLIC_BASE_URL="${NEXTAUTH_URL}"
fi

# --------------------------------------------------------------------------
# Database: bundled PostgreSQL (default) or an external server via db_url
# --------------------------------------------------------------------------
export NODE_ENV=production
PGDATA="/data/postgres"
DB_MODE="bundled postgresql (in /data/postgres)"
BUNDLED_PG=false

if [ -z "${DB_URL}" ]; then
    BUNDLED_PG=true
    DB_MODE="bundled postgresql (in /data/postgres)"

    # PostgreSQL needs its socket/lock directory to exist and be writable
    mkdir -p /run/postgresql
    chown postgres:postgres /run/postgresql

    # Initialize the cluster on first run (mirrors the securo add-on)
    if [ ! -f "${PGDATA}/PG_VERSION" ]; then
        bashio::log.info "Initializing bundled PostgreSQL in ${PGDATA}..."
        mkdir -p "${PGDATA}"
        chown -R postgres:postgres "${PGDATA}"
        su -s /bin/sh postgres -c "initdb -D ${PGDATA} --encoding=UTF8 --locale=C" \
            || { bashio::log.error "initdb failed!"; exit 1; }
        su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} -w start" \
            || { bashio::log.error "initial PostgreSQL start failed!"; exit 1; }
        su -s /bin/sh postgres -c "createdb -U postgres blinko" \
            || { bashio::log.error "createdb blinko failed!"; exit 1; }
        su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} stop"
    else
        bashio::log.info "PostgreSQL data directory exists, skipping init."
    fi

    chown -R postgres:postgres "${PGDATA}"

    bashio::log.info "Starting bundled PostgreSQL..."
    su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} -w -l /var/log/postgresql.log start" \
        || { bashio::log.error "PostgreSQL failed to start!"; exit 1; }

    # Wait for PostgreSQL to be ready
    for i in $(seq 1 30); do
        if su -s /bin/sh postgres -c "pg_isready -q" 2>/dev/null; then
            break
        fi
        sleep 1
    done
    if ! su -s /bin/sh postgres -c "pg_isready -q" 2>/dev/null; then
        bashio::log.error "PostgreSQL failed to become ready!"
        exit 1
    fi

    # Create the database if it doesn't exist
    su -s /bin/sh postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname = 'blinko'\" | grep -q 1" \
        || su -s /bin/sh postgres -c "createdb -U postgres blinko"

    export DATABASE_URL="postgresql://postgres@127.0.0.1:5432/blinko"
    bashio::log.info "Bundled PostgreSQL is ready."
else
    DB_MODE="(external postgresql)"
    export DATABASE_URL="${DB_URL}"
    # Mask credentials for the log: scheme://user:***@host/db
    MASKED_DSN=$(printf '%s' "${DB_URL}" | sed -E 's#^([a-zA-Z+]+://[^:/]+):[^@]*@#\1:***@#')
    DB_MODE="(external postgresql: ${MASKED_DSN})"

    # Best-effort one-time CREATE DATABASE (Blinko's migrations need an existing DB).
    if dsn_parts=$(python3 - "${DB_URL}" <<'PYEOF'
import sys
from urllib.parse import urlparse, unquote

u = urlparse(sys.argv[1])
if u.scheme not in ("postgres", "postgresql") or not u.hostname or not u.path.strip("/"):
    sys.exit(1)
print("\n".join([
    u.hostname,
    str(u.port or 5432),
    unquote(u.username or ""),
    unquote(u.password or ""),
    u.path.lstrip("/"),
]))
PYEOF
    ); then
        mapfile -t pg <<< "${dsn_parts}"
        if [ "${#pg[@]}" -eq 5 ]; then
            PG_HOST="${pg[0]}"
            PG_PORT="${pg[1]}"
            PG_USER="${pg[2]}"
            PG_PASS="${pg[3]}"
            PG_DB="${pg[4]}"
            PG_DB_ESC=${PG_DB//\"/\"\"}
            if CREATE_OUT=$(PGPASSWORD="${PG_PASS}" psql -h "${PG_HOST}" -p "${PG_PORT}" \
                    -U "${PG_USER}" -d postgres -v ON_ERROR_STOP=1 \
                    -c "CREATE DATABASE \"${PG_DB_ESC}\";" 2>&1); then
                bashio::log.info "PostgreSQL: created database \"${PG_DB}\" on ${PG_HOST}:${PG_PORT}."
            elif printf '%s' "${CREATE_OUT}" | grep -qi 'already exists'; then
                bashio::log.info "PostgreSQL: database \"${PG_DB}\" already exists on ${PG_HOST}:${PG_PORT}."
            else
                bashio::log.warn "PostgreSQL: could not create database \"${PG_DB}\" — ${CREATE_OUT}"
                bashio::log.warn "Make sure the database exists and the DSN credentials are correct."
            fi
        else
            bashio::log.warn "Could not parse db_url (URL form expected); skipping automatic database creation."
        fi
    else
        bashio::log.warn "Could not parse db_url (URL form expected); skipping automatic database creation."
    fi
fi

# --------------------------------------------------------------------------
# Local storage — keep /app/.blinko (symlinked) inside /data
# --------------------------------------------------------------------------
mkdir -p /data/.blinko

# --------------------------------------------------------------------------
# Migrations + seed + start (replicates upstream start.sh with error handling)
# --------------------------------------------------------------------------
cd /app || exit 1

bashio::log.info "Running database migrations..."
if ! npx prisma migrate deploy; then
    bashio::log.error "Prisma migrations failed! Check your database settings."
    exit 1
fi

node server/seed.js || bashio::log.warn "seed.js returned a non-zero exit code."

bashio::log.info "Starting Blinko — db: ${DB_MODE}, storage: /data/.blinko"
node server/index.js &
APP_PID=$!

# --------------------------------------------------------------------------
# Shutdown: stop Blinko, then the bundled PostgreSQL (if running)
# --------------------------------------------------------------------------
cleanup() {
    bashio::log.info "Shutting down Blinko..."
    [ -n "${APP_PID}" ] && kill "${APP_PID}" 2>/dev/null
    if [ "${BUNDLED_PG}" = "true" ]; then
        su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} stop -m fast" 2>/dev/null
    fi
    exit 0
}
trap cleanup SIGTERM SIGINT

wait "${APP_PID}"
