# Home Assistant Add-on: OmniRoute

<p align="center">
  <img src="https://raw.githubusercontent.com/yianniscy84/hassio-addons/main/omniroute/icon.png" alt="OmniRoute Logo" width="120">
</p>

<p align="center">
  <strong>Universal AI Gateway & LLM Router for Home Assistant.</strong><br>
  One OpenAI-compatible endpoint for 350+ providers and 1200+ models, with smart failover and token compression.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fconfig.yaml&color=brightgreen&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Upstream&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fupdater.json&color=blue&style=flat-square" alt="Upstream Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fupdater.json&color=lightgrey&style=flat-square" alt="Last Update">
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

- **350+ AI Providers**: Route seamlessly between Claude (Anthropic), GPT (OpenAI), Gemini (Google), DeepSeek, Kimi, Groq, Mistral, Ollama, and hundreds more.
- **1200+ Supported Models**: Includes access to 90+ free-tier models (~1.5B free tokens/month aggregate across providers).
- **Intelligent Fallback & Routing**: 19 routing strategies including automatic failover, priority tiers, round-robin, cost optimization, and latency-based routing.
- **Unified OpenAI-Compatible API**: Drop-in replacement endpoint (`/v1/chat/completions`) for any tool or library that supports OpenAI.
- **Token Compression**: Built-in RTK and Caveman prompt compression engines that reduce token usage by 15% to 95%.
- **Modern Management Dashboard**: Web UI for managing API keys, providers, model aliases, and traffic metrics.
- **Agent Protocols**: Built-in Model Context Protocol (MCP) and Agent-to-Agent (A2A) tool chaining support.

---

## 📊 Technical Specifications

| Parameter | Specification |
| :--- | :--- |
| **Ingress Support** | No (Direct port access) |
| **Direct Host Port** | `20128` (Dashboard UI + API Endpoint) |
| **Default API Base URL** | `http://<your-ha-host>:20128/v1` |
| **Internal Stack** | Node.js runtime + Redis server |
| **Persistent Data** | Stored under `/data` (keys, JWT secrets, SQLite DB) |
| **Upstream Project** | [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) |
| **Documentation** | [Full Add-on Documentation (DOCS.md)](DOCS.md) |
| **Test Version** | [`omniroute-test/`](../omniroute-test/) |

---

## 🚀 Installation & Setup

1. Add the add-on repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **OmniRoute** and click **Install**.
3. (Optional) In the **Configuration** tab, define an `initial_password` for the admin dashboard.
4. Start the add-on and open the dashboard directly at `http://<your-ha-host>:20128`.
5. Log in and configure your provider API keys under **Dashboard → Providers**.

---

## ⚡ Zero-Config Quickstart

OmniRoute comes pre-configured to work immediately with free-tier providers without requiring any initial API keys:

```bash
curl http://<your-ha-host>:20128/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "auto",
    "messages": [
      {
        "role": "user",
        "content": "Hello! What can you do?"
      }
    ]
  }'
```

---

## 🔌 Connecting Your AI Tools

Point any OpenAI-compatible tool or IDE extension to your Home Assistant OmniRoute endpoint:

- **Base URL**: `http://<your-ha-host>:20128/v1`
- **API Key**: Any dummy string if `require_api_key` is `false`, or your OmniRoute master key if enabled.

### Claude Code / Codex CLI
```bash
omniroute setup-claude
# or
omniroute setup-codex
```

### Cursor / VS Code / Cline
In extension settings, set the API Base URL to:
```text
http://<your-ha-host>:20128/v1
```

---

## ⚙️ Configuration Options

| Option | Type | Default | Description |
| :--- | :---: | :---: | :--- |
| `initial_password` | password | `""` | Initial administrator dashboard password (default: `omniroute`). |
| `require_api_key` | bool | `false` | When true, enforces authentication for all `/v1/*` proxy requests. |
| `auth_cookie_secure` | bool | `false` | Enable Secure flag on session cookies (enable when running behind HTTPS/SSL). |

---

## 🛠️ Support & Community

- **Community Discord**: [OmniRoute Community](https://discord.gg/omniroute)
- **Upstream Wiki & Docs**: [OmniRoute Documentation](https://github.com/diegosouzapw/OmniRoute/wiki)
- **Add-on Issues**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
- **Upstream Repository**: [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute)
