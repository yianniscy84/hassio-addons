# Home Assistant Add-on: Blinko

Blinko is an open-source, self-hosted AI card note-taking app. Capture fleeting thoughts in Markdown, organize them with tags, and find them again with AI-enhanced natural-language search — all stored on your own system.

## Features

- **Instant capture** — card notes with full Markdown support
- **AI-powered retrieval** — RAG-style natural-language search over your notes
- **Organization** — tags, follows, comments, sharing, trash, note history
- **Plugins** — extend with the community plugin marketplace
- **Data ownership** — everything stays in `/data` on your Home Assistant device

## Configuration

### Add-on Options

| Option | Description | Default |
|---|---|---|
| `db_url` | PostgreSQL connection string for an external server, e.g. `postgres://user:password@host:5432/blinko`. Leave empty to use the bundled PostgreSQL stored in `/data/postgres`. | `""` |
| `nextauth_url` | Canonical external URL of your Blinko instance (e.g. `https://blinko.example.com`). Needed only for SSO/OIDC or access from outside your network. | `""` |

### After Installation

1. Open Blinko on **port 1111** of your Home Assistant host (or use **OPEN WEB UI**).
2. Register the first account — it becomes the administrator.
3. Configure AI providers, plugins, and appearance inside Blinko.

The add-on auto-generates `NEXTAUTH_SECRET` on first start (stored at
`/data/nextauth_secret`) and runs database migrations (`prisma migrate deploy`)
on every start — no manual migration steps.

## Accessing the App

Blinko is available on **port 1111** of your Home Assistant host (Web UI + API).
No Ingress/sidebar entry is provided (direct port access only). If port 1111
conflicts with something else, change the **host** side of the port mapping in
the Network panel.

## Database

### Bundled PostgreSQL (default)

With `db_url` empty, the add-on runs its own PostgreSQL instance with data in
`/data/postgres`. It is initialized automatically on first start, waits for
readiness, and is shut down cleanly on stop. Everything — database, attachments,
secrets — is covered by the add-on's snapshots (`backup: hot`).

### Using an Existing PostgreSQL Add-on

Set `db_url` to point at another server (for example
[alexbelgium's Postgres 17](https://github.com/alexbelgium/hassio-addons/tree/master/postgres_17)).
Add-ons reach each other over Home Assistant's internal network using
`{REPO}_{SLUG}` (as a DNS hostname with `_` replaced by `-`):

1. **Find your Postgres add-on's internal ID** — open its page in Home Assistant
   and read the browser URL: `…/supervisor/addon/<repo>_<slug>`. For
   `https://github.com/alexbelgium/hassio-addons` it is `db21ed7f_postgres_latest`,
   i.e. hostname **`db21ed7f-postgres-latest`**.
2. **Note the credentials** from its Configuration tab — with the add-on defaults
   that is user `postgres` and password `homeassistant` (`POSTGRES_USER` /
   `POSTGRES_PASSWORD`), matching alexbelgium's own Immich defaults.
3. **Set the Blinko option** (internal add-on name shown; use
   `homeassistant.local` instead for the host-name variant Immich uses):

   ```
   db_url: postgres://postgres:<POSTGRES_PASSWORD>@db21ed7f-postgres-latest:5432/blinko?sslmode=disable
   ```

4. **Restart the add-on.** The `blinko` database is created automatically on
   first start (any failure is logged as a warning), then Blinko runs its
   migrations against it.

> With an external database, your snapshot only covers `/data` (attachments and
> secrets) — enable backups on the Postgres add-on too and restore both together.

## Data Persistence & Backups

Everything lives under `/data`:

| Path | Contents |
|---|---|
| `/data/postgres` | Bundled PostgreSQL cluster (default mode) |
| `/data/.blinko` | Attachments and local app storage (symlinked from `/app/.blinko`) |
| `/data/nextauth_secret` | Auto-generated NextAuth signing secret |
| `/data/options.json` | Add-on configuration |

## Updating

Updates appear like any other add-on update when the version in `config.yaml`
is bumped. Migrations run automatically at start; data survives updates.

## Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| UI not reachable | Port conflict on the host | Change the host port mapping in the Network panel |
| "Prisma migrations failed" | External DB unreachable or wrong credentials | Verify `db_url`, make sure the Postgres add-on is running first |
| "could not create database" warning | Wrong DSN host/credentials | Verify the internal hostname and `POSTGRES_USER`/`POSTGRES_PASSWORD` |
| Login/SSO redirect problems | Instance served under a different URL | Set `nextauth_url` to the canonical URL |
| armv7 install unavailable | Upstream image ships amd64/arm64 only | Use an x86_64 or ARM64 Home Assistant device |

## Support

- [Upstream Repository](https://github.com/blinkospace/blinko) (GPL-3.0)
- [Blinko Documentation](https://docs.blinko.space/en/install)
- [Add-on Issues](https://github.com/yianniscy84/hassio-addons/issues)
