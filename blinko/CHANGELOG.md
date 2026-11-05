# Changelog

## 1.8.9

- Sync with upstream Blinko 1.8.9 (from 1.8.8)
- Security hardening and maintenance improvements
- Compatibility fixes across client and server
- No breaking changes or database migrations required

## 1.8.8

- Initial release based on `blinkospace/blinko:1.8.8` (upstream v1.8.8)
- Direct access on port 1111 (no ingress)
- Bundled PostgreSQL in `/data/postgres` — works out of the box, included in snapshots
- Optional external PostgreSQL via `db_url` with automatic `CREATE DATABASE` on first start
- Auto-generated `NEXTAUTH_SECRET` persisted at `/data/nextauth_secret`
- Local storage (`/app/.blinko`) symlinked into `/data` so attachments are snapshotted
- Bashio stubs for local Docker testing
