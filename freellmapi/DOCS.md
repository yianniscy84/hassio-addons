# Home Assistant Add-on: FreeLLMAPI

[FreeLLMAPI](https://github.com/tashfeenahmed/freellmapi) is an open-source, OpenAI-compatible proxy and routing layer that aggregates free LLM provider tiers behind a single `/v1` endpoint.

It features smart failover, per-key rate tracking, encrypted key storage, custom endpoint pass-through, a full React admin dashboard, and native Anthropic, Gemini, Ollama, and Model Context Protocol (MCP) surfaces.

---

## Features

- **Massive Free Inference Aggregation**: Combines dozens of free LLM providers (Google, Groq, Cerebras, Mistral, OpenRouter, Cloudflare, Cohere, HuggingFace, etc.) and custom local/remote endpoints (Ollama, vLLM, LM Studio) behind one unified `/v1` endpoint.
- **Smart Routing & Failover**: Automatic fallback between configured providers when one hits rate limits or server errors, with cooldowns and key rotation.
- **Full OpenAI-Compatible Surface**: `/v1/chat/completions`, `/v1/responses`, `/v1/completions`, `/v1/images/generations`, `/v1/audio/speech`, `/v1/embeddings`, and `/v1/models`.
- **Anthropic, Gemini & Ollama Surfaces**: Native `/v1/messages` for Claude Code and Anthropic SDKs, `/v1beta` for Gemini CLI, and Ollama emulation.
- **ChatGPT-Ready MCP Server**: Access inference and provider metrics directly via `/mcp`.
- **Encrypted Storage**: Provider API keys are AES-256-GCM encrypted at rest in SQLite and decrypted only in memory per request.
- **Web Dashboard**: Clean, responsive UI for managing keys, reordering fallback chains, testing models in the playground, and monitoring performance analytics.

---

## Configuration

### Add-on Options

| Option | Type | Default | Description |
|---|---|---|---|
| `encryption_key` | password | `""` | Optional 32-byte (64 hex characters) AES-256 encryption key. If left empty, the add-on automatically generates and persists a key at `/data/.encryption_key` on first boot. |
| `proxy_url` | string | `""` | Optional outbound HTTP or SOCKS proxy (e.g. `http://host.docker.internal:7890` or `socks5h://192.168.1.10:1080`) if your network requires a proxy to reach AI providers. |
| `declarative_config` | string | `""` | Optional raw JSON matching FreeLLMAPI's declarative startup schema (`FREEAPI_CONFIG_JSON`) to idempotently configure admin accounts, keys, or fallback chains on boot. |
| `retention_days` | integer | `90` | Number of days to retain request analytics rows (set to `0` to disable retention pruning). |

---

## Accessing the App

FreeLLMAPI is accessible directly on **port 3001** of your Home Assistant host:
- **Web UI & Dashboard**: `http://<YOUR_HA_IP>:3001` (or click **OPEN WEB UI** in the add-on card).
- **OpenAI-Compatible Endpoint**: `http://<YOUR_HA_IP>:3001/v1`
- **Anthropic Endpoint**: `http://<YOUR_HA_IP>:3001/v1` (with Anthropic headers/endpoints)
- **MCP Endpoint**: `http://<YOUR_HA_IP>:3001/mcp`
- **OpenAPI Documentation**: `http://<YOUR_HA_IP>:3001/v1/docs`

> **Why direct port access?**
> Standard LLM client libraries, command-line coding agents (Claude Code, Cursor, OpenCode), and Home Assistant integrations connect using direct HTTP endpoints without Home Assistant Ingress session tokens. Direct port 3001 provides unrestricted, high-performance compatibility.

---

## Quick Start

1. Start the **FreeLLMAPI** add-on in Home Assistant.
2. Click **OPEN WEB UI** or open `http://<YOUR_HA_IP>:3001` in your browser.
3. On the **Keys** page:
   - Add your free provider API keys (Groq, Google Gemini, OpenRouter, Mistral, Cerebras, etc.).
   - Copy your unified API key from the header (`freellmapi-...`).
4. Reorder the **Fallback Chain** to set your preferred priority order.

---

## Client Integration Examples

### Home Assistant OpenAI Conversation Integration

You can use FreeLLMAPI directly inside Home Assistant for voice or chat assistance:
1. Go to **Settings** → **Devices & services** → **Add integration** → **OpenAI Conversation**.
2. Set **API Key** to your FreeLLMAPI unified key (`freellmapi-...`).
3. Under **Advanced settings**:
   - Set **Base URL** to `http://127.0.0.1:3001/v1` (or `http://localhost:3001/v1`).
4. Select your preferred model or chain profile (e.g. `auto:default`, `gemini-2.0-flash`, `llama-3.3-70b-versatile`).

### Claude Code

```bash
npx freellmapi setup-claude --url http://<YOUR_HA_IP>:3001 --api-key <YOUR_UNIFIED_KEY>
```

### Cursor & OpenCode

In Cursor / OpenCode settings:
- **Base URL**: `http://<YOUR_HA_IP>:3001/v1`
- **API Key**: `<YOUR_UNIFIED_KEY>`
- **Model**: `auto:coding` or specific provider model

---

## Data Persistence & Backups

All state is persisted under Home Assistant's `/data` volume:
- SQLite Database: `/data/freeapi.db`
- Backups: `/data/backups/`
- Encryption Key: `/data/.encryption_key`

Home Assistant partial or full backups include this entire `/data` directory.
