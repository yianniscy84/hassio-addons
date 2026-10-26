# Changelog

## 0.16.8

- Sync with upstream FreeLLMAPI v0.16.8 (from v0.15.0)
- Upstream Docker base: Node.js 20 to Node.js 24 (Node 20 EOL)
- New providers: IteraCompute (Qwen3.8-27b), Keenable keyless search, Brave Search
- New: Host-header allowlist (ALLOWED_HOSTS) for DNS rebinding protection (opt-in, off by default)
- New: Per-key proxy support, soft budget alerts, keep-alive pings for long-thinking models
- Fix: Long-reasoning stream early commit prevents client timeouts
- No breaking changes or database migrations required

## 0.15.0

- Initial release of the FreeLLMAPI Home Assistant OS add-on.
- Wrapped official multi-architecture container `ghcr.io/tashfeenahmed/freellmapi:v0.15.0` (`amd64`, `aarch64`).
- Direct port `3001` access for Web UI, OpenAI/Anthropic/Gemini APIs, and `/mcp`.
- Persistent storage mounted under `/data` (SQLite database, backups, encryption key).
- Automatic AES-256 encryption key generation and persistence in `/data/.encryption_key`.
- Configurable options: `encryption_key`, `proxy_url`, `declarative_config`, and `retention_days`.
- Stubs included for standalone / local Docker testing.
