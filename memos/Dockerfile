ARG BUILD_FROM=neosmemo/memos:0.31.0

# ============================================================================
# Runtime — based on the official Memos image (neosmemo/memos)
# ============================================================================
FROM ${BUILD_FROM}

# Switch to root for all setup (the upstream entrypoint drops to UID 10001
# after run.sh has applied the add-on configuration).
USER root

# bash:       required by the with-contenv stub (run.sh shebang).
# python3:    required by the bashio::config stub and DSN parsing in run.sh.
# postgresql client: one-time CREATE DATABASE when an external PostgreSQL
#                    database is configured (falls back to older majors if
#                    the default is unavailable in the Alpine repos).
RUN apk add --no-cache bash python3 \
    && (apk add --no-cache postgresql17-client \
        || apk add --no-cache postgresql16-client \
        || apk add --no-cache postgresql15-client)

# Stubs for bashio + with-contenv (the upstream image is not built on a
# Home Assistant base image, so neither is available natively).
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN if ! command -v with-contenv >/dev/null 2>&1; then \
      sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub; \
      cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv; \
      chmod +x /usr/bin/with-contenv; \
    fi

ARG BUILD_VERSION=0.31.0
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy addon entry script
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# Persistent data directory owned by the nonroot user memos runs as (UID 10001).
# The seeded options.json is only used for local (non-HA) runs — in HA OS the
# supervisor writes /data/options.json before the add-on starts.
RUN mkdir -p /data \
    && echo '{"instance_url":"","log_level":"info","db_driver":"sqlite","db_dsn":""}' > /data/options.json \
    && chown -R 10001:10001 /data

EXPOSE 5230

# Override the upstream entrypoint — run.sh re-enters it after applying the
# add-on configuration, so the ownership fix + privilege drop still happen.
ENTRYPOINT ["/run.sh"]
