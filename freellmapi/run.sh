#!/usr/bin/with-contenv bashio
# ============================================================================
# FreeLLMAPI Home Assistant Add-on — Entry Script
# ============================================================================

set -e

CONFIG_PATH=/data/options.json
APP_DIR="/app"

# Seed default options if missing (standalone / non-HA testing)
if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{"encryption_key":"","proxy_url":"","declarative_config":"","retention_days":90}' > "${CONFIG_PATH}"
fi

# ----------------------------------------------------------------------------
# Read Configuration Options
# ----------------------------------------------------------------------------
ENCRYPTION_KEY_OPT=$(bashio::config 'encryption_key')
PROXY_URL=$(bashio::config 'proxy_url')
DECLARATIVE_CONFIG=$(bashio::config 'declarative_config')
RETENTION_DAYS=$(bashio::config 'retention_days')

# ----------------------------------------------------------------------------
# Ensure Persistent Storage Directory & Symlink
# ----------------------------------------------------------------------------
if [ ! -L "${APP_DIR}/server/data" ]; then
    if [ -d "${APP_DIR}/server/data" ]; then
        cp -rn "${APP_DIR}/server/data/"* /data/ 2>/dev/null || true
        rm -rf "${APP_DIR}/server/data"
    fi
    ln -s /data "${APP_DIR}/server/data"
fi

# ----------------------------------------------------------------------------
# Manage Encryption Key (AES-256-GCM)
# ----------------------------------------------------------------------------
KEY_FILE="/data/.encryption_key"

if [ -n "${ENCRYPTION_KEY_OPT}" ]; then
    bashio::log.info "Using configured encryption key from add-on options."
    ENCRYPTION_KEY="${ENCRYPTION_KEY_OPT}"
    echo -n "${ENCRYPTION_KEY}" > "${KEY_FILE}"
    chmod 600 "${KEY_FILE}" 2>/dev/null || true
elif [ -f "${KEY_FILE}" ]; then
    bashio::log.info "Loading existing encryption key from ${KEY_FILE}."
    ENCRYPTION_KEY=$(cat "${KEY_FILE}")
elif [ -f "/data/.encryption-key" ]; then
    bashio::log.info "Migrating encryption key from /data/.encryption-key."
    ENCRYPTION_KEY=$(cat "/data/.encryption-key")
    echo -n "${ENCRYPTION_KEY}" > "${KEY_FILE}"
    chmod 600 "${KEY_FILE}" 2>/dev/null || true
else
    bashio::log.info "Generating new 32-byte encryption key for FreeLLMAPI..."
    ENCRYPTION_KEY=$(node -e 'console.log(require("crypto").randomBytes(32).toString("hex"))')
    echo -n "${ENCRYPTION_KEY}" > "${KEY_FILE}"
    chmod 600 "${KEY_FILE}" 2>/dev/null || true
    bashio::log.info "New encryption key successfully stored at ${KEY_FILE}."
fi

export ENCRYPTION_KEY

# ----------------------------------------------------------------------------
# Optional Environment Configuration
# ----------------------------------------------------------------------------
if [ -n "${PROXY_URL}" ]; then
    bashio::log.info "Configuring outbound proxy: ${PROXY_URL}"
    export PROXY_URL="${PROXY_URL}"
fi

if [ -n "${DECLARATIVE_CONFIG}" ]; then
    bashio::log.info "Applying declarative startup config (FREEAPI_CONFIG_JSON)..."
    export FREEAPI_CONFIG_JSON="${DECLARATIVE_CONFIG}"
fi

if [ -n "${RETENTION_DAYS}" ] && [ "${RETENTION_DAYS}" -ge 0 ] 2>/dev/null; then
    export REQUEST_ANALYTICS_RETENTION_DAYS="${RETENTION_DAYS}"
fi

# ----------------------------------------------------------------------------
# Runtime Environment
# ----------------------------------------------------------------------------
export PORT=3001
export HOST_BIND="0.0.0.0"
export NODE_ENV=production
export FREELLMAPI_INSTALL_METHOD="homeassistant-addon"
export FREEAPI_DB_PATH="/data/freeapi.db"

# Ensure data folder is owned by the node user
chown -R node:node /data 2>/dev/null || true

# ----------------------------------------------------------------------------
# Start FreeLLMAPI Server
# ----------------------------------------------------------------------------
bashio::log.info "Starting FreeLLMAPI on port ${PORT}..."
cd "${APP_DIR}"

if [ "$(id -u)" = "0" ] && command -v setpriv >/dev/null 2>&1; then
    exec setpriv --reuid=node --regid=node --init-groups -- node server/dist/index.js
else
    exec node server/dist/index.js
fi
