# Changelog

## 0.3.7

- Add `webui` directive to restore "Open Web UI" button in Home Assistant

## 0.3.6

- Remove ingress support (no more HA sidebar access)
- Remove nginx — app accessed directly on port 20128
- Update DOCS.md to remove ingress references

## 0.3.5

- Fix sidebar icon: use `mdi:api` instead of invalid `mdi:route`

## 0.3.3

- Install nginx, curl, tzdata in Dockerfile
- Start nginx in run.sh before OmniRoute
- Set ENTRYPOINT instead of CMD to override image entrypoint
- Set OMNIROUTE_BASE_PATH and NEXT_PUBLIC_BASE_URL for reverse proxy

## 0.3.2

- Run addon as root (standard HAOS behavior) to fix EACCES permission errors
- Fix /data ownership — chown in Dockerfile for fresh builds

## 0.3.1

- Chown /data to node user in Dockerfile
- Simplify Redis startup (drop pidfile)

## 0.3.0

- Run all Dockerfile setup as root before switching to node

## 0.2.0

- Switch to pre-built OmniRoute image (diegosouzapw/omniroute:latest) — build from source OOM'd on HA devices
- Bundled Redis via apt-get (Debian-based image)
- Ingress support (HA sidebar access)
- Minimal config surface: initial_password, require_api_key, auth_cookie_secure
- Bashio stubs for local Docker testing
