# Home Assistant Add-on: Postiz

[Postiz](https://github.com/gitroomhq/postiz-app) is the premier open-source social media scheduling, analytics, and automation platform with AI agent capabilities and Model Context Protocol (MCP) integrations. It provides an independent, self-hosted alternative to tools like Buffer and Hootsuite.

## Features

- **Multi-Platform Social Scheduling** — Publish and schedule to X (Twitter), LinkedIn, YouTube, Instagram, Facebook, TikTok, Threads, Pinterest, Reddit, Bluesky, Mastodon, and Discord.
- **Unified Social Inbox & Analytics** — Track engagement, post analytics, and audience growth across channels.
- **AI-Powered Post Creation** — Generate, rewrite, and optimize post copy and scheduling times with OpenAI.
- **Zero-Config Bundled Stack** — Runs out-of-the-box with embedded PostgreSQL and Redis. No external database add-ons required.
- **Model Context Protocol (MCP)** — Built-in agentic surfaces and MCP connector allowing Claude, Cursor, and Home Assistant AI agents to automate social publishing.
- **Full Data Ownership** — Database records, uploads, and secrets persist in `/data` and are backed up via Home Assistant snapshots (`backup: hot`).

---

## Configuration

### Add-on Options

| Option | Type | Default | Description |
|---|---|---|---|
| `main_url` | string | `""` | Canonical external URL (e.g. `https://postiz.example.com` or `http://homeassistant.local:5000`). Essential for OAuth redirects and public image assets. Defaults to `http://localhost:5000` if omitted. |
| `db_url` | password | `""` | PostgreSQL connection string for an external database server (e.g. `postgresql://user:password@host:5432/postiz`). Leave empty to use the bundled PostgreSQL cluster stored in `/data/postgres`. |
| `redis_url` | password | `""` | Redis connection URL for an external Redis server (e.g. `redis://host:6379`). Leave empty to use the bundled in-container Redis instance. |
| `disable_registration` | boolean | `false` | When set to `true`, disables new user registration. Recommended to enable after creating your initial administrator account. |
| `openai_api_key` | password | `""` | Optional OpenAI API key for AI generation and copy rewriting. |
| `storage_provider` | string | `local` | Storage provider for media uploads (`local` or `cloudflare`). |
| `cloudflare_account_id` | string | `""` | Optional Cloudflare Account ID for Cloudflare R2 object storage. |
| `cloudflare_access_key` | password | `""` | Optional Cloudflare R2 Access Key ID. |
| `cloudflare_secret_access_key` | password | `""` | Optional Cloudflare R2 Secret Access Key. |
| `cloudflare_bucketname` | string | `""` | Optional Cloudflare R2 Bucket Name. |
| `cloudflare_bucket_url` | string | `""` | Optional Cloudflare R2 Public Bucket URL (e.g. `https://pub-xxx.r2.dev`). |
| `x_api_key` / `x_api_secret` | string | `""` | X (Twitter) developer app keys (OAuth 1.0a, app type **Native App**). |
| `linkedin_client_id` / `linkedin_client_secret` | string | `""` | LinkedIn app credentials (also used by **LinkedIn Page**). |
| `facebook_app_id` / `facebook_app_secret` | string | `""` | Meta app credentials for Facebook and Instagram (Graph API). |
| `instagram_app_id` / `instagram_app_secret` | string | `""` | Instagram app credentials for the **Instagram (Standalone)** provider. |
| `threads_app_id` / `threads_app_secret` | string | `""` | Threads app credentials. |
| `youtube_client_id` / `youtube_client_secret` | string | `""` | Google Cloud OAuth 2.0 client with YouTube Data API enabled. |
| `tiktok_client_id` / `tiktok_client_secret` | string | `""` | TikTok developer app credentials. |
| `pinterest_client_id` / `pinterest_client_secret` | string | `""` | Pinterest developer app credentials. |
| `reddit_client_id` / `reddit_client_secret` | string | `""` | Reddit **web app** credentials. |
| `discord_client_id` / `discord_client_secret` | string | `""` | Discord application (OAuth2) credentials. |
| `discord_bot_token` | password | `""` | Discord bot token from the same application (needed to list channels and publish). |
| `mastodon_url` | string | `""` | Mastodon instance base URL (default `https://mastodon.social`). |
| `mastodon_client_id` / `mastodon_client_secret` | string | `""` | Self-registered Mastodon app credentials. |
| `github_client_id` / `github_client_secret` | string | `""` | Optional GitHub OAuth app for "Sign in with GitHub". |

#### Which values go where

Postiz does **not** have a settings screen where you paste app IDs and secrets. Channel OAuth apps are read by the backend from the process environment, which is why they are exposed as add-on options here:

- Values you enter in the add-on Configuration tab are exported at container start ([`run.sh`](run.sh)) as the upstream variables (`X_API_KEY`, `LINKEDIN_CLIENT_ID`, `FACEBOOK_APP_ID`, `THREADS_APP_ID`, `YOUTUBE_CLIENT_ID`, `TIKTOK_CLIENT_ID`, `PINTEREST_CLIENT_ID`, `REDDIT_CLIENT_ID`, `DISCORD_CLIENT_ID`, `DISCORD_BOT_TOKEN_ID`, `MASTODON_*`, `GITHUB_*`).
- An option left empty is **not** exported, so providers without credentials stay unconfigured instead of breaking at runtime.
- Channels that need no developer app work without any options: **Bluesky** (handle + app password), **Mastodon** (instance URL), **Telegram** (bot token), **Nostr**, **Lemmy**, **WordPress**, **Listmonk**, **Dev.to**, **Hashnode**, **Farcaster**.
- Changing these values requires an add-on restart; tokens already issued to a channel are stored in the database and are not affected.

---

## Getting Started

1. Start the Postiz add-on from the Home Assistant Add-on Store.
2. Open Postiz on port `5000` of your Home Assistant host (`http://<homeassistant-ip>:5000`) or click **OPEN WEB UI**.
3. Register your initial account. This account acts as the primary administrator.
4. (Recommended) Set `disable_registration: true` in the Configuration tab and restart the add-on to prevent open registrations on your network.

---

## Connecting Social Networks (OAuth Configuration)

Social networks (such as Twitter/X, LinkedIn, Meta, YouTube, TikTok) require public HTTPS redirect callbacks to exchange authorization codes:

1. Expose Postiz via a reverse proxy (e.g., Cloudflare Tunnel, Nginx Proxy Manager, Traefik, or Caddy) with a valid SSL/TLS certificate (e.g., `https://postiz.yourdomain.com`).
2. Set the `main_url` configuration option to your public HTTPS address:
   ```yaml
   main_url: "https://postiz.yourdomain.com"
   ```
3. In each platform developer portal (e.g., LinkedIn Developer Portal, Twitter Developer Portal), configure the OAuth 2.0 Redirect URI to:
   ```text
   https://postiz.yourdomain.com/integrations/social/<provider>
   ```

   | Provider | Redirect URI path | Add-on options |
   |---|---|---|
   | X (Twitter) | `/integrations/social/x` | `x_api_key`, `x_api_secret` |
   | LinkedIn | `/integrations/social/linkedin` | `linkedin_client_id`, `linkedin_client_secret` |
   | LinkedIn Page | `/integrations/social/linkedin-page` | same LinkedIn app |
   | Facebook | `/integrations/social/facebook` | `facebook_app_id`, `facebook_app_secret` |
   | Instagram (via Facebook) | `/integrations/social/instagram` | `facebook_app_id`, `facebook_app_secret` |
   | Instagram (Standalone) | `/integrations/social/instagram-standalone` | `instagram_app_id`, `instagram_app_secret` |
   | Threads | `/integrations/social/threads` | `threads_app_id`, `threads_app_secret` |
   | YouTube | `/integrations/social/youtube` | `youtube_client_id`, `youtube_client_secret` |
   | TikTok | `/integrations/social/tiktok` | `tiktok_client_id`, `tiktok_client_secret` |
   | Pinterest | `/integrations/social/pinterest` | `pinterest_client_id`, `pinterest_client_secret` |
   | Reddit | `/integrations/social/reddit` | `reddit_client_id`, `reddit_client_secret` |
   | Discord | `/integrations/social/discord` | `discord_client_id`, `discord_client_secret`, `discord_bot_token` |
   | Mastodon | app registered on your own instance | `mastodon_url`, `mastodon_client_id`, `mastodon_client_secret` |
   | Bluesky, Telegram, Nostr, Lemmy, WordPress, Listmonk, Dev.to, Hashnode, Farcaster | none — credentials are entered per channel in the UI | — |

4. Paste each platform's client ID and secret into the add-on Configuration tab (see the table above) and restart the add-on. Postiz has **no in-app screen for provider apps**: the backend reads them from the environment (`X_API_KEY`, `LINKEDIN_CLIENT_ID`, `FACEBOOK_APP_ID`, …), which the add-on maps from your options.

---

## Database Configuration

### Bundled PostgreSQL (Default)

When `db_url` is left empty, the add-on runs an embedded PostgreSQL 15 server inside the container with data persisted in `/data/postgres`. Database initialization, socket permissions, and schema migrations (`prisma db push`) run automatically on startup.

### External PostgreSQL Server

If you prefer to use an existing PostgreSQL instance (such as an external database server or alexbelgium's PostgreSQL add-on):

1. Set `db_url` to your database connection URI:
   ```yaml
   db_url: "postgresql://postgres:password@db21ed7f-postgres-latest:5432/postiz?sslmode=disable"
   ```
2. If the `postiz` database does not exist, the add-on will attempt to auto-create it using the administrative credentials from the connection string.
3. Postiz will run schema synchronization against the external database on startup.

---

## Storage & Uploads

- **Local Storage (Default):** Uploaded images, videos, and avatars are stored in `/data/uploads` (symlinked from `/uploads`), making them fully persistent across container updates and included in Home Assistant backups.
- **Cloudflare R2 Storage:** For large video libraries or distributed delivery, select `storage_provider: cloudflare` and provide your Cloudflare R2 credentials.

---

## Data Persistence & Backups

All stateful data is isolated under `/data`:

| Path | Purpose |
|---|---|
| `/data/postgres/` | Bundled PostgreSQL database cluster |
| `/data/uploads/` | Media files, images, videos, and platform icons |
| `/data/jwt_secret` | Persistent authentication signing key |
| `/data/options.json` | Add-on options configured in Home Assistant |

Because everything lives in `/data`, standard Home Assistant backups (`backup: hot`) capture all posts, accounts, and media.

---

## Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| Port 5000 in use | Another service is using host port 5000 | Remap the host port in the Network configuration section (e.g. `5050:5000`). |
| OAuth redirect fails / "Redirect URI mismatch" | `main_url` is not set or doesn't match public domain | Ensure `main_url` is set to the exact public HTTPS domain configured in the social platform's developer portal. |
| Registration failed / Registration disabled | `disable_registration` is active | Set `disable_registration: false` in configuration, restart, create account, then re-enable. |
| Database connection error | External PostgreSQL host unreachable | Check network connectivity and credentials in `db_url`, or leave blank to use the bundled database. |

