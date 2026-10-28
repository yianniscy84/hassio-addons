#!/usr/bin/with-contenv bashio
# ============================================================================
# Shoutrrr Home Assistant Add-on — Entry Script
# ============================================================================
#
# Responsibilities:
#   1. Read the add-on options and translate them into Shoutrrr/Laravel env.
#   2. Persist Laravel's storage tree and SQLite database under /data.
#   3. Manage the Laravel APP_KEY (option -> /data/app_key -> generate once).
#   4. Hand off to the upstream serversideup entrypoint (storage:link, migrate,
#      optimize) and then supervisord, whose programs run as www-data.
# ============================================================================

set -e

CONFIG_PATH=/data/options.json
APP_DIR=/var/www/html
WEB_USER=www-data
KEY_FILE=/data/app_key

# ----------------------------------------------------------------------------
# Defaults for standalone (non-HA) testing
# ----------------------------------------------------------------------------
if [ ! -f "${CONFIG_PATH}" ]; then
    bashio::log.warn "${CONFIG_PATH} not found — writing built-in defaults."
    mkdir -p /data
    cat > "${CONFIG_PATH}" <<'EOF'
{
  "app_url": "http://homeassistant.local:8080",
  "app_key": "",
  "log_level": "info",
  "registrations_enabled": false,
  "trusted_proxies": "",
  "queue_workers": 1,
  "mail_enabled": false,
  "mail_host": "",
  "mail_port": 587,
  "mail_username": "",
  "mail_password": "",
  "mail_encryption": "tls",
  "mail_from_address": "",
  "mail_from_name": "Shoutrrr",
  "x_client_id": "",
  "x_client_secret": "",
  "linkedin_client_id": "",
  "linkedin_client_secret": "",
  "facebook_client_id": "",
  "facebook_client_secret": "",
  "threads_client_id": "",
  "threads_client_secret": "",
  "google_client_id": "",
  "google_client_secret": "",
  "metrics_enabled": true,
  "engagement_enabled": true,
  "messages_enabled": true
}
EOF
fi

# ----------------------------------------------------------------------------
# Read Configuration Options
# ----------------------------------------------------------------------------
APP_URL=$(bashio::config 'app_url')
APP_KEY_OPT=$(bashio::config 'app_key')
LOG_LEVEL=$(bashio::config 'log_level')
REGISTRATIONS_ENABLED=$(bashio::config 'registrations_enabled')
TRUSTED_PROXIES_OPT=$(bashio::config 'trusted_proxies')
QUEUE_WORKERS=$(bashio::config 'queue_workers')

MAIL_ENABLED=$(bashio::config 'mail_enabled')
MAIL_HOST=$(bashio::config 'mail_host')
MAIL_PORT=$(bashio::config 'mail_port')
MAIL_USERNAME=$(bashio::config 'mail_username')
MAIL_PASSWORD=$(bashio::config 'mail_password')
MAIL_ENCRYPTION=$(bashio::config 'mail_encryption')
MAIL_FROM_ADDRESS=$(bashio::config 'mail_from_address')
MAIL_FROM_NAME=$(bashio::config 'mail_from_name')

X_CLIENT_ID=$(bashio::config 'x_client_id')
X_CLIENT_SECRET=$(bashio::config 'x_client_secret')
LINKEDIN_CLIENT_ID=$(bashio::config 'linkedin_client_id')
LINKEDIN_CLIENT_SECRET=$(bashio::config 'linkedin_client_secret')
FACEBOOK_CLIENT_ID=$(bashio::config 'facebook_client_id')
FACEBOOK_CLIENT_SECRET=$(bashio::config 'facebook_client_secret')
THREADS_CLIENT_ID=$(bashio::config 'threads_client_id')
THREADS_CLIENT_SECRET=$(bashio::config 'threads_client_secret')
GOOGLE_CLIENT_ID=$(bashio::config 'google_client_id')
GOOGLE_CLIENT_SECRET=$(bashio::config 'google_client_secret')

METRICS_ENABLED=$(bashio::config 'metrics_enabled')
ENGAGEMENT_ENABLED=$(bashio::config 'engagement_enabled')
MESSAGES_ENABLED=$(bashio::config 'messages_enabled')

# ----------------------------------------------------------------------------
# Validate Application URL
# ----------------------------------------------------------------------------
if [ -z "${APP_URL}" ]; then
    APP_URL="http://homeassistant.local:8080"
fi
APP_URL="${APP_URL%/}"

case "${APP_URL}" in
    http://*|https://*) ;;
    *)
        bashio::log.error "app_url must start with http:// or https:// (got '${APP_URL}')."
        exit 1
        ;;
esac

APP_SCHEME="${APP_URL%%://*}"
APP_HOST="${APP_URL#*://}"
APP_HOST="${APP_HOST%%/*}"
APP_HOST="${APP_HOST%%:*}"

if [ "${APP_SCHEME}" = "https" ]; then
    OCTANE_HTTPS=true
    SESSION_SECURE_COOKIE=true
else
    OCTANE_HTTPS=false
    SESSION_SECURE_COOKIE=false
fi

# ----------------------------------------------------------------------------
# Manage Laravel APP_KEY
# ----------------------------------------------------------------------------
if [ -n "${APP_KEY_OPT}" ]; then
    APP_KEY="${APP_KEY_OPT}"
    printf '%s' "${APP_KEY}" > "${KEY_FILE}"
    bashio::log.info "Using APP_KEY from add-on options."
elif [ -f "${KEY_FILE}" ]; then
    APP_KEY=$(cat "${KEY_FILE}")
    bashio::log.info "Loaded existing APP_KEY from ${KEY_FILE}."
else
    APP_KEY="base64:$(head -c 32 /dev/urandom | base64 | tr -d '\n')"
    printf '%s' "${APP_KEY}" > "${KEY_FILE}"
    bashio::log.info "Generated a new APP_KEY and stored it at ${KEY_FILE}."
fi

case "${APP_KEY}" in
    base64:*) ;;
    *)
        bashio::log.error "app_key must be a Laravel key starting with 'base64:'. Clear the option to auto-generate one."
        exit 1
        ;;
esac

# Laravel's AES-256 ciphers require exactly 32 key bytes. A wrong length only
# surfaces later as an Octane worker crash loop, so fail fast with a clear error.
KEY_BYTES=$(printf '%s' "${APP_KEY#base64:}" | base64 -d 2>/dev/null | wc -c | tr -d ' ')
if [ "${KEY_BYTES}" != "32" ]; then
    bashio::log.error "app_key decodes to ${KEY_BYTES} bytes, but Laravel needs exactly 32. Clear the option to auto-generate a valid key."
    exit 1
fi

# ----------------------------------------------------------------------------
# Persist Laravel storage + SQLite under /data
# ----------------------------------------------------------------------------
mkdir -p /data/storage /data/sqlite

if [ ! -L "${APP_DIR}/storage" ]; then
    if [ -d "${APP_DIR}/storage" ]; then
        cp -an "${APP_DIR}/storage/." /data/storage/ 2>/dev/null || true
        rm -rf "${APP_DIR}/storage"
    fi
    ln -s /data/storage "${APP_DIR}/storage"
    bashio::log.info "Persisted ${APP_DIR}/storage -> /data/storage."
fi

if [ ! -L "${APP_DIR}/database/sqlite" ]; then
    if [ -d "${APP_DIR}/database/sqlite" ]; then
        cp -an "${APP_DIR}/database/sqlite/." /data/sqlite/ 2>/dev/null || true
        rm -rf "${APP_DIR}/database/sqlite"
    fi
    ln -s /data/sqlite "${APP_DIR}/database/sqlite"
    bashio::log.info "Persisted ${APP_DIR}/database/sqlite -> /data/sqlite."
fi

mkdir -p \
    /data/storage/framework/cache/data \
    /data/storage/framework/sessions \
    /data/storage/framework/views \
    /data/storage/app/public \
    /data/storage/logs

chown "${WEB_USER}:${WEB_USER}" /data/storage /data/storage/app/public /data/sqlite 2>/dev/null || true
chown -R "${WEB_USER}:${WEB_USER}" \
    /data/storage/framework \
    /data/storage/logs \
    /data/sqlite \
    "${APP_DIR}/bootstrap/cache" 2>/dev/null || true
chown "${WEB_USER}:${WEB_USER}" "${KEY_FILE}" 2>/dev/null || true
chmod 600 "${KEY_FILE}" 2>/dev/null || true

# ----------------------------------------------------------------------------
# Runtime Environment
# ----------------------------------------------------------------------------
export APP_NAME="Shoutrrr"
export APP_ENV=production
export APP_DEBUG=false
export APP_URL="${APP_URL}"
export APP_KEY="${APP_KEY}"
export ASSET_URL=""

export OCTANE_SERVER=frankenphp
export OCTANE_HTTPS="${OCTANE_HTTPS}"
export SESSION_SECURE_COOKIE="${SESSION_SECURE_COOKIE}"
if [ -n "${TRUSTED_PROXIES_OPT}" ]; then
    export TRUSTED_PROXIES="${TRUSTED_PROXIES_OPT}"
fi

export SELF_HOSTED=true
export INSTANCE_REGISTRATIONS_ENABLED="${REGISTRATIONS_ENABLED}"

export DB_CONNECTION=sqlite
export CACHE_STORE=database
export QUEUE_CONNECTION=database
export SESSION_DRIVER=database
export QUEUE_WORKER_ENABLED=true
export QUEUE_WORKER_COUNT="${QUEUE_WORKERS}"
export SCHEDULER_ENABLED=true
export INERTIA_SSR_ENABLED=false

export METRICS_ENABLED="${METRICS_ENABLED}"
export ENGAGEMENT_ENABLED="${ENGAGEMENT_ENABLED}"
export MESSAGES_ENABLED="${MESSAGES_ENABLED}"

export LOG_CHANNEL=stack
export LOG_STACK=daily
export LOG_DAILY_DAYS=14
export LOG_LEVEL="${LOG_LEVEL}"

export AUTORUN_ENABLED=true

# ----------------------------------------------------------------------------
# Outgoing Mail
# ----------------------------------------------------------------------------
if [ "${MAIL_ENABLED}" = "true" ]; then
    if [ -z "${MAIL_HOST}" ]; then
        bashio::log.error "mail_enabled is true but mail_host is empty."
        exit 1
    fi

    export MAIL_MAILER=smtp
    export MAIL_HOST="${MAIL_HOST}"
    export MAIL_PORT="${MAIL_PORT}"

    if [ -n "${MAIL_USERNAME}" ]; then
        export MAIL_USERNAME="${MAIL_USERNAME}"
    fi
    if [ -n "${MAIL_PASSWORD}" ]; then
        export MAIL_PASSWORD="${MAIL_PASSWORD}"
    fi

    case "${MAIL_ENCRYPTION}" in
        tls)
            export MAIL_SCHEME=smtp
            ;;
        ssl)
            export MAIL_SCHEME=smtps
            ;;
        none)
            ;;
        *)
            bashio::log.error "mail_encryption must be tls, ssl or none."
            exit 1
            ;;
    esac

    if [ -z "${MAIL_FROM_ADDRESS}" ]; then
        MAIL_FROM_ADDRESS="shoutrrr@${APP_HOST}"
    fi
    if [ -z "${MAIL_FROM_NAME}" ]; then
        MAIL_FROM_NAME="Shoutrrr"
    fi
    export MAIL_FROM_ADDRESS="${MAIL_FROM_ADDRESS}"
    export MAIL_FROM_NAME="${MAIL_FROM_NAME}"

    bashio::log.info "SMTP mail enabled via ${MAIL_HOST}:${MAIL_PORT} (${MAIL_ENCRYPTION})."
else
    # With the log mailer Shoutrrr leaves email verification disabled, which is
    # what makes first-run registration work without any SMTP setup.
    export MAIL_MAILER=log
    bashio::log.info "SMTP mail disabled — emails are written to the add-on log."
fi

# ----------------------------------------------------------------------------
# Connected Accounts (OAuth apps) + Optional Social Login
# ----------------------------------------------------------------------------
if [ -n "${X_CLIENT_ID}" ] && [ -n "${X_CLIENT_SECRET}" ]; then
    export X_CLIENT_ID="${X_CLIENT_ID}"
    export X_CLIENT_SECRET="${X_CLIENT_SECRET}"
    export X_REDIRECT_URI="${APP_URL}/accounts/callback/x"
fi

if [ -n "${LINKEDIN_CLIENT_ID}" ] && [ -n "${LINKEDIN_CLIENT_SECRET}" ]; then
    export LINKEDIN_CLIENT_ID="${LINKEDIN_CLIENT_ID}"
    export LINKEDIN_CLIENT_SECRET="${LINKEDIN_CLIENT_SECRET}"
    export LINKEDIN_REDIRECT_URI="${APP_URL}/accounts/callback/linkedin"
fi

if [ -n "${FACEBOOK_CLIENT_ID}" ] && [ -n "${FACEBOOK_CLIENT_SECRET}" ]; then
    export FACEBOOK_CLIENT_ID="${FACEBOOK_CLIENT_ID}"
    export FACEBOOK_CLIENT_SECRET="${FACEBOOK_CLIENT_SECRET}"
    export FACEBOOK_REDIRECT_URI="${APP_URL}/accounts/callback/meta"
fi

if [ -n "${THREADS_CLIENT_ID}" ] && [ -n "${THREADS_CLIENT_SECRET}" ]; then
    export THREADS_CLIENT_ID="${THREADS_CLIENT_ID}"
    export THREADS_CLIENT_SECRET="${THREADS_CLIENT_SECRET}"
    export THREADS_REDIRECT_URI="${APP_URL}/accounts/callback/threads"
fi

if [ -n "${GOOGLE_CLIENT_ID}" ] && [ -n "${GOOGLE_CLIENT_SECRET}" ]; then
    export SOCIALITE_ENABLED=true
    export SOCIALITE_PROVIDERS=google
    export GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID}"
    export GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET}"
    export GOOGLE_REDIRECT_URI="${APP_URL}/auth/google/callback"
fi

# ----------------------------------------------------------------------------
# Startup Summary
# ----------------------------------------------------------------------------
bashio::log.info "Starting Shoutrrr on port 8080 — ${APP_URL}"
bashio::log.info "Log level: ${LOG_LEVEL} | queue workers: ${QUEUE_WORKERS} | registrations: ${REGISTRATIONS_ENABLED}"
bashio::log.info "Data: SQLite in /data/sqlite, storage in /data/storage"

# ----------------------------------------------------------------------------
# Start Shoutrrr
#
# The upstream serversideup entrypoint runs the init scripts (storage:link,
# migrations, optimize) and then execs the command we pass it. That command is
# supervisor-start.sh: it re-chowns the files created by those root-run scripts
# and starts supervisord, whose programs run as www-data.
#
# supervisord itself is not dropped to www-data because a process that loses
# root cannot re-open the container's stdout/stderr pipes (/dev/fd/1).
# ----------------------------------------------------------------------------
cd "${APP_DIR}"

exec /usr/local/bin/docker-php-serversideup-entrypoint /usr/local/bin/supervisor-start.sh
