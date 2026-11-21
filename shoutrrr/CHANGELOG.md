# Changelog

## 1.5.9.0

- Sync with upstream Shoutrrr v1.5.9
- Security: Rebuilt upstream base image on `serversideup/php` v5.1.5 with PHP 8.5.13 (fixes 17 PHP CVEs) and FrankenPHP 1.13.5 / Caddy 2.11.9 (fixes worker mode cookie/output bleed advisory)
- Security: Patched Composer and JS dependencies (laravel/framework 13.43, symfony 8.1.10+, phpseclib 4.0.3, undici, hono, body-parser, fast-uri, systeminformation, zod)
- Addon & Upstream: Dedicated LinkedIn Pages support via `linkedin_pages_client_id` and `linkedin_pages_client_secret` options with callback `${APP_URL}/accounts/callback/linkedin-pages`
- Upstream: Public API video upload endpoints (`POST /api/v1/media/video/upload-url`, `POST /api/v1/media/video`)
- Upstream fixes: Threads replies container readiness wait, MySQL/MariaDB migration fix, X error detail reporting, oversized image pre-upload downscaling, quick reply box clearing, MCP workspace binding preservation on token refresh, and large Facebook Page IDs integer safety

## 1.5.8.0

- Adoption of standardized `<upstream_version>.<addon_revision>` versioning scheme
- Aligned add-on version with upstream Shoutrrr 1.5.8

## 1.5.8

- Initial release of the Shoutrrr Home Assistant OS add-on.
- Wrapped official multi-architecture container `ghcr.io/coollabsio/shoutrrr:1.5.8` (`amd64`, `aarch64`).
- Direct port `8080` access for the web UI, REST API, and MCP endpoint (`/mcp`).
- Persistent storage under `/data`: SQLite database (`/data/sqlite`), media/logs/Passport keys (`/data/storage`), Laravel `APP_KEY` (`/data/app_key`).
- Upstream start-up tasks preserved: `storage:link`, database migrations, and Laravel optimization run on every start before supervisord launches Octane, the queue worker, and the scheduler.
- Configurable options: app URL and key, log level, registrations, trusted proxies, queue workers, SMTP, X/LinkedIn/Facebook/Threads/Google OAuth credentials, and metrics/engagement/messages toggles.
- `app_key` is validated at start-up (must decode to 32 bytes) instead of letting Octane fail in a restart loop.
- Stubs included for standalone / local Docker testing.
