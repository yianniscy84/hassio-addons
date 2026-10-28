ARG BUILD_FROM=ghcr.io/coollabsio/shoutrrr:1.5.8

# ============================================================================
# Runtime — based on the official Shoutrrr image (multi-arch: amd64 + arm64)
# ============================================================================
FROM ${BUILD_FROM}

# The upstream image runs as www-data (UID 9999). We start as root so the entry
# script can persist Laravel's storage/SQLite directories under /data; the
# supervised PHP processes are dropped to www-data via supervisord.
USER root

# jq + curl are used by the bashio stub, the option reader, and health/debug
# helpers. tzdata keeps log timestamps sane.
RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    curl \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Stubs for bashio + with-contenv (local / non-HA builds).
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub \
    && cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv \
    && chmod +x /usr/bin/with-contenv

ARG BUILD_VERSION=1.5.8
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy addon entrypoint
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# supervisord must stay root so it can re-open the container's stdout/stderr
# pipes (/dev/fd/1); a process that dropped to www-data cannot. Add an explicit
# `user=www-data` to every program section so the supervised PHP processes still
# run unprivileged.
RUN awk '/^\[program:/{print; print "user=www-data"; next}1' \
        /etc/supervisor/laravel.conf > /tmp/laravel.conf \
    && mv /tmp/laravel.conf /etc/supervisor/laravel.conf

COPY supervisor-start.sh /usr/local/bin/supervisor-start.sh
RUN sed -i 's/\r//' /usr/local/bin/supervisor-start.sh \
    && chmod +x /usr/local/bin/supervisor-start.sh

# Persistent data directory + default options for standalone runs
RUN mkdir -p /data && cat > /data/options.json <<'EOF'
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

EXPOSE 8080

ENTRYPOINT ["/run.sh"]
