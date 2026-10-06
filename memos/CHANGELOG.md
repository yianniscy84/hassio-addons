# Changelog

## 0.31.0

- Initial release based on `neosmemo/memos:0.31.0` (upstream v0.31.0)
- Direct access on port 5230 — no ingress (upstream has no base-path support)
- SQLite in `/data` by default; optional external PostgreSQL/MySQL via `db_driver` / `db_dsn`
- Automatic `CREATE DATABASE` on first start when using PostgreSQL
- Bashio stubs for local Docker testing
