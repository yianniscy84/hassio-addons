#!/bin/sh
# Minimal stub for bashio::config and logging.
# Used only when running outside the HA supervisor (local Docker testing).
# In HA OS the real bashio is provided by the base image.
#
# Parsing is done with jq instead of python3 because the Shoutrrr image is a
# slim Debian PHP image with jq preinstalled and no python3.

bashio::config() {
    local key="$1"
    if [ ! -f /data/options.json ]; then
        echo ""
        return 0
    fi
    # Note: `//` cannot be used here — jq treats boolean false as falsy, so
    # `false // ""` would turn a legit `false` into an empty string.
    jq -r --arg k "$key" '
        if has($k) and (.[$k] != null) then
            .[$k] | if type == "boolean" then tostring
                    elif type == "string" then .
                    else tostring end
        else "" end
    ' /data/options.json 2>/dev/null || echo ""
}

bashio::config.has_value() {
    local value
    value=$(bashio::config "$1")
    [ -n "$value" ]
}

bashio::log.info()  { echo "[INFO]  $*"; }
bashio::log.warn()  { echo "[WARN]  $*"; }
bashio::log.error() { echo "[ERROR] $*"; }
bashio::log.debug() { echo "[DEBUG] $*"; }
