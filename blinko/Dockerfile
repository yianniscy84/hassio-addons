ARG BUILD_FROM=blinkospace/blinko:1.8.8

# ============================================================================
# Runtime — based on the official Blinko image (blinkospace/blinko, Alpine)
# ============================================================================
FROM ${BUILD_FROM}

# The upstream image runs as root; PostgreSQL runs as the `postgres` user.
USER root

# bash: bundled PostgreSQL server (out-of-the-box DB, mirrors the securo
#       add-on) incl. client tools for optional external-DB auto-create.
#       python3 is already in the base image (bashio stub + DSN parsing).
RUN apk add --no-cache bash \
    && for v in 18 17 16 15; do \
         if apk add --no-cache "postgresql${v}" "postgresql${v}-client" 2>/dev/null \
            || apk add --no-cache "postgresql${v}" 2>/dev/null; then \
             echo "installed postgresql${v}"; break; \
         fi; \
       done \
    && command -v initdb >/dev/null && command -v pg_ctl >/dev/null && command -v psql >/dev/null

# Stubs for bashio + with-contenv (the upstream image is not built on a
# Home Assistant base image, so neither is available natively).
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN if ! command -v with-contenv >/dev/null 2>&1; then \
      sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub; \
      cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv; \
      chmod +x /usr/bin/with-contenv; \
    fi

ARG BUILD_VERSION=1.8.8
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy addon entry script
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# Persist the app's local storage (/app/.blinko) inside HA's /data volume,
# and seed a default options.json for local (non-HA) runs.
RUN ln -s /data/.blinko /app/.blinko \
    && mkdir -p /data \
    && echo '{"db_url":"","nextauth_url":""}' > /data/options.json

# PostgreSQL runtime prerequisites: the Alpine build writes its socket/lock
# into /run/postgresql and logs to /var/log/postgresql.log, both of which
# must be writable by the postgres user.
RUN mkdir -p /run/postgresql \
    && chown postgres:postgres /run/postgresql \
    && touch /var/log/postgresql.log \
    && chown postgres:postgres /var/log/postgresql.log

EXPOSE 1111

# Override the upstream entrypoint — run.sh applies the add-on configuration
# (secret, database, migrations) before starting Blinko.
ENTRYPOINT ["/run.sh"]
