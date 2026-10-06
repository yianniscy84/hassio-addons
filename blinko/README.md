# Home Assistant Add-on: Blinko

<p align="center">
  <img src="icon.png" alt="Blinko Logo" width="120">
</p>

<p align="center">
  <strong>AI-powered card note-taking for Home Assistant.</strong><br>
  Capture fleeting thoughts instantly with Markdown, tags, plugins, and AI-enhanced retrieval — self-hosted and private.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fblinko%2Fconfig.yaml&color=brightgreen&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Upstream&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fblinko%2Fupdater.json&color=blue&style=flat-square" alt="Upstream Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fblinko%2Fupdater.json&color=lightgrey&style=flat-square" alt="Last Update">
  <img src="https://img.shields.io/badge/Ingress-No-grey.svg?style=flat-square" alt="Ingress Disabled">
  <img src="https://img.shields.io/badge/Stage-Stable-brightgreen.svg?style=flat-square" alt="Stage Stable">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm" alt="aarch64">
  <img src="https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd" alt="amd64">
</p>

---

## 🌟 Key Features

- **Instant Capture**: Card-based notes for fleeting thoughts, with full Markdown support.
- **AI Retrieval**: RAG-enhanced natural-language search across all of your notes.
- **Organize**: Tags, follows, comments, sharing, trash, and note histories.
- **Plugins**: Extensible via the community plugin marketplace.
- **Works Out of the Box**: A bundled PostgreSQL database lives in `/data` — no external services required (or point it at your own PostgreSQL server).

---

## 📊 Technical Specifications

| Parameter | Specification |
| :--- | :--- |
| **Ingress Support** | No (direct port access) |
| **Direct Host Port** | `1111` (Web UI + API) |
| **Internal Stack** | Node.js / Next.js (official `blinkospace/blinko` image) + bundled PostgreSQL |
| **Database** | Bundled PostgreSQL in `/data/postgres` (default) or external server via `db_url` |
| **Persistent Data** | `/data` (database, attachments, secrets) |
| **Architectures** | `amd64`, `aarch64` (upstream image has no armv7 build) |
| **Upstream Project** | [blinkospace/blinko](https://github.com/blinkospace/blinko) (GPL-3.0) |
| **Documentation** | [Full Add-on Documentation (DOCS.md)](DOCS.md) |

---

## 🚀 Installation & Setup

1. Add the add-on repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **Blinko** and click **Install**.
3. Start the add-on and open it at `http://<your-ha-host>:1111` (or use **OPEN WEB UI**).
4. Register the first account — it becomes your administrator.
5. (Optional) Configure an external database or public URL under **Configuration**.

---

## ⚙️ Configuration Options

| Option | Type | Default | Description |
| :--- | :---: | :---: | :--- |
| `db_url` | password | `""` | External PostgreSQL connection string. Empty = bundled PostgreSQL in `/data/postgres`. |
| `nextauth_url` | str | `""` | Canonical public URL of the instance — only needed for SSO/OIDC or external access. |

> **Using an existing PostgreSQL?** See [DOCS.md](DOCS.md#using-an-existing-postgresql-add-on) —
> the add-on can create the database automatically.

---

## 🛠️ Support & Community

- **Upstream Repository**: [blinkospace/blinko](https://github.com/blinkospace/blinko) (GPL-3.0 License)
- **Memos Documentation**: [docs.blinko.space](https://docs.blinko.space/en/install)
- **GitHub Issues**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
