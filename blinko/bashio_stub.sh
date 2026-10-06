#!/bin/sh
# Minimal stub for bashio::config and logging.
# The blinko base image (blinkospace/blinko) is not built on a Home Assistant
# base image, so this stub is used both for local Docker testing and in HA OS.

bashio::config() {
    local key="$1"
    python3 - "$key" << 'EOF'
import json, sys
key = sys.argv[1]
try:
    with open('/data/options.json') as f:
        d = json.load(f)
    val = d.get(key, '')
    if val is None:
        print('')
    elif isinstance(val, bool):
        print(str(val).lower())
    else:
        print(val)
except Exception:
    print('')
EOF
}

bashio::log.info()  { echo "[INFO]  $*" >&2; }
bashio::log.warn()  { echo "[WARN]  $*" >&2; }
bashio::log.error() { echo "[ERROR] $*" >&2; }
