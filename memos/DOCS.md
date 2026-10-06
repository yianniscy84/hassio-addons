# Home Assistant Add-on: Memos

Memos is an open-source, self-hosted note-taking service. Write notes in Markdown, organize them with tags and relations, attach files, and search everything instantly — everything stays on your own system.

## Features

- **Markdown notes** — quick capture from any device via the web UI
- **Organization** — tags, pinning, relations between memos, per-memo visibility
- **Attachments** — images and files stored locally under `/data`
- **Full-text search** across all memos
- **REST API & webhooks** for automation
- **Database choice** — SQLite (default) or an external PostgreSQL / MySQL server

## Configuration

### Add-on Options

| Option | Description | Default |
|---|---|---|
| `instance_url` | Canonical external URL of your Memos instance (e.g. `https://memos.example.com`). Leave empty to keep fresh installs private; only set it when you access Memos from outside your network. | `""` |
| `log_level` | Log verbosity: `debug`, `info`, `warn`, `error`. | `info` |
| `db_driver` | Database backend: `sqlite`, `postgres`, or `mysql`. | `sqlite` |
| `db_dsn` | Connection string for an external database, e.g. `postgres://user:password@host:5432/memos?sslmode=disable`. Only used when the driver is not `sqlite`. | `""` |

### After Installation

1. Open Memos on **port 5230** of your Home Assistant host (or use **OPEN WEB UI**).
2. Create the first administrator account.
3. Configure access policy, users, and everything else inside Memos (Settings).
4. Optional: set `instance_url` if you expose Memos externally.

## Accessing the App

Memos is available on **port 5230** of your Home Assistant host (Web UI + API).

> **Why no Ingress / sidebar entry?** Upstream Memos does not support being served
> under a URL sub-path (see [usememos/memos#3781](https://github.com/usememos/memos/issues/3781)),
> which Home Assistant Ingress requires. The add-on therefore uses direct port access,
> like the OmniRoute add-on in this repository.

If port 5230 conflicts with something else on your host, change the **host** side of
the port mapping in the add-on's Network panel — container and `webui` stay on 5230.

## Using an Existing PostgreSQL Add-on

Memos works great against a PostgreSQL server that already runs on your HAOS instance
(for example [alexbelgium's Postgres 17](https://github.com/alexbelgium/hassio-addons/tree/master/postgres_17)).

Add-ons reach each other over Home Assistant's internal network using the name
`{REPO}_{SLUG}`, usable as a DNS hostname with `_` replaced by `-`.

1. **Find your Postgres add-on's internal ID.** Open the add-on's page in Home Assistant
   and look at the browser URL — it ends in `/supervisor/addon/<repo>_<slug>`.
   For a repository added as `https://github.com/alexbelgium/hassio-addons` the ID is
   `db21ed7f_postgres_latest`, so the hostname is **`db21ed7f-postgres-latest`**.
2. **Note the credentials** from the Postgres add-on's Configuration tab:
   `POSTGRES_USER` (default `homeassistant`) and `POSTGRES_PASSWORD`.
3. **Configure the Memos add-on:**

   | Option | Value |
   |---|---|
   | `db_driver` | `postgres` |
   | `db_dsn` | `postgres://homeassistant:<POSTGRES_PASSWORD>@db21ed7f-postgres-latest:5432/memos?sslmode=disable` |

4. **Restart the add-on.** On first start Memos creates the `memos` database
   automatically (the default `homeassistant` user has the required rights). Any
   failure is logged as a warning — check the Log tab if the UI reports a
   database error.

Notes:

- Attachments and instance files always live under `/data`, even with an external
  database; only the memos records move to PostgreSQL.
- MySQL is supported via `db_driver: mysql`, but the database must already exist —
  there is no automatic creation.
- A `db_dsn` that cannot be parsed as a URL (`scheme://user:pass@host:port/db`)
  skips automatic database creation (a warning is logged); memos itself still
  receives the DSN unchanged.

## Data Persistence & Backups

- **`/data`** contains attachments, instance files, and (with the default driver)
  the SQLite database. It is included in the add-on's snapshots (`backup: hot`).
- **With an external PostgreSQL**, the memos records live in the Postgres add-on's
  own volume. Your snapshot of the Memos add-on then only covers `/data` —
  make sure the Postgres add-on's backups are enabled too, and restore both
  together for a consistent state.

## Updating

Updates appear like any other add-on update when the version in `config.yaml`
is bumped. Data survives updates — the SQLite database / attachments stay in
`/data`, and an external database is untouched.

## Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| UI not reachable | Port conflict on the host | Change the host port mapping in the Network panel |
| "could not create database" warning | Wrong DSN host/credentials, or Postgres not ready | Verify the internal hostname and `POSTGRES_USER`/`POSTGRES_PASSWORD`; restart the Postgres add-on first |
| Database error in the UI with an external DB | Database missing and auto-create skipped | Create the database manually, or fix the DSN so it parses as a URL |
| Changes not visible externally | `MEMOS_INSTANCE_URL` / access policy | Set `instance_url` and configure access under Settings |

## Support

- [Upstream Repository](https://github.com/usememos/memos)
- [Memos Documentation](https://usememos.com/docs/getting-started)
- [Add-on Issues](https://github.com/yianniscy84/hassio-addons/issues)
