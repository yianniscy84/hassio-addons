ARG BUILD_FROM=python:3.12-alpine

# ============================================================================
# Stage 1: Build frontend
# ============================================================================
FROM node:22-alpine AS frontend-build

WORKDIR /src/frontend

COPY frontend/package*.json ./
RUN npm ci --ignore-scripts

COPY frontend/ ./
RUN npm run build

# ============================================================================
# Stage 2: Backend dependencies
# ============================================================================
FROM python:3.12-alpine AS backend-deps

RUN apk add --no-cache \
    gcc \
    musl-dev \
    libpq-dev \
    postgresql-dev

WORKDIR /build

COPY backend/pyproject.toml backend/uv.lock ./
RUN pip install --no-cache-dir uv \
    && uv export --frozen --no-emit-project --no-hashes -o /tmp/requirements.txt \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

COPY backend/ ./
RUN pip install --no-cache-dir --no-deps .

# ============================================================================
# Stage 3: Runtime
# ============================================================================
FROM ${BUILD_FROM}

# Install OS-level deps only (Python already provided by python:3.12-alpine base,
# or by the HA base image in CI). Do NOT add py3-pip / py3-psycopg2 via apk —
# they conflict with pip-installed packages from the build stage.
RUN apk add --no-cache \
    bash \
    postgresql16 \
    postgresql16-client \
    postgresql16-contrib \
    redis \
    nginx \
    curl \
    libpq \
    tzdata \
    && apk add --no-cache --virtual .build-deps \
       postgresql16-dev \
       build-base \
       git \
       clang \
       llvm-dev \
    && git clone --branch v0.8.0 https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make PG_CONFIG=/usr/libexec/postgresql16/pg_config \
    && make install PG_CONFIG=/usr/libexec/postgresql16/pg_config \
    && rm -rf /tmp/pgvector \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

# Stubs for bashio + with-contenv (local / non-HA builds).
# COPY always runs, but the RUN wires them up only when the HA base image
# hasn't already provided the real implementations.
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN if ! command -v with-contenv >/dev/null 2>&1; then \
      sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub; \
      cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv; \
      chmod +x /usr/bin/with-contenv; \
    fi

ARG BUILD_VERSION=0.34.1
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy pip packages and console scripts from the build stage.
# python:3.12-alpine and the HA base images both place site-packages under
# /usr/local/lib/python3.12/, so this copy is safe for both local and CI builds.
COPY --from=backend-deps /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=backend-deps /usr/local/bin /usr/local/bin

WORKDIR /app

# Copy backend source
COPY backend/ /app/

# Copy built frontend
COPY --from=frontend-build /src/frontend/dist /var/www/securo

# Copy addon config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# Persistent data directories + seed a default options.json for local runs.
# In HA OS /data is a persistent volume and options.json is written by the
# supervisor before the addon starts — this default is only used locally.
RUN mkdir -p /data/postgres /data/attachments /data/nginx /data/agent_knowledge /data/embedding_models /var/log/nginx /run/postgresql \
    && chown postgres:postgres /run/postgresql \
    && touch /var/log/postgresql.log \
    && chown postgres:postgres /var/log/postgresql.log \
    && echo '{"secret_key":"","frontend_url":"","debug":false,"db_password":"postgres","pluggy_client_id":"","pluggy_client_secret":"","enable_banking_app_id":"","enable_banking_private_key_file":"","enable_banking_oauth_redirect_uri":"","simplefin_enabled":false,"simplefin_api_url":"https://beta-bridge.simplefin.org","oidc_enabled":false,"oidc_provider_name":"OIDC","oidc_discovery_url":"","oidc_client_id":"","oidc_client_secret":"","oidc_redirect_uri":"","oidc_scopes":"openid email profile","oidc_auto_register":true,"oidc_existing_user_link_mode":"disabled","oidc_require_verified_email":true,"oidc_sync_roles":false,"oidc_roles_claim":"groups","oidc_admin_roles":"","oidc_workspace_role_map":"","local_auth_enabled":true,"openexchangerates_app_id":"","fx_sync_mode":"on_demand","tesouro_direto_enabled":true,"agents_enabled":false,"agents_mcp_jwt_secret":"","agents_external_mcp_url":"","agents_extra_mcp_servers":"","agents_default_provider":"","agents_default_model":"","agents_openai_api_key":"","agents_anthropic_api_key":"","agents_ollama_base_url":"","agents_openai_compat_base_url":"","agents_openai_compat_api_key":"","agents_embedding_provider":"ollama"}' \
      > /data/options.json

EXPOSE 80 8765

CMD ["/run.sh"]
