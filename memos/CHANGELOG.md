# Changelog

## 26.11.1.0

- Sync with upstream Memos 26.11.1 (from 26.11.0)
- Features: Markup tool for memo drawings and non-destructive image annotations, full searchable emoji reaction picker
- Attachments: Unified gallery and file-row layout across composer and saved memos; drag/touch reordering; new database indexes for attachment lookups
- Editor & UI: Caret/formatting preservation for inline code and IME conversion, consistent control sizing and enhanced dark-mode contrast
- Security & Fixes: Updated Go and HTML parser dependencies; resolved overlapping memo updates and sign-in redirect behavior

## 26.11.0.0

- Sync with upstream Memos 26.11.0 (from v0.31.0; upstream transitioned to CalVer)
- Adoption of standardized `<upstream_version>.<addon_revision>` versioning scheme
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
