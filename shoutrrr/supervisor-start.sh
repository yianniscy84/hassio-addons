#!/bin/sh
# ============================================================================
# Starts supervisord after the serversideup entrypoint's init scripts
# (storage:link, migrations, optimize) have run as root.
#
# Those scripts create root-owned files inside the persisted directories, so
# ownership is handed back to www-data before the supervised processes start.
# supervisord itself stays root because a non-root process cannot re-open the
# container's stdout/stderr pipes (/dev/fd/1) once PID 1 started as root;
# each [program:*] section carries `user=www-data` instead.
# ============================================================================
set -e

chown -R www-data:www-data \
    /data/storage/framework \
    /data/storage/logs \
    /data/sqlite \
    /var/www/html/bootstrap/cache 2>/dev/null || true

exec supervisord -c /etc/supervisor/laravel.conf
