# Changelog

## 26.11.0

- Sync with upstream Memos 26.11.0 (from v0.31.0; upstream transitioned to CalVer)
- Editor: fixed Japanese and Korean IME composition in Safari
- Attachments: explicit JSON errors and 404s for unreadable/missing attachments with cause logging
- Server: fixed cache eviction race conditions under concurrent load
- Reliable configuration and upgrades from v0.31 deployment files

## 0.31.0

- Initial release based on `neosmemo/memos:0.31.0` (upstream v0.31.0)
- Direct access on port 5230 — no ingress (upstream has no base-path support)
- SQLite in `/data` by default; optional external PostgreSQL/MySQL via `db_driver` / `db_dsn`
- Automatic `CREATE DATABASE` on first start when using PostgreSQL
- Bashio stubs for local Docker testing
