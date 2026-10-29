ARG BUILD_FROM=ghcr.io/gitroomhq/postiz-app:v2.25.3

# ============================================================================
# Runtime — based on official Postiz image (Debian Bookworm)
# ============================================================================
FROM ${BUILD_FROM}

USER root

# Install PostgreSQL 15, Redis, and utilities
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    curl \
    postgresql \
    postgresql-contrib \
    redis-server \
    python3 \
    tzdata \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Symlink PostgreSQL binaries into /usr/local/bin for immediate availability
RUN ln -sf /usr/lib/postgresql/*/bin/* /usr/local/bin/

# Install Temporal CLI (provides embedded Temporal workflow server)
RUN curl -sSf https://temporal.download/cli.sh | sh \
    && cp /root/.temporalio/bin/temporal /usr/local/bin/temporal \
    && chmod +x /usr/local/bin/temporal

# Stubs for bashio + with-contenv (local / non-HA builds)
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN if ! command -v with-contenv >/dev/null 2>&1; then \
      sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub; \
      cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv; \
      chmod +x /usr/bin/with-contenv; \
    fi

ARG BUILD_VERSION=2.25.3.1
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# PostgreSQL runtime directories
RUN mkdir -p /run/postgresql /var/log/postgresql \
    && chown -R postgres:postgres /run/postgresql /var/log/postgresql \
    && chmod 775 /run/postgresql

# Persistent data directory
RUN mkdir -p /data \
    && echo '{}' > /data/options.json

# Copy entry script
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

WORKDIR /app
EXPOSE 5000

ENTRYPOINT ["/run.sh"]
