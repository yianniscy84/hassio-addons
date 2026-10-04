# Home Assistant Add-on: Securo

<p align="center">
  <img src="icon.png" alt="Securo Logo" width="120">
</p>

<p align="center">
  <strong>Self-hosted personal finance management platform for Home Assistant.</strong><br>
  Track multi-currency accounts, automate bank synchronization, manage budgets, and query your finances via MCP.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fconfig.yaml&color=brightgreen&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Upstream&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fupdater.json&color=blue&style=flat-square" alt="Upstream Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fupdater.json&color=lightgrey&style=flat-square" alt="Last Update">
  <img src="https://img.shields.io/badge/Ingress-Supported-blueviolet.svg?style=flat-square" alt="Ingress Supported">
  <img src="https://img.shields.io/badge/Stage-Stable-brightgreen.svg?style=flat-square" alt="Stage Stable">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm" alt="aarch64">
  <img src="https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd" alt="amd64">
  <img src="https://img.shields.io/badge/armhf-green.svg?style=flat-square&logo=arm" alt="armhf">
  <img src="https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm" alt="armv7">
  <img src="https://img.shields.io/badge/i386-green.svg?style=flat-square&logo=intel" alt="i386">
</p>

---

## 🌟 Key Features

- **Account & Portfolio Tracking**: Manage checking, savings, investments, and liabilities with running balances.
- **Transaction Management**: Search, categorization, splits, tagging, and CSV/OFX/QIF/CAMT imports.
- **Automated Bank Synchronization**: Live sync support via SimpleFIN (US/International), Enable Banking (Europe/PSD2), and Pluggy (Brazil).
- **Budgets & Goals**: Set category spending budgets, track financial targets, and visualize net worth evolution over time.
- **Model Context Protocol (MCP)**: Query transactions, balances, and budgets from AI tools (Claude Desktop, Cursor, Home Assistant AI agents).
- **Security & Authentication**: TOTP two-factor authentication, passkeys, and OIDC Single Sign-On (Authentik, Authelia, Pocket ID).

---

## 📊 Technical Specifications

| Parameter | Specification |
| :--- | :--- |
| **Ingress Support** | Yes (available in Home Assistant sidebar) |
| **Web UI Port** | Container `80` → Host `8080` |
| **MCP Server Port** | Container `8765` → Host `8765` (Active when `agents_enabled` is `true`) |
| **Database** | Embedded PostgreSQL 16 with `pgvector` & `pgcrypto` (`/data/postgres`) |
| **Cache & Worker** | Ephemeral Redis cache + background Celery worker |
| **Upstream Project** | [securo-finance/securo](https://github.com/securo-finance/securo) |
| **Documentation** | [Full Add-on Documentation (DOCS.md)](DOCS.md) |

---

## 🚀 Installation & Setup

1. Add the add-on repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **Securo** and click **Install**.
3. Once installed, review the **Configuration** tab (optionally configure bank sync, OIDC, or MCP).
4. Start the add-on and open it via the **Home Assistant sidebar** (Ingress) or directly at `http://<your-ha-host>:8080`.
5. Register your administrator user on first launch.

---

## ⚙️ Configuration Highlights

| Option | Type | Default | Description |
| :--- | :---: | :---: | :--- |
| `secret_key` | string | `""` | Session signing secret key (auto-generated if empty). |
| `frontend_url` | string | `""` | Public URL for direct web access / MCP endpoint resolution. |
| `agents_enabled` | bool | `false` | Enable the built-in AI agents subsystem and MCP server on port `8765`. |
| `agents_embedding_provider` | string | `"ollama"` | Vector embeddings provider (`ollama`, `openai`, or `openai_compatible`). |
| `simplefin_enabled` | bool | `false` | Enable SimpleFIN bank synchronization. |
| `oidc_enabled` | bool | `false` | Enable Single Sign-On delegation to an external OIDC provider. |

> For the comprehensive list of configuration options, please refer to the [DOCS.md](DOCS.md) file.

---

## 🤖 Model Context Protocol (MCP) Integration

When `agents_enabled: true` is set, Securo exposes a standard JSON-RPC MCP server on port `8765`:

1. Map port `8765` in the add-on's **Network** settings.
2. In the Securo web interface, navigate to **Agents → Connections → External MCP access** to generate an access token.
3. Configure your MCP client (e.g. Claude Desktop or Cursor):

```json
{
  "mcpServers": {
    "securo": {
      "url": "http://<your-ha-ip>:8765/mcp",
      "headers": {
        "Authorization": "Bearer <YOUR_GENERATED_TOKEN>"
      }
    }
  }
}
```

> **Note**: Do not use the Home Assistant ingress URL for external MCP clients. Use the direct host port `8765`.

---

## 🛠️ Support & Upstream Credits

- **Issues & Bug Reports**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
- **Securo Upstream Documentation**: [https://docs.usesecuro.com/](https://docs.usesecuro.com/)
- **Upstream Repository**: [securo-finance/securo](https://github.com/securo-finance/securo)
