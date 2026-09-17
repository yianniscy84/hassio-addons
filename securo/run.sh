#!/usr/bin/with-contenv bashio

# ============================================================================
# Securo Home Assistant Addon — Entry Script
# ============================================================================

CONFIG_PATH=/data/options.json
PGDATA="/data/postgres"
APP_DIR="/app"
# Create default options.json if not present (e.g. on first run with mounted volume)
if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{"secret_key":"","frontend_url":"","debug":false,"db_password":"postgres","pluggy_client_id":"","pluggy_client_secret":"","enable_banking_app_id":"","enable_banking_private_key_file":"","enable_banking_oauth_redirect_uri":"","simplefin_enabled":false,"simplefin_api_url":"https://beta-bridge.simplefin.org","oidc_enabled":false,"oidc_provider_name":"OIDC","oidc_discovery_url":"","oidc_client_id":"","oidc_client_secret":"","oidc_redirect_uri":"","oidc_scopes":"openid email profile","oidc_auto_register":true,"oidc_existing_user_link_mode":"disabled","oidc_require_verified_email":true,"oidc_sync_roles":false,"oidc_roles_claim":"groups","oidc_admin_roles":"","oidc_workspace_role_map":"","local_auth_enabled":true,"openexchangerates_app_id":"","fx_sync_mode":"on_demand","tesouro_direto_enabled":true,"agents_enabled":false,"agents_mcp_jwt_secret":"","agents_external_mcp_url":"","agents_extra_mcp_servers":"","agents_default_provider":"","agents_default_model":"","agents_openai_api_key":"","agents_anthropic_api_key":"","agents_ollama_base_url":"","agents_openai_compat_base_url":"","agents_openai_compat_api_key":"","agents_embedding_provider":"ollama"}' > "${CONFIG_PATH}"
fi

# --------------------------------------------------------------------------
# Read options from config
# --------------------------------------------------------------------------
SECRET_KEY=$(bashio::config 'secret_key')
if [ -z "${SECRET_KEY}" ]; then
    SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
fi

CONFIGURED_FRONTEND_URL=$(bashio::config 'frontend_url')
FRONTEND_URL="${CONFIGURED_FRONTEND_URL}"
if [ -z "${FRONTEND_URL}" ]; then
    FRONTEND_URL="http://localhost:80"
fi

DEBUG=$(bashio::config 'debug')
DB_PASSWORD=$(bashio::config 'db_password')

# Bank sync
PLUGGY_CLIENT_ID=$(bashio::config 'pluggy_client_id')
PLUGGY_CLIENT_SECRET=$(bashio::config 'pluggy_client_secret')
ENABLE_BANKING_APP_ID=$(bashio::config 'enable_banking_app_id')
ENABLE_BANKING_PRIVATE_KEY_FILE=$(bashio::config 'enable_banking_private_key_file')
ENABLE_BANKING_OAUTH_REDIRECT_URI=$(bashio::config 'enable_banking_oauth_redirect_uri')
ENABLE_BANKING_HISTORY_DAYS=$(bashio::config 'enable_banking_history_days')
SIMPLEFIN_ENABLED=$(bashio::config 'simplefin_enabled')
SIMPLEFIN_API_URL=$(bashio::config 'simplefin_api_url')

# OIDC
OIDC_ENABLED=$(bashio::config 'oidc_enabled')
OIDC_PROVIDER_NAME=$(bashio::config 'oidc_provider_name')
OIDC_DISCOVERY_URL=$(bashio::config 'oidc_discovery_url')
OIDC_CLIENT_ID=$(bashio::config 'oidc_client_id')
OIDC_CLIENT_SECRET=$(bashio::config 'oidc_client_secret')
OIDC_REDIRECT_URI=$(bashio::config 'oidc_redirect_uri')
OIDC_SCOPES=$(bashio::config 'oidc_scopes')
OIDC_AUTO_REGISTER=$(bashio::config 'oidc_auto_register')
OIDC_EXISTING_USER_LINK_MODE=$(bashio::config 'oidc_existing_user_link_mode')
OIDC_REQUIRE_VERIFIED_EMAIL=$(bashio::config 'oidc_require_verified_email')
OIDC_SYNC_ROLES=$(bashio::config 'oidc_sync_roles')
OIDC_ROLES_CLAIM=$(bashio::config 'oidc_roles_claim')
OIDC_ADMIN_ROLES=$(bashio::config 'oidc_admin_roles')
OIDC_WORKSPACE_ROLE_MAP=$(bashio::config 'oidc_workspace_role_map')
LOCAL_AUTH_ENABLED=$(bashio::config 'local_auth_enabled')

# FX
OPENEXCHANGERATES_APP_ID=$(bashio::config 'openexchangerates_app_id')
FX_SYNC_MODE=$(bashio::config 'fx_sync_mode')

# Tesouro Direto
TESOURO_DIRETO_ENABLED=$(bashio::config 'tesouro_direto_enabled')

# AI agents / MCP (opt-in)
AGENTS_ENABLED=$(bashio::config 'agents_enabled')
AGENTS_MCP_JWT_SECRET=$(bashio::config 'agents_mcp_jwt_secret')
AGENTS_EXTERNAL_MCP_URL=$(bashio::config 'agents_external_mcp_url')
AGENTS_EXTRA_MCP_SERVERS=$(bashio::config 'agents_extra_mcp_servers')
AGENTS_DEFAULT_PROVIDER=$(bashio::config 'agents_default_provider')
AGENTS_DEFAULT_MODEL=$(bashio::config 'agents_default_model')
AGENTS_OPENAI_API_KEY=$(bashio::config 'agents_openai_api_key')
AGENTS_ANTHROPIC_API_KEY=$(bashio::config 'agents_anthropic_api_key')
AGENTS_OLLAMA_BASE_URL=$(bashio::config 'agents_ollama_base_url')
AGENTS_OPENAI_COMPAT_BASE_URL=$(bashio::config 'agents_openai_compat_base_url')
AGENTS_OPENAI_COMPAT_API_KEY=$(bashio::config 'agents_openai_compat_api_key')
AGENTS_EMBEDDING_PROVIDER=$(bashio::config 'agents_embedding_provider')
if [ -z "${AGENTS_EMBEDDING_PROVIDER}" ]; then
    AGENTS_EMBEDDING_PROVIDER="ollama"
fi

# --------------------------------------------------------------------------
# Export environment variables
# --------------------------------------------------------------------------
export SECRET_KEY
export FRONTEND_URL
export DEBUG
export DATABASE_URL="postgresql+asyncpg://postgres:${DB_PASSWORD}@localhost:5432/securo"
export REDIS_URL="redis://localhost:6379/0"

# Bank sync
export PLUGGY_CLIENT_ID
export PLUGGY_CLIENT_SECRET
export ENABLE_BANKING_APP_ID
export ENABLE_BANKING_PRIVATE_KEY_FILE
export ENABLE_BANKING_API_URL="https://api.enablebanking.com"
export ENABLE_BANKING_OAUTH_REDIRECT_URI
[ -n "${ENABLE_BANKING_HISTORY_DAYS}" ] && export ENABLE_BANKING_HISTORY_DAYS
export SIMPLEFIN_ENABLED
export SIMPLEFIN_API_URL

# OIDC
export OIDC_ENABLED
export OIDC_PROVIDER_NAME
export OIDC_DISCOVERY_URL
export OIDC_CLIENT_ID
export OIDC_CLIENT_SECRET
export OIDC_REDIRECT_URI
export OIDC_SCOPES
export OIDC_AUTO_REGISTER
export OIDC_EXISTING_USER_LINK_MODE
export OIDC_REQUIRE_VERIFIED_EMAIL
export OIDC_SYNC_ROLES
export OIDC_ROLES_CLAIM
export OIDC_ADMIN_ROLES
export OIDC_WORKSPACE_ROLE_MAP
export LOCAL_AUTH_ENABLED

# FX
export OPENEXCHANGERATES_APP_ID
export FX_SYNC_MODE

# Tesouro Direto
export TESOURO_DIRETO_ENABLED

# Storage
export STORAGE_LOCAL_PATH="/data/attachments"

# Persist MCP JWT secret so minted tokens survive restarts
MCP_JWT_FILE="/data/mcp_jwt_secret"
if [ -z "${AGENTS_MCP_JWT_SECRET}" ]; then
    if [ -f "${MCP_JWT_FILE}" ]; then
        AGENTS_MCP_JWT_SECRET=$(cat "${MCP_JWT_FILE}")
    else
        AGENTS_MCP_JWT_SECRET=$(python3 -c "import secrets; print(secrets.token_hex(32))")
        echo -n "${AGENTS_MCP_JWT_SECRET}" > "${MCP_JWT_FILE}"
        chmod 600 "${MCP_JWT_FILE}"
    fi
fi

if [ -z "${AGENTS_EXTERNAL_MCP_URL}" ] && [ -n "${CONFIGURED_FRONTEND_URL}" ]; then
    AGENTS_EXTERNAL_MCP_URL="${CONFIGURED_FRONTEND_URL%/}/mcp"
fi

mkdir -p /data/agent_knowledge /data/embedding_models
export AGENTS_KNOWLEDGE_STORAGE_PATH="/data/agent_knowledge"
export AGENTS_EMBEDDING_NATIVE_CACHE_DIR="/data/embedding_models"

if [ "${AGENTS_ENABLED}" = "true" ] || [ "${AGENTS_ENABLED}" = "True" ] || [ "${AGENTS_ENABLED}" = "1" ]; then
    export AGENTS_ENABLED=true
    export AGENTS_BUILTIN_MCP_URL="http://127.0.0.1:8765/mcp"
    export AGENTS_MCP_JWT_SECRET
    export AGENTS_EXTRA_MCP_SERVERS
    export AGENTS_EMBEDDING_PROVIDER
    [ -n "${AGENTS_EXTERNAL_MCP_URL}" ] && export AGENTS_EXTERNAL_MCP_URL
    [ -n "${AGENTS_DEFAULT_PROVIDER}" ] && export AGENTS_DEFAULT_PROVIDER
    [ -n "${AGENTS_DEFAULT_MODEL}" ] && export AGENTS_DEFAULT_MODEL
    [ -n "${AGENTS_OPENAI_API_KEY}" ] && export AGENTS_OPENAI_API_KEY
    [ -n "${AGENTS_ANTHROPIC_API_KEY}" ] && export AGENTS_ANTHROPIC_API_KEY
    [ -n "${AGENTS_OLLAMA_BASE_URL}" ] && export AGENTS_OLLAMA_BASE_URL
    [ -n "${AGENTS_OPENAI_COMPAT_BASE_URL}" ] && export AGENTS_OPENAI_COMPAT_BASE_URL
    [ -n "${AGENTS_OPENAI_COMPAT_API_KEY}" ] && export AGENTS_OPENAI_COMPAT_API_KEY
else
    export AGENTS_ENABLED=false
fi

# --------------------------------------------------------------------------
# Initialize PostgreSQL
# --------------------------------------------------------------------------
bashio::log.info "Initializing PostgreSQL..."
if [ ! -f "${PGDATA}/PG_VERSION" ]; then
    mkdir -p "${PGDATA}"
    chown -R postgres:postgres "${PGDATA}"
    su -s /bin/sh postgres -c "initdb -D ${PGDATA} --encoding=UTF8 --locale=C"
    su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} -w start"
    su -s /bin/sh postgres -c "psql -c \"ALTER USER postgres WITH PASSWORD '${DB_PASSWORD}';\""
    su -s /bin/sh postgres -c "createdb -U postgres securo"
    su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} stop"
else
    bashio::log.info "PostgreSQL data directory exists, skipping init."
fi

# Fix permissions
chown -R postgres:postgres "${PGDATA}"

# --------------------------------------------------------------------------
# Start PostgreSQL
# --------------------------------------------------------------------------
bashio::log.info "Starting PostgreSQL..."
su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} -w -l /var/log/postgresql.log start"

# Wait for PostgreSQL to be ready
for i in $(seq 1 30); do
    if su -s /bin/sh postgres -c "pg_isready -q" 2>/dev/null; then
        break
    fi
    sleep 1
done

if ! su -s /bin/sh postgres -c "pg_isready -q" 2>/dev/null; then
    bashio::log.error "PostgreSQL failed to start!"
    exit 1
fi

# Create database if it doesn't exist
su -s /bin/sh postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname = 'securo'\" | grep -q 1" \
    || su -s /bin/sh postgres -c "createdb -U postgres securo"

bashio::log.info "PostgreSQL is ready."

# --------------------------------------------------------------------------
# Start Redis
# --------------------------------------------------------------------------
bashio::log.info "Starting Redis..."
redis-server --daemonize yes --dir /data --appendonly no --save ""
sleep 1
bashio::log.info "Redis is ready."

# --------------------------------------------------------------------------
# Run database migrations
# --------------------------------------------------------------------------
bashio::log.info "Running database migrations..."
cd "${APP_DIR}"
python -m alembic upgrade head
bashio::log.info "Migrations complete."

# --------------------------------------------------------------------------
# Start Nginx
# --------------------------------------------------------------------------
bashio::log.info "Starting Nginx..."
mkdir -p /run/nginx
nginx
bashio::log.info "Nginx started on port 80."

# --------------------------------------------------------------------------
# Start Celery Worker
# --------------------------------------------------------------------------
bashio::log.info "Starting Celery worker..."
cd "${APP_DIR}"
celery -A app.worker worker --loglevel=info --concurrency=2 &
CELERY_WORKER_PID=$!
bashio::log.info "Celery worker started (PID: ${CELERY_WORKER_PID})."

# --------------------------------------------------------------------------
# Start Celery Beat
# --------------------------------------------------------------------------
bashio::log.info "Starting Celery beat..."
cd "${APP_DIR}"
celery -A app.worker beat --loglevel=info &
CELERY_BEAT_PID=$!
bashio::log.info "Celery beat started (PID: ${CELERY_BEAT_PID})."

# --------------------------------------------------------------------------
# Start Backend (Uvicorn)
# --------------------------------------------------------------------------
bashio::log.info "Starting Securo backend..."
cd "${APP_DIR}"
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2 &
BACKEND_PID=$!
bashio::log.info "Backend started (PID: ${BACKEND_PID})."

MCP_PID=""
if [ "${AGENTS_ENABLED}" = "true" ]; then
    bashio::log.info "Starting Securo MCP server..."
    cd "${APP_DIR}"
    uvicorn mcp_server.main:app --host 0.0.0.0 --port 8765 &
    MCP_PID=$!
    bashio::log.info "MCP server started (PID: ${MCP_PID}) on port 8765."
fi

bashio::log.info "Securo is running on http://localhost:80"

# --------------------------------------------------------------------------
# Keep alive & handle shutdown signals
# --------------------------------------------------------------------------
cleanup() {
    bashio::log.info "Shutting down Securo..."
    kill ${BACKEND_PID} ${CELERY_WORKER_PID} ${CELERY_BEAT_PID} ${MCP_PID} 2>/dev/null
    nginx -s stop 2>/dev/null
    redis-cli shutdown 2>/dev/null
    su -s /bin/sh postgres -c "pg_ctl -D ${PGDATA} stop -m fast" 2>/dev/null
    exit 0
}

trap cleanup SIGTERM SIGINT

WAIT_PIDS="${BACKEND_PID} ${CELERY_WORKER_PID} ${CELERY_BEAT_PID}"
if [ -n "${MCP_PID}" ]; then
    WAIT_PIDS="${WAIT_PIDS} ${MCP_PID}"
fi
wait -n ${WAIT_PIDS}
