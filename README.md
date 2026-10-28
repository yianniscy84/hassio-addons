# Home Assistant Add-ons by yianniscy84

<p align="center">
  <img src="https://www.openhomefoundation.org/badges/home-assistant.png" alt="Home Assistant" width="140">
</p>

<p align="center">
  <strong>Curated, high-performance Home Assistant OS add-ons for your smart home.</strong><br>
  Carefully packaged, independently maintained, and updated with upstream releases.
</p>

<p align="center">
  <a href="https://github.com/yianniscy84/hassio-addons">
    <img src="https://img.shields.io/github/last-commit/yianniscy84/hassio-addons?label=Last%20Update&logo=github&style=flat-square" alt="Last update">
  </a>
  <a href="https://github.com/yianniscy84/hassio-addons/stargazers">
    <img src="https://img.shields.io/github/stars/yianniscy84/hassio-addons?label=Stars&logo=github&style=flat-square" alt="GitHub stars">
  </a>
  <a href="https://github.com/yianniscy84/hassio-addons/issues">
    <img src="https://img.shields.io/github/issues/yianniscy84/hassio-addons?label=Issues&logo=github&style=flat-square" alt="Open issues">
  </a>
  <a href="LICENSE.md">
    <img src="https://img.shields.io/badge/License-MIT-green.svg?style=flat-square" alt="MIT License">
  </a>
</p>

---

## 📦 Add-on Catalog

| Add-on | Status | Version | Host Port(s) | Supported Architectures | Description |
| :--- | :---: | :---: | :---: | :--- | :--- |
| [**Securo**](securo/) | Stable | ![Securo Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fconfig.yaml&color=brightgreen&style=flat-square) | `8080` (Web)<br>`8765` (MCP) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) ![armhf](https://img.shields.io/badge/armhf-green.svg?style=flat-square&logo=arm) ![armv7](https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm) ![i386](https://img.shields.io/badge/i386-green.svg?style=flat-square&logo=intel) | Self-hosted personal finance manager with multi-account tracking, bank sync, and MCP. |
| [**OmniRoute**](omniroute/) | Stable | ![OmniRoute Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fconfig.yaml&color=brightgreen&style=flat-square) | `20128` (API/UI) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) ![armv7](https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm) | AI gateway routing 350+ providers & 1200+ models via one OpenAI-compatible endpoint. |
| [**Memos**](memos/) | Stable | ![Memos Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fmemos%2Fconfig.yaml&color=brightgreen&style=flat-square) | `5230` (Web/API) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) ![armv7](https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm) | Self-hosted note-taking with tags, relations, attachments, and full-text search. |
| [**Blinko**](blinko/) | Stable | ![Blinko Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fblinko%2Fconfig.yaml&color=brightgreen&style=flat-square) | `1111` (Web/API) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) | AI-powered card note-taking with Markdown, tags, plugins, and bundled PostgreSQL. |
| [**FreeLLMAPI**](freellmapi/) | Stable | ![FreeLLMAPI Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Ffreellmapi%2Fconfig.yaml&color=brightgreen&style=flat-square) | `3001` (API/UI) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) | OpenAI-compatible proxy and routing layer aggregating dozens of free LLM providers with smart fallbacks. |
| [**Shoutrrr**](shoutrrr/) | Stable | ![Shoutrrr Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fshoutrrr%2Fconfig.yaml&color=brightgreen&style=flat-square) | `8080` (Web/API/MCP) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) | Self-hosted social media scheduler for X, Bluesky, LinkedIn, Facebook, Instagram, Threads and Discord. |
| [**Postiz**](postiz/) | Stable | ![Postiz Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fpostiz%2Fconfig.yaml&color=brightgreen&style=flat-square) | `5000` (Web/API/Uploads) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) | Open-source social media scheduling, analytics, and automation platform with AI agents and MCP. |

---

## 🚀 Installation

### One-Click Installation

Click the button below to add this repository directly to your Home Assistant instance:

<p align="center">
  <a href="https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/yianniscy84/hassio-addons">
    <img src="https://img.shields.io/badge/Add%20Repository-Home%20Assistant-41BDF5?style=for-the-badge&logo=home-assistant&logoColor=white" alt="Add repository to Home Assistant">
  </a>
</p>

### Manual Installation

1. In Home Assistant, navigate to **Settings → Add-ons → Add-on Store**.
2. Click the **⋮** menu in the top right corner and select **Repositories**.
3. Enter the repository URL:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
4. Click **Add**, then close the dialog.
5. The add-ons will appear in the Add-on Store under **Home Assistant Apps by yianniscy84**.

---

## 🔍 Add-on Overview

### [Securo](securo/)

<p align="center">
  <img src="securo/icon.png" alt="Securo Logo" width="90">
</p>

**Securo** is a comprehensive, privacy-first personal finance platform providing deep insight into your accounts, transactions, and budgets without exposing data to third parties.

- **Multi-Account & Balances**: Track checking, savings, investment, and liability accounts in one unified dashboard.
- **Automated Bank Sync**: Integrations for SimpleFIN, Enable Banking (PSD2), and Pluggy.
- **Rule Engine & Categorization**: Automated categorization and recurring transaction management.
- **Model Context Protocol (MCP)**: Built-in JSON-RPC MCP server (`/mcp` or port `8765`) to query financial data directly from Claude Desktop, Cursor, n8n, or Home Assistant agents.
- **Multi-Factor Auth & OIDC**: Full support for TOTP, passkeys, and external OpenID Connect identity providers (Authentik, Authelia, Pocket ID).

> Upstream project: [securo-finance/securo](https://github.com/securo-finance/securo) | [Documentation](securo/DOCS.md)

---

### [OmniRoute](omniroute/)

<p align="center">
  <img src="omniroute/icon.png" alt="OmniRoute Logo" width="90">
</p>

**OmniRoute** is a universal, high-performance AI gateway that consolidates 350+ LLM providers and 1200+ models into a single, standardized OpenAI-compatible endpoint.

- **One Universal Endpoint**: Drop-in replacement for OpenAI API (`/v1/chat/completions`) compatible with any AI client.
- **Smart Fallback & Routing**: 19 routing strategies including priority, cost optimization, weighted load balancing, and automated failover.
- **Prompt Compression**: Built-in RTK and Caveman token compression saving between 15% and 95% of prompt tokens.
- **Zero-Config Out-of-the-Box**: Immediate access to over 90 free-tier providers without mandatory upfront API keys.
- **Agent Protocols**: Built-in MCP (Model Context Protocol) and Agent-to-Agent (A2A) tool chaining.

> Upstream project: [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) | [Documentation](omniroute/DOCS.md)

---

### [Memos](memos/)

<p align="center">
  <img src="memos/icon.png" alt="Memos Logo" width="90">
</p>

**Memos** is a self-hosted note-taking and memo service — write Markdown notes from any device, organize them with tags and relations, attach files, and search everything instantly, all stored on your own system.

- **Markdown Notes**: Fast, clean web UI for quick capture on phone or desktop.
- **Organization**: Tags, pinning, memo relations, per-memo visibility, and full-text search.
- **Attachments**: Images and files stored locally under `/data`.
- **Flexible Storage**: SQLite out of the box, or an external PostgreSQL/MySQL server (works with the Postgres 17 add-on).

> Upstream project: [usememos/memos](https://github.com/usememos/memos) | [Documentation](memos/DOCS.md)

---

### [Blinko](blinko/)

<p align="center">
  <img src="blinko/icon.png" alt="Blinko Logo" width="90">
</p>

**Blinko** is an AI-powered card note-taking app — capture fleeting thoughts in Markdown the moment they strike, organize them with tags, and find them again with AI-enhanced natural-language search.

- **Instant Capture**: Card notes with full Markdown support from any device.
- **AI Retrieval**: RAG-enhanced natural-language search across all of your notes.
- **Organize**: Tags, follows, comments, sharing, trash, and note history.
- **Works Out of the Box**: Bundled PostgreSQL in `/data` — or point it at your existing PostgreSQL server.

> Upstream project: [blinkospace/blinko](https://github.com/blinkospace/blinko) | [Documentation](blinko/DOCS.md)

---

### [FreeLLMAPI](freellmapi/)

<p align="center">
  <img src="freellmapi/icon.png" alt="FreeLLMAPI Logo" width="90">
</p>

**FreeLLMAPI** is an open-source, OpenAI-compatible proxy and routing layer that aggregates free LLM provider tiers and hundreds of model endpoints under a single `/v1` endpoint.

- **Unified Inference Endpoint**: `/v1/chat/completions`, Anthropic `/v1/messages`, Gemini `/v1beta`, and Ollama emulation behind one endpoint.
- **Intelligent Failover**: Auto-switches between 34+ free provider tiers upon rate limits (429) or upstream downtime.
- **ChatGPT-Ready MCP Server**: Access inference and provider metrics directly via `/mcp`.
- **Encrypted Keys**: AES-256-GCM encrypted key storage in SQLite with automated key lifecycle.
- **Admin Dashboard**: Manage provider keys, customize fallback chains, and monitor token usage analytics.

> Upstream project: [tashfeenahmed/freellmapi](https://github.com/tashfeenahmed/freellmapi) | [Documentation](freellmapi/DOCS.md)

---

### [Shoutrrr](shoutrrr/)

<p align="center">
  <img src="shoutrrr/icon.png" alt="Shoutrrr Logo" width="90">
</p>

**Shoutrrr** is a self-hosted social media scheduler — write a post once and publish it to every network, or queue it to go out on a recurring schedule, all from one calendar.

- **Multi-platform Publishing**: X, Bluesky, LinkedIn, Facebook Pages, Instagram, Threads and Discord from a single composer.
- **Queue & Calendar**: Recurring posting slots in your workspace timezone plus a month view of scheduled content.
- **Analytics & Engagement**: Follower/post trends, per-post metrics, and a replies inbox where the platform API supports it.
- **Workspaces & Team**: Multiple workspaces, roles, email invitations, and instance-level settings.
- **API + MCP**: Passport bearer tokens, a REST API, and a Model Context Protocol server at `/mcp`.

> Upstream project: [coollabsio/shoutrrr](https://github.com/coollabsio/shoutrrr) | [Documentation](shoutrrr/DOCS.md)

---

### [Postiz](postiz/)

<p align="center">
  <img src="postiz/icon.png" alt="Postiz Logo" width="90">
</p>

**Postiz** is an open-source, AI-powered social media scheduling and analytics platform designed as a self-hosted alternative to Buffer and Hootsuite.

- **Universal Channel Scheduling**: Manage, schedule, and automate posts for X (Twitter), LinkedIn, YouTube, Instagram, Facebook, TikTok, Threads, Pinterest, Reddit, Bluesky, Mastodon, and Discord.
- **Embedded Architecture**: Zero-config bundled PostgreSQL and Redis instances running directly inside the container.
- **AI-Powered Workflows**: Generate, adapt, and rewrite social posts with OpenAI integration.
- **Model Context Protocol (MCP)**: Native MCP connector enabling Claude, Cursor, and Home Assistant AI agents to automate social media campaigns.
- **Full Data Ownership**: Database, media uploads, and secrets persist in `/data` and are backed up via Home Assistant snapshots.

> Upstream project: [gitroomhq/postiz-app](https://github.com/gitroomhq/postiz-app) | [Documentation](postiz/DOCS.md)

---


## 🛠️ Support & Troubleshooting

If you encounter issues or have suggestions:

1. **Check Documentation**: Review the add-on specific `DOCS.md` ([Securo Docs](securo/DOCS.md) / [OmniRoute Docs](omniroute/DOCS.md) / [Memos Docs](memos/DOCS.md) / [Blinko Docs](blinko/DOCS.md) / [FreeLLMAPI Docs](freellmapi/DOCS.md) / [Shoutrrr Docs](shoutrrr/DOCS.md) / [Postiz Docs](postiz/DOCS.md)).
2. **Review Add-on Logs**: Open the add-on in Home Assistant and check the **Log** tab for error traces.
3. **Open an Issue**: Submit a report on [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues). Please include:
   - Home Assistant OS / Core version
   - Add-on version and architecture
   - Relevant log snippets (redacting any private tokens or passwords)

---

## ☕ Support the Project

If these add-ons improve your smart home experience, consider supporting ongoing maintenance:

| Method | Link |
| :--- | :--- |
| ⭐ **Star the Repository** | [![Star](https://img.shields.io/github/stars/yianniscy84/hassio-addons?style=social)](https://github.com/yianniscy84/hassio-addons/stargazers) |
| ☕ **Buy Me a Coffee** | [![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20a%20Coffee-FFDD00?style=flat-square&logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/yianniscy84) |
| 🍵 **Ko-fi** | [![Ko-fi](https://img.shields.io/badge/Donate-Ko--fi-FF5E5B?style=flat-square&logo=kofi&logoColor=white)](https://ko-fi.com/yianniscy84) |
| 🅿️ **PayPal** | [![PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=flat-square&logo=paypal&logoColor=white)](https://www.paypal.me/ioannisioannou) |

---

## 📄 License & Disclaimer

- Distributed under the [MIT License](LICENSE.md).
- Upstream projects retain their respective open-source licenses.
- These add-ons are community-maintained and provided as-is. Always ensure you maintain recent backups in Home Assistant before performing major add-on updates.