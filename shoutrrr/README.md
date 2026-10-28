# Home Assistant Add-on: Shoutrrr

<p align="center">
  <img src="https://raw.githubusercontent.com/yianniscy84/hassio-addons/main/shoutrrr/icon.png" alt="Shoutrrr Logo" width="120">
</p>

<p align="center">
  <strong>Self-hosted social media scheduler for Home Assistant.</strong><br>
  Write once, publish everywhere — X, Bluesky, LinkedIn, Facebook, Instagram, Threads and Discord from one calendar.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fshoutrrr%2Fconfig.yaml&color=brightgreen&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/Stage-Stable-brightgreen.svg?style=flat-square" alt="Stage Stable">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm" alt="aarch64">
  <img src="https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd" alt="amd64">
</p>

---

## 🌟 Key Features

- **Multi-platform publishing**: X, Bluesky, LinkedIn, Facebook Pages, Instagram, Threads and Discord from a single composer.
- **Queue & calendar**: recurring posting slots in your workspace timezone plus a month view of scheduled content.
- **Analytics & engagement**: follower/post trends, per-post engagement metrics, and a replies inbox.
- **Workspaces & team**: roles, email invitations, and instance-level settings.
- **Secure by default**: email/password with verification (when SMTP is configured), TOTP two-factor, passkeys, optional Google login.
- **API + MCP**: Passport bearer tokens, REST API, and a Model Context Protocol server at `/mcp`.

---

## 📊 Technical Specifications

| Parameter | Specification |
| :--- | :--- |
| **Direct Host Port** | `8080` (Web UI + `/api` + `/mcp`) |
| **Internal Stack** | PHP 8.5 / Laravel 13 / Octane on FrankenPHP, React 19 + Inertia (`ghcr.io/coollabsio/shoutrrr:1.5.8`) |
| **Database** | SQLite in `/data/sqlite/database.sqlite` |
| **Background Jobs** | In-container queue worker + scheduler (supervisord) |
| **Persistent Data** | `/data` (SQLite DB, media, logs, Passport keys, `app_key`) |
| **Upstream Project** | [coollabsio/shoutrrr](https://github.com/coollabsio/shoutrrr) |
| **Documentation** | [Full Add-on Documentation (DOCS.md)](DOCS.md) |

---

## 🚀 Installation & Setup

1. Add the add-on repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **Shoutrrr** and click **Install**.
3. Start the add-on and open `http://<your-ha-host>:8080` (or click **OPEN WEB UI**).
4. Register the first account — it becomes the instance owner.
5. Connect your social accounts, and add OAuth app credentials in the add-on configuration if you plan to use X, LinkedIn, Facebook/Instagram or Threads.

> **Public HTTPS is required** for Bluesky OAuth, passkeys, and provider callbacks outside your LAN. Set `app_url` to your public HTTPS URL and `trusted_proxies` when running behind a tunnel or reverse proxy.

---

## ⚙️ Configuration Options

| Option | Type | Default | Description |
| :--- | :---: | :---: | :--- |
| `app_url` | str | `http://homeassistant.local:8080` | Canonical external URL (used for links, redirects and OAuth callbacks). |
| `app_key` | password | `""` | Laravel key; auto-generated at `/data/app_key` when empty. |
| `log_level` | list | `info` | Log verbosity. |
| `registrations_enabled` | bool | `false` | Allow sign-ups after the owner account exists. |
| `trusted_proxies` | str | `""` | Trusted proxy IPs/CIDRs, or `*` when proxy-only. |
| `queue_workers` | int | `1` | In-container queue workers (keep 1 with SQLite). |
| `mail_enabled` + `mail_*` | bool/str | `false` | SMTP settings for invitations, password resets and verification. |
| `x_*`, `linkedin_*`, `facebook_*`, `threads_*` | str/password | `""` | OAuth app credentials for connected accounts. |
| `google_*` | str/password | `""` | Google credentials; enables "Sign in with Google". |
| `metrics_enabled` | bool | `true` | Poll post/account metrics. |
| `engagement_enabled` | bool | `true` | Poll replies/likes/comments. |
| `messages_enabled` | bool | `true` | Enable the direct-messages inbox. |

See [DOCS.md](DOCS.md) for the complete option table, provider scopes and redirect URIs.

---

## 🛠️ Support & Community

- **Upstream Repository**: [coollabsio/shoutrrr](https://github.com/coollabsio/shoutrrr) (Apache-2.0)
- **Upstream Website**: [shoutrrr.com](https://shoutrrr.com)
- **Add-on Issues**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
