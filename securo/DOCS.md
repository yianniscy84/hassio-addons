Securo is a self-hosted personal finance manager that gives you full visibility into your accounts, spending, and habits — without surrendering your data to third parties.

## Features

- Multi-account management with running balances
- Transaction management with search, filters, and CSV export
- File import (OFX, QIF, CAMT, CSV)
- Auto-categorization rules engine
- Recurring transactions and budgets
- Goals and savings targets with progress tracking
- Asset management with valuation tracking
- Reports: Net Worth and Income vs Expenses
- Bank sync via Pluggy, Enable Banking, or SimpleFIN
- Multi-currency support with automatic FX conversion
- Two-factor authentication (TOTP) and passkeys
- OIDC login support (Authentik, Pocket ID, etc.)
- Multi-user support with admin panel
- Optional AI agents and MCP (Claude Desktop, Cursor, n8n, Home Assistant MCP client)

## Configuration

### Required

| Option | Description |
|---|---|
| `secret_key` | Secret key for session signing. Leave empty to auto-generate. |

### Bank Sync (Optional)

Configure one or more providers to enable automatic bank synchronization:

#### Pluggy (Brazilian banks)
- `pluggy_client_id` — Your Pluggy Client ID
- `pluggy_client_secret` — Your Pluggy Client Secret

#### Enable Banking (European banks, PSD2)
- `enable_banking_app_id` — Your Enable Banking Application ID

#### SimpleFIN (US and international)
- `simplefin_enabled` — Set to `true` to enable SimpleFIN
- `simplefin_api_url` — Defaults to sandbox; use `bridge.simplefin.org` for production

#### Sync Settings
- `bank_sync_min_interval_hours` — Minimum hours between automatic bank sync runs (default: `4`, min: `1`, max: `168`)

### OIDC (Optional)

Delegate login to an external OIDC provider:

| Option | Description |
|---|---|
| `oidc_enabled` | Enable OIDC login |
| `oidc_provider_name` | Display name for the provider |
| `oidc_discovery_url` | `.well-known/openid-configuration` URL |
| `oidc_client_id` | OIDC client ID |
| `oidc_client_secret` | OIDC client secret |

### AI agents and MCP (Optional)

Off by default so the addon stays light. Enable **AI Agents and MCP** (`agents_enabled`) and restart to:

1. Start the built-in MCP server (`uvicorn mcp_server.main:app` on port 8765)
2. Mount the Agents UI, including token minting

MCP is the same feature as [upstream Securo](https://github.com/securo-finance/securo): JSON-RPC 2.0 over HTTP `POST /mcp`, authenticated with a JWT. In-app LLM chat is unused until you add a provider.

#### Options

| Option | Description |
|---|---|
| `agents_enabled` | Master switch for agents + MCP |
| `agents_mcp_jwt_secret` | MCP token signing secret. Leave empty to auto-generate and persist under `/data` |
| `agents_external_mcp_url` | Public MCP URL shown in the UI. If empty, derived from `frontend_url` as `{frontend_url}/mcp` |
| `agents_extra_mcp_servers` | Extra MCP servers: `URL[|name],...` |
| `agents_embedding_provider` | `ollama`, `openai`, or `openai_compatible` (not `native`) |
| `agents_default_provider` | In-app LLM: `openai`, `anthropic`, `ollama`, `openai_compatible` |
| `agents_default_model` | Default model name for in-app agents |
| `agents_openai_api_key` | OpenAI API key |
| `agents_anthropic_api_key` | Anthropic API key |
| `agents_ollama_base_url` | Ollama URL reachable from the addon (e.g. `http://host.docker.internal:11434`) |
| `agents_openai_compat_base_url` | OpenAI-compatible API base URL |
| `agents_openai_compat_api_key` | OpenAI-compatible API key |

Set `frontend_url` to the URL you use for the web UI (e.g. `http://<ha-host>:8080`), so the External MCP panel shows a reachable endpoint.

#### Connect an MCP client

1. Map **port 8765** in the add-on Network settings (or use `/mcp` on direct web port `8080`).
2. Open Securo (`http://<ha-host>:8080` or via **Open Web UI**), go to **Agents → Connections → External MCP access**, and generate a token. Copy it now — it is not stored.
3. Point the client at one of:
   - `http://<ha-host>:8765/mcp`
   - `http://<ha-host>:8080/mcp`
4. Send `Authorization: Bearer <token>` on every request.

Example `tools/list` check:

```bash
curl -X POST http://<ha-host>:8765/mcp \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

Claude Desktop / Cursor snippet (paste into MCP config after minting a token):

```json
{
  "mcpServers": {
    "securo": {
      "url": "http://<ha-host>:8765/mcp",
      "headers": { "Authorization": "Bearer <token>" }
    }
  }
}
```

#### Embeddings (knowledge base)

Native/fastembed embeddings are **not available** on this Alpine image (`onnxruntime` has no musl wheel). For agent knowledge-base RAG, set `agents_embedding_provider` to `ollama`, `openai`, or `openai_compatible`.

## Accessing the App

After installation, Securo is available:

- On **port 8080** (default mapped port) of your Home Assistant host: `http://<ha-host>:8080/`
- Via the **Open Web UI** button on the add-on info card
- On **port 8765** when agents are enabled (MCP JSON-RPC; JWT required)

Create your first account by opening the app and registering.

## Support

- [Documentation](https://docs.usesecuro.com/)
- [GitHub Issues](https://github.com/securo-finance/securo/issues)
- [Discord](https://discord.gg/rUqTKtQ9S4)
