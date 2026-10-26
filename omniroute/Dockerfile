ARG BUILD_FROM=diegosouzapw/omniroute:latest

# ============================================================================
# Runtime — based on the official OmniRoute image
# ============================================================================
FROM ${BUILD_FROM}

# Switch to root for all setup
USER root

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    redis-server \
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

ARG BUILD_VERSION=0.3.8
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy addon config files
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# Persistent data directory — owned by node so OmniRoute can write
RUN mkdir -p /data \
    && chown -R node:node /data \
    && echo '{}' > /data/options.json

EXPOSE 20128

CMD ["/run.sh"]
