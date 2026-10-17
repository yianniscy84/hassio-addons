# Home Assistant Add-on: FreeLLMAPI

<p align="center">
  <img src="https://raw.githubusercontent.com/yianniscy84/hassio-addons/main/freellmapi/icon.png" alt="FreeLLMAPI Logo" width="120">
</p>

<p align="center">
  <strong>OpenAI-compatible proxy and routing layer for Home Assistant.</strong><br>
  Aggregates dozens of free LLM provider tiers and hundreds of models behind a single unified endpoint with intelligent failover.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Ffreellmapi%2Fconfig.yaml&color=brightgreen&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/Ingress-No-grey.svg?style=flat-square" alt="Ingress Disabled">
  <img src="https://img.shields.io/badge/Stage-Stable-brightgreen.svg?style=flat-square" alt="Stage Stable">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm" alt="aarch64">
  <img src="https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd" alt="amd64">
</p>

---

## 🌟 Key Features

- **Massive Free Inference Aggregation**: 34+ free LLM providers (Google, Groq, Mistral, Cerebras, OpenRouter, Cohere, Cloudflare, etc.) plus custom endpoints.
- **Unified `/v1` Endpoint**: OpenAI, Anthropic, Gemini, and Ollama-compatible API surfaces.
- **Smart Failover & Key Rotation**: Auto-switches providers upon rate limits (429) or upstream errors.
- **ChatGPT-Ready MCP Server**: Native Model Context Protocol over `/mcp`.
- **Encrypted Storage**: Provider API keys encrypted with AES-256-GCM in SQLite (`/data`).
- **Web Dashboard**: Clean management interface for fallback chains, playground, and token usage analytics.

---

## 📊 Technical Specifications

| Parameter | Specification |
| :--- | :--- |
| **Ingress Support** | No (direct port access for compatibility with standard LLM clients) |
| **Direct Host Port** | `3001` (Web UI + `/v1` API + `/mcp`) |
| **Internal Stack** | Node.js 20 (official `ghcr.io/tashfeenahmed/freellmapi:v0.15.0` image) |
| **Database** | SQLite in `/data/freeapi.db` |
| **Persistent Data** | `/data` (SQLite DB, backups, `.encryption_key`) |
| **Upstream Project** | [tashfeenahmed/freellmapi](https://github.com/tashfeenahmed/freellmapi) |
| **Documentation** | [Full Add-on Documentation (DOCS.md)](DOCS.md) |

---

## 🚀 Installation & Setup

1. Add the add-on repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **FreeLLMAPI** and click **Install**.
3. Start the add-on and open it at `http://<your-ha-host>:3001` (or click **OPEN WEB UI**).
4. Add your free provider keys on the **Keys** page, copy your unified API key, and configure your coding agent or Home Assistant OpenAI Conversation integration.

---

## ⚙️ Configuration Options

| Option | Type | Default | Description |
| :--- | :---: | :---: | :--- |
| `encryption_key` | password | `""` | Optional AES-256 encryption key (auto-generated in `/data/.encryption_key` if omitted). |
| `proxy_url` | str | `""` | Outbound HTTP/SOCKS proxy URL. |
| `declarative_config` | str | `""` | Optional raw JSON configuration applied on startup (`FREEAPI_CONFIG_JSON`). |
| `retention_days` | int | `90` | Request analytics retention limit in days. |

---

## 🛠️ Support & Community

- **Upstream Repository**: [tashfeenahmed/freellmapi](https://github.com/tashfeenahmed/freellmapi) (MIT License)
- **Documentation**: [freellmapi.co](https://freellmapi.co)
- **GitHub Issues**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
