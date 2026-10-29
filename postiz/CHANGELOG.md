# Changelog

## 2.25.3.1

- Added add-on options for social provider OAuth apps, which upstream Postiz reads only from the process environment:
  - `x_api_key` / `x_api_secret`
  - `linkedin_client_id` / `linkedin_client_secret` (also used by LinkedIn Page)
  - `facebook_app_id` / `facebook_app_secret` (Facebook + Instagram)
  - `instagram_app_id` / `instagram_app_secret` (Instagram Standalone)
  - `threads_app_id` / `threads_app_secret`
  - `youtube_client_id` / `youtube_client_secret`
  - `tiktok_client_id` / `tiktok_client_secret`
  - `pinterest_client_id` / `pinterest_client_secret`
  - `reddit_client_id` / `reddit_client_secret`
  - `discord_client_id` / `discord_client_secret` / `discord_bot_token`
  - `mastodon_url` / `mastodon_client_id` / `mastodon_client_secret`
  - `github_client_id` / `github_client_secret`
- Values are exported to `X_API_KEY`, `LINKEDIN_CLIENT_ID`, `FACEBOOK_APP_ID`, `DISCORD_BOT_TOKEN_ID`, etc. only when non-empty, so unconfigured providers stay disabled instead of failing at runtime.
- Documented the real OAuth redirect URI pattern (`<main_url>/integrations/social/<provider>`), replacing the incorrect `/oauth/<provider>/callback` path, and added a per-provider redirect/option table.
- Clarified that self-hosted Postiz has no in-app screen for provider app credentials.

## 2.25.3

- Initial release of the Postiz Home Assistant OS add-on.
- Wrapped official multi-architecture container `ghcr.io/gitroomhq/postiz-app:v2.25.3` (`amd64`, `aarch64`).
- Direct port `5000` access for Postiz Web UI, API (`/api/`), and local media uploads (`/uploads/`).
- Zero-configuration out-of-the-box operation with bundled PostgreSQL 15 and Redis server.
- Persistent storage in `/data`:
  - PostgreSQL database cluster in `/data/postgres`
  - Uploaded media and avatars in `/data/uploads`
  - Cryptographically secure JWT secret in `/data/jwt_secret`
- Support for external PostgreSQL databases (`db_url`) and external Redis instances (`redis_url`).
- Configurable `main_url` for OAuth integration with Twitter/X, LinkedIn, Meta, YouTube, TikTok, Reddit, and Discord.
- Support for Cloudflare R2 / S3 storage backend and OpenAI API key for AI generation features.
- Full backup and restore support (`backup: hot`).

