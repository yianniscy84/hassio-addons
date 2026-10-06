# Home Assistant Add-on: Memos

<p align="center">
  <img src="icon.png" alt="Memos Logo" width="120">
</p>

<p align="center">
  <strong>Self-hosted note-taking and memo service for Home Assistant.</strong><br>
  Write, organize, and share memos with tags, relations, attachments, and full-text search.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fmemos%2Fconfig.yaml&color=brightgreen&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Upstream&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fmemos%2Fupdater.json&color=blue&style=flat-square" alt="Upstream Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fmemos%2Fupdater.json&color=lightgrey&style=flat-square" alt="Last Update">
  <img src="https://img.shields.io/badge/Ingress-No-grey.svg?style=flat-square" alt="Ingress Disabled">
  <img src="https://img.shields.io/badge/Stage-Stable-brightgreen.svg?style=flat-square" alt="Stage Stable">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm" alt="aarch64">
  <img src="https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd" alt="amd64">
  <img src="https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm" alt="armv7">
</p>

---

## 🌟 Key Features

- **Markdown Notes**: Quick capture from any device with a clean, fast web UI.
- **Organize**: Tags, pinning, memo relations, per-memo visibility, and custom styles.
- **Attachments**: Images and files stored locally under `/data`.
- **Full-text Search**: Find anything instantly across all memos.
- **Database Choice**: SQLite out of the box, or an external PostgreSQL / MySQL server.
- **REST API**: Full API plus webhooks for automation from Home Assistant or anywhere.

---

## 📊 Technical Specifications

| Parameter | Specification |
| :--- | :--- |
| **Ingress Support** | No (direct port access — upstream has no base-path support) |
| **Direct Host Port** | `5230` (Web UI + API) |
| **Internal Stack** | Go server (official `neosmemo/memos` image) |
| **Database** | SQLite in `/data` (default) or external PostgreSQL / MySQL |
| **Persistent Data** | `/data` (attachments, instance files; SQLite DB when used) |
| **Upstream Project** | [usememos/memos](https://github.com/usememos/memos) |
| **Documentation** | [Full Add-on Documentation (DOCS.md)](DOCS.md) |

---

## 🚀 Installation & Setup

1. Add the add-on repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **Memos** and click **Install**.
3. Start the add-on and open it at `http://<your-ha-host>:5230` (or use **OPEN WEB UI**).
4. Create the first administrator account, then start writing memos.
5. (Optional) Configure `instance_url`, logging, or an external database under **Configuration**.

---

## ⚙️ Configuration Options

| Option | Type | Default | Description |
| :--- | :---: | :---: | :--- |
| `instance_url` | str | `""` | Canonical external URL of your Memos instance. Leave empty to keep fresh installs private. |
| `log_level` | list | `"info"` | Log verbosity: `debug`, `info`, `warn`, `error`. |
| `db_driver` | list | `"sqlite"` | Database backend: `sqlite`, `postgres`, or `mysql`. |
| `db_dsn` | password | `""` | Connection string for an external database (only used when the driver is not `sqlite`). |

> **Using an existing PostgreSQL?** See [DOCS.md](DOCS.md#using-an-existing-postgresql-add-on)
> for the full walkthrough, including the internal hostname of another add-on.

---

## 🛠️ Support & Community

- **Upstream Repository**: [usememos/memos](https://github.com/usememos/memos) (MIT License)
- **Memos Documentation**: [usememos.com/docs](https://usememos.com/docs/getting-started)
- **GitHub Issues**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
