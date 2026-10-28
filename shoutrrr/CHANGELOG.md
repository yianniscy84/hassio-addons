# Changelog

## 1.5.8

- Initial release of the Shoutrrr Home Assistant OS add-on.
- Wrapped official multi-architecture container `ghcr.io/coollabsio/shoutrrr:1.5.8` (`amd64`, `aarch64`).
- Direct port `8080` access for the web UI, REST API, and MCP endpoint (`/mcp`).
- Persistent storage under `/data`: SQLite database (`/data/sqlite`), media/logs/Passport keys (`/data/storage`), Laravel `APP_KEY` (`/data/app_key`).
- Upstream start-up tasks preserved: `storage:link`, database migrations, and Laravel optimization run on every start before supervisord launches Octane, the queue worker, and the scheduler.
- Configurable options: app URL and key, log level, registrations, trusted proxies, queue workers, SMTP, X/LinkedIn/Facebook/Threads/Google OAuth credentials, and metrics/engagement/messages toggles.
- `app_key` is validated at start-up (must decode to 32 bytes) instead of letting Octane fail in a restart loop.
- Stubs included for standalone / local Docker testing.
