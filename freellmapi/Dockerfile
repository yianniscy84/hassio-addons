ARG BUILD_FROM=ghcr.io/tashfeenahmed/freellmapi:v0.16.8

# ============================================================================
# Runtime — based on the official FreeLLMAPI image
# ============================================================================
FROM ${BUILD_FROM}

USER root

# Install bash, python3, and curl for bashio stub and healthchecks
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    python3 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Stubs for bashio + with-contenv (local / non-HA builds).
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub \
    && cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv \
    && chmod +x /usr/bin/with-contenv

ARG BUILD_VERSION=0.16.8
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy addon entrypoint
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# Persistent data directory
RUN mkdir -p /data \
    && chown -R node:node /data \
    && echo '{"encryption_key":"","proxy_url":"","declarative_config":"","retention_days":90}' > /data/options.json

EXPOSE 3001

ENTRYPOINT ["/run.sh"]
