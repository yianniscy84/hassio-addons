# Changelog

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

