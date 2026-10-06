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

| Add-on | Status | Version | Ingress | Host Port(s) | Supported Architectures | Description |
| :--- | :---: | :---: | :---: | :---: | :--- | :--- |
| [**Securo**](securo/) | Stable | ![Securo Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fconfig.yaml&color=brightgreen&style=flat-square) | ✅ Yes | `8080` (Web)<br>`8765` (MCP) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) ![armhf](https://img.shields.io/badge/armhf-green.svg?style=flat-square&logo=arm) ![armv7](https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm) ![i386](https://img.shields.io/badge/i386-green.svg?style=flat-square&logo=intel) | Self-hosted personal finance manager with multi-account tracking, bank sync, and MCP. |
| [**OmniRoute**](omniroute/) | Stable | ![OmniRoute Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fconfig.yaml&color=brightgreen&style=flat-square) | ❌ No | `20128` (API/UI) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) ![armv7](https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm) | AI gateway routing 350+ providers & 1200+ models via one OpenAI-compatible endpoint. |
| [**OmniRoute Test**](omniroute-test/) | Test | ![OmniRoute Test Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute-test%2Fconfig.yaml&color=orange&style=flat-square) | ❌ No | `20129` (API/UI) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) ![armv7](https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm) | Pre-release test instance of OmniRoute on direct port `20129`. |
| [**Memos**](memos/) | Stable | ![Memos Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fmemos%2Fconfig.yaml&color=brightgreen&style=flat-square) | ❌ No | `5230` (Web/API) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) ![armv7](https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm) | Self-hosted note-taking with tags, relations, attachments, and full-text search. |
| [**Blinko**](blinko/) | Stable | ![Blinko Version](https://img.shields.io/badge/dynamic/yaml?label=&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fblinko%2Fconfig.yaml&color=brightgreen&style=flat-square) | ❌ No | `1111` (Web/API) | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd) | AI-powered card note-taking with Markdown, tags, plugins, and bundled PostgreSQL. |

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

> Upstream project: [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) | [Documentation](omniroute/DOCS.md) | [Test Version](omniroute-test/)

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

## 🧪 Production vs. Test Add-ons

OmniRoute ships a dedicated `omniroute-test` variant alongside its stable release:

- **Isolated Storage**: The test add-on uses an isolated `/data` partition so your production database and secrets remain untouched.
- **Separate Network Ports**: The test container binds to an alternate port (`20129`) to allow concurrent execution alongside the stable add-on.
- **Release Preview**: The test add-on receives early upstream feature builds before they land in the stable release.

Securo has no test variant — `securo/` is the only add-on and is validated with a local `docker build` plus smoke test before each release.

---

## 🛠️ Support & Troubleshooting

If you encounter issues or have suggestions:

1. **Check Documentation**: Review the add-on specific `DOCS.md` ([Securo Docs](securo/DOCS.md) / [OmniRoute Docs](omniroute/DOCS.md) / [Memos Docs](memos/DOCS.md) / [Blinko Docs](blinko/DOCS.md)).
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