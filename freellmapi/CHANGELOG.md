# Changelog

## 0.15.0

- Initial release of the FreeLLMAPI Home Assistant OS add-on.
- Wrapped official multi-architecture container `ghcr.io/tashfeenahmed/freellmapi:v0.15.0` (`amd64`, `aarch64`).
- Direct port `3001` access for Web UI, OpenAI/Anthropic/Gemini APIs, and `/mcp`.
- Persistent storage mounted under `/data` (SQLite database, backups, encryption key).
- Automatic AES-256 encryption key generation and persistence in `/data/.encryption_key`.
- Configurable options: `encryption_key`, `proxy_url`, `declarative_config`, and `retention_days`.
- Stubs included for standalone / local Docker testing.
