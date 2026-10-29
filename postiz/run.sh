#!/usr/bin/with-contenv bashio

# ============================================================================
# Postiz Home Assistant Addon — Entry Script
# ============================================================================

CONFIG_PATH=/data/options.json

if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{}' > "${CONFIG_PATH}"
fi

# --------------------------------------------------------------------------
# Read options from config
# --------------------------------------------------------------------------
MAIN_URL=$(bashio::config 'main_url')
DB_URL=$(bashio::config 'db_url')
REDIS_URL_OPT=$(bashio::config 'redis_url')
DISABLE_REGISTRATION=$(bashio::config 'disable_registration')
OPENAI_API_KEY_OPT=$(bashio::config 'openai_api_key')
STORAGE_PROVIDER_OPT=$(bashio::config 'storage_provider')
CF_ACCOUNT_ID=$(bashio::config 'cloudflare_account_id')
CF_ACCESS_KEY=$(bashio::config 'cloudflare_access_key')
CF_SECRET_KEY=$(bashio::config 'cloudflare_secret_access_key')
CF_BUCKET_NAME=$(bashio::config 'cloudflare_bucketname')
CF_BUCKET_URL=$(bashio::config 'cloudflare_bucket_url')

# Default public URL
if [ -z "${MAIN_URL}" ]; then
    MAIN_URL="http://localhost:5000"
fi
# Strip any trailing slash
MAIN_URL="${MAIN_URL%/}"

export MAIN_URL
export FRONTEND_URL="${MAIN_URL}"
export NEXT_PUBLIC_BACKEND_URL="${MAIN_URL}/api"
export BACKEND_INTERNAL_URL="http://localhost:3000"
export IS_GENERAL="true"

if [ -n "${DISABLE_REGISTRATION}" ]; then
    export DISABLE_REGISTRATION="${DISABLE_REGISTRATION}"
else
    export DISABLE_REGISTRATION="false"
fi

# --------------------------------------------------------------------------
# JWT_SECRET — generate once, persist in /data
# --------------------------------------------------------------------------
SECRET_FILE="/data/jwt_secret"
if [ ! -f "${SECRET_FILE}" ]; then
    head -c 48 /dev/urandom | base64 | tr -d '\n' > "${SECRET_FILE}"
    chmod 600 "${SECRET_FILE}"
fi
export JWT_SECRET
JWT_SECRET=$(cat "${SECRET_FILE}")

# --------------------------------------------------------------------------
# Storage & Uploads
# --------------------------------------------------------------------------
mkdir -p /data/uploads
chmod 777 /data/uploads

if [ ! -L /uploads ]; then
    rm -rf /uploads
    ln -s /data/uploads /uploads
fi

if [ -n "${STORAGE_PROVIDER_OPT}" ]; then
    export STORAGE_PROVIDER="${STORAGE_PROVIDER_OPT}"
else
    export STORAGE_PROVIDER="local"
fi

export UPLOAD_DIRECTORY="/uploads"
export NEXT_PUBLIC_UPLOAD_DIRECTORY="/uploads"

# Optional Cloudflare R2
if [ -n "${CF_ACCOUNT_ID}" ]; then export CLOUDFLARE_ACCOUNT_ID="${CF_ACCOUNT_ID}"; fi
if [ -n "${CF_ACCESS_KEY}" ]; then export CLOUDFLARE_ACCESS_KEY="${CF_ACCESS_KEY}"; fi
if [ -n "${CF_SECRET_KEY}" ]; then export CLOUDFLARE_SECRET_ACCESS_KEY="${CF_SECRET_KEY}"; fi
if [ -n "${CF_BUCKET_NAME}" ]; then export CLOUDFLARE_BUCKETNAME="${CF_BUCKET_NAME}"; fi
if [ -n "${CF_BUCKET_URL}" ]; then export CLOUDFLARE_BUCKET_URL="${CF_BUCKET_URL}"; fi

# Optional OpenAI
if [ -n "${OPENAI_API_KEY_OPT}" ]; then
    export OPENAI_API_KEY="${OPENAI_API_KEY_OPT}"
fi

# --------------------------------------------------------------------------
# Social provider OAuth apps — self-hosted Postiz requires your own apps.
# Each option is exported only when set, so unset providers stay hidden.
# --------------------------------------------------------------------------
export_provider_env() {
    local option="${1}"
    local env_name="${2}"
    local value

    value=$(bashio::config "${option}")
    if [ -n "${value}" ] && [ "${value}" != "null" ]; then
        export "${env_name}=${value}"
    fi
}

# X (Twitter) — OAuth 1.0a keys from the developer portal
export_provider_env x_api_key X_API_KEY
export_provider_env x_api_secret X_API_SECRET

# LinkedIn (member) and LinkedIn Page share the same app
export_provider_env linkedin_client_id LINKEDIN_CLIENT_ID
export_provider_env linkedin_client_secret LINKEDIN_CLIENT_SECRET

# Facebook + Instagram (via Meta Graph)
export_provider_env facebook_app_id FACEBOOK_APP_ID
export_provider_env facebook_app_secret FACEBOOK_APP_SECRET

# Instagram (Standalone, Instagram Login / graph.instagram.com)
export_provider_env instagram_app_id INSTAGRAM_APP_ID
export_provider_env instagram_app_secret INSTAGRAM_APP_SECRET

export_provider_env threads_app_id THREADS_APP_ID
export_provider_env threads_app_secret THREADS_APP_SECRET

export_provider_env youtube_client_id YOUTUBE_CLIENT_ID
export_provider_env youtube_client_secret YOUTUBE_CLIENT_SECRET

export_provider_env tiktok_client_id TIKTOK_CLIENT_ID
export_provider_env tiktok_client_secret TIKTOK_CLIENT_SECRET

export_provider_env pinterest_client_id PINTEREST_CLIENT_ID
export_provider_env pinterest_client_secret PINTEREST_CLIENT_SECRET

export_provider_env reddit_client_id REDDIT_CLIENT_ID
export_provider_env reddit_client_secret REDDIT_CLIENT_SECRET

export_provider_env discord_client_id DISCORD_CLIENT_ID
export_provider_env discord_client_secret DISCORD_CLIENT_SECRET
export_provider_env discord_bot_token DISCORD_BOT_TOKEN_ID

export_provider_env mastodon_url MASTODON_URL
export_provider_env mastodon_client_id MASTODON_CLIENT_ID
export_provider_env mastodon_client_secret MASTODON_CLIENT_SECRET

# GitHub OAuth login
export_provider_env github_client_id GITHUB_CLIENT_ID
export_provider_env github_client_secret GITHUB_CLIENT_SECRET

# --------------------------------------------------------------------------
# Database: bundled PostgreSQL (default) or external server via db_url
# --------------------------------------------------------------------------
PGDATA="/data/postgres"
BUNDLED_PG=false

if [ -z "${DB_URL}" ]; then
    BUNDLED_PG=true
    bashio::log.info "Using bundled PostgreSQL database in ${PGDATA}..."

    mkdir -p /run/postgresql /var/log/postgresql
    chown -R postgres:postgres /run/postgresql /var/log/postgresql
    chmod 775 /run/postgresql

    if [ ! -f "${PGDATA}/PG_VERSION" ]; then
        bashio::log.info "Initializing bundled PostgreSQL cluster in ${PGDATA}..."
        mkdir -p "${PGDATA}"
        chown -R postgres:postgres "${PGDATA}"
        chmod 700 "${PGDATA}"
        su -s /bin/sh postgres -c "initdb -D ${PGDATA} --encoding=UTF8 --locale=C.UTF-8" \
            || { bashio::log.error "initdb failed!"; exit 1; }
        su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} -w start" \
            || { bashio::log.error "initial PostgreSQL start failed!"; exit 1; }
        su -s /bin/sh postgres -c "createdb -U postgres postiz" \
            || { bashio::log.error "createdb postiz failed!"; exit 1; }
        su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} stop"
    else
        bashio::log.info "PostgreSQL data directory exists, skipping initialization."
    fi

    chown -R postgres:postgres "${PGDATA}"
    chmod 700 "${PGDATA}"

    bashio::log.info "Starting bundled PostgreSQL..."
    su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} -w -l /var/log/postgresql/postgresql.log start" \
        || { bashio::log.error "PostgreSQL failed to start!"; exit 1; }

    # Wait for PostgreSQL to become ready
    for i in $(seq 1 30); do
        if su -s /bin/sh postgres -c "pg_isready -q" 2>/dev/null; then
            break
        fi
        sleep 1
    done
    if ! su -s /bin/sh postgres -c "pg_isready -q" 2>/dev/null; then
        bashio::log.error "PostgreSQL failed to become ready in time!"
        exit 1
    fi

    # Ensure database exists
    su -s /bin/sh postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname = 'postiz'\" | grep -q 1" \
        || su -s /bin/sh postgres -c "createdb -U postgres postiz"

    export DATABASE_URL="postgresql://postgres@127.0.0.1:5432/postiz"
    bashio::log.info "Bundled PostgreSQL is ready."
else
    bashio::log.info "Using external PostgreSQL database..."
    export DATABASE_URL="${DB_URL}"

    # Best-effort auto-create database if possible
    if dsn_parts=$(python3 - "${DB_URL}" <<'PYEOF'
import sys
from urllib.parse import urlparse
try:
    p = urlparse(sys.argv[1])
    db = (p.path or '').lstrip('/')
    if not db:
        sys.exit(1)
    admin_url = f"{p.scheme}://{p.netloc}/postgres"
    print(f"{admin_url}\n{db}")
except Exception:
    sys.exit(1)
PYEOF
    ); then
        admin_url=$(printf '%s\n' "${dsn_parts}" | head -n1)
        db_name=$(printf '%s\n' "${dsn_parts}" | tail -n1)
        if [ -n "${admin_url}" ] && [ -n "${db_name}" ]; then
            if ! psql "${DATABASE_URL}" -c '\q' 2>/dev/null; then
                bashio::log.info "Database '${db_name}' not reachable yet; attempting auto-creation..."
                if psql "${admin_url}" -c "CREATE DATABASE \"${db_name}\";" 2>/dev/null; then
                    bashio::log.info "Created database '${db_name}' on external PostgreSQL server."
                fi
            fi
        fi
    fi
fi

# --------------------------------------------------------------------------
# Redis: bundled Redis (default) or external server via redis_url
# --------------------------------------------------------------------------
BUNDLED_REDIS=false

if [ -z "${REDIS_URL_OPT}" ]; then
    BUNDLED_REDIS=true
    bashio::log.info "Starting bundled Redis server..."
    redis-server --daemonize yes --dir /tmp --appendonly no --save "" --port 6379 --bind 127.0.0.1
    sleep 1

    if redis-cli ping 2>/dev/null | grep -q PONG; then
        bashio::log.info "Bundled Redis is ready."
    else
        bashio::log.error "Redis failed to start!"
        exit 1
    fi
    export REDIS_URL="redis://127.0.0.1:6379"
else
    bashio::log.info "Using external Redis server..."
    export REDIS_URL="${REDIS_URL_OPT}"
fi

# --------------------------------------------------------------------------
# Temporal Workflow Engine
# --------------------------------------------------------------------------
bashio::log.info "Starting embedded Temporal workflow server..."
temporal server start-dev \
    --ip 127.0.0.1 \
    --port 7233 \
    --ui-port 8233 \
    --db-filename /data/temporal.db \
    --log-format text > /var/log/temporal.log 2>&1 &
TEMPORAL_PID=$!

for i in $(seq 1 30); do
    if temporal operator namespace list 2>/dev/null | grep -q default; then
        break
    fi
    sleep 1
done

if temporal operator namespace list 2>/dev/null | grep -q default; then
    bashio::log.info "Embedded Temporal server is ready."
else
    bashio::log.warn "Temporal server still initializing; continuing boot..."
fi

export TEMPORAL_ADDRESS="127.0.0.1:7233"

# --------------------------------------------------------------------------
# Signal handling for clean shutdown
# --------------------------------------------------------------------------
cleanup() {
    bashio::log.info "Received stop signal, shutting down Postiz..."
    pm2 stop all 2>/dev/null || true
    if [ -f /var/run/nginx.pid ]; then
        nginx -s stop 2>/dev/null || true
    fi
    if [ -n "${TEMPORAL_PID}" ]; then
        kill -TERM "${TEMPORAL_PID}" 2>/dev/null || true
    fi
    if [ "${BUNDLED_REDIS}" = "true" ]; then
        if redis-cli ping 2>/dev/null | grep -q PONG; then
            redis-cli shutdown 2>/dev/null || true
        fi
    fi
    if [ "${BUNDLED_PG}" = "true" ]; then
        bashio::log.info "Stopping bundled PostgreSQL..."
        su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} -m fast stop" 2>/dev/null || true
    fi
    exit 0
}

trap cleanup SIGTERM SIGINT SIGHUP

# --------------------------------------------------------------------------
# Start Nginx and Postiz Services via PM2
# --------------------------------------------------------------------------
bashio::log.info "Starting Postiz web proxy (nginx on port 5000)..."
mkdir -p /var/log/nginx
chown -R www:www /var/log/nginx /var/lib/nginx 2>/dev/null || true
nginx

bashio::log.info "Starting Postiz backend, frontend, and orchestrator..."
cd /app

pnpm run pm2 &
PM2_PID=$!

wait ${PM2_PID}
