#!/usr/bin/with-contenv bashio

# ============================================================================
# Memos Home Assistant Addon — Entry Script
# ============================================================================

CONFIG_PATH=/data/options.json

# Create default options.json if not present (e.g. on first run with mounted volume)
if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{"instance_url":"","log_level":"info","db_driver":"sqlite","db_dsn":""}' > "${CONFIG_PATH}"
fi

# --------------------------------------------------------------------------
# Read options from config
# --------------------------------------------------------------------------
INSTANCE_URL=$(bashio::config 'instance_url')
LOG_LEVEL=$(bashio::config 'log_level')
DB_DRIVER=$(bashio::config 'db_driver')
DB_DSN=$(bashio::config 'db_dsn')

# Defaults when running outside the HA supervisor (the stub returns '' for missing keys)
[ -n "${LOG_LEVEL}" ] || LOG_LEVEL="info"
[ -n "${DB_DRIVER}" ] || DB_DRIVER="sqlite"

# --------------------------------------------------------------------------
# Environment for Memos
# --------------------------------------------------------------------------
export MEMOS_PORT=5230
export MEMOS_ADDR=""
export MEMOS_DATA=/data
export MEMOS_LOG_LEVEL="${LOG_LEVEL}"

if [ -n "${INSTANCE_URL}" ]; then
    export MEMOS_INSTANCE_URL="${INSTANCE_URL}"
fi

# --------------------------------------------------------------------------
# Database: SQLite (default) or an external PostgreSQL / MySQL server
# --------------------------------------------------------------------------
MASKED_DSN="(sqlite: stored in /data)"

if [ "${DB_DRIVER}" != "sqlite" ] && [ -n "${DB_DSN}" ]; then
    export MEMOS_DRIVER="${DB_DRIVER}"
    export MEMOS_DSN="${DB_DSN}"
    # Mask credentials for the log: scheme://user:***@host/db
    MASKED_DSN=$(printf '%s' "${DB_DSN}" | sed -E 's#^([a-zA-Z+]+://[^:/]+):[^@]*@#\1:***@#')

    if [ "${DB_DRIVER}" = "postgres" ]; then
        # Best-effort one-time CREATE DATABASE (Memos does not create it itself).
        if dsn_parts=$(python3 - "${DB_DSN}" <<'PYEOF'
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
                # Escape double quotes for the SQL identifier
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
                bashio::log.warn "Could not parse DSN (URL form expected); skipping automatic database creation."
            fi
        else
            bashio::log.warn "Could not parse DSN (URL form expected); skipping automatic database creation."
        fi
    elif [ "${DB_DRIVER}" = "mysql" ]; then
        bashio::log.info "MySQL: make sure the target database exists before starting Memos."
    fi
elif [ "${DB_DRIVER}" != "sqlite" ]; then
    bashio::log.warn "db_driver is set to \"${DB_DRIVER}\" but db_dsn is empty — falling back to SQLite."
    MASKED_DSN="(db_dsn empty: falling back to sqlite)"
fi

# --------------------------------------------------------------------------
# Prepare storage — Memos runs as nonroot (UID 10001)
# --------------------------------------------------------------------------
mkdir -p /data
chown -R 10001:10001 /data

bashio::log.info "Starting Memos — driver: ${DB_DRIVER}, log level: ${LOG_LEVEL}, dsn: ${MASKED_DSN}"

# Re-enter the upstream entrypoint: it fixes ownership of the image data dir,
# drops privileges to UID 10001 via su-exec, then execs the memos binary.
exec /usr/local/memos/entrypoint.sh /usr/local/memos/memos
