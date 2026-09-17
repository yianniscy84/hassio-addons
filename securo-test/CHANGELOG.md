# Changelog

## 0.31.0

- Sync with upstream Securo v0.16.0
- New: Automated payment matching to open invoices with customizable reconciliation threshold rules
- New: Reconciliation review queue with one-click match/decline, history tracking, and cash forecast integration
- New: Rule editor pre-fills conditions and actions directly when adding a transaction to a rule
- New: MCP rule management tools (list, preview, create, update, delete via agent proposals)
- New: Seven new currencies: Chinese Yuan (`CNY`), Malaysian Ringgit (`MYR`), Egyptian Pound (`EGP`), Thai Baht (`THB`), UAE Dirham (`AED`), Moldovan Leu (`MDL`), Pakistani Rupee (`PKR`)
- New: Indian financial year support (April–March fiscal cycle, INR currency formatting, day-first dates)
- Fix: Editing recurring schedule recalculates and moves the next occurrence date
- Fix: Synced credit card installments inherit category from the first installment
- Fix: Credit card bill total calculation preserves charges categorized as transfers
- Fix: Hand-picked date range expansions on cards no longer hide billed charges
- Fix: Payee list pagination, long name truncation, and case-insensitive collation under C-locale Postgres
- Fix: Preselect recognized categories during CSV import preview
- Fix: Thought signature preservation in Gemini/OpenAI-compatible streaming tool responses
- Fix: Removal dialogs for 2FA and passkeys on OIDC-only instances
- Database: Automatic migrations `086` to `089` for reconciliation rules, suggestions, and history
- Chore: Update `uv` to 0.12.15 and refresh dependencies

## 0.30.1

- Sync with upstream Securo v0.15.1
- New: Greek (`el`), Hindi (`hi`), and Japanese (`ja`) UI translations
- New: Passkey conditional UI login enhancement (autofill integration)
- New: Rules filter support
- New: Biweekly and semiannual recurrence frequencies
- New: Report exclusion flag for transactions
- New: External ID support for assets via API
- Fix: Show profit calculations for manual and sold holdings
- Fix: Clarify pending spending and keep projections inside total shown in transaction drill-down
- Fix: CSV import error handling and failed row tracking
- Fix: Rules overriding provider categories during sync
- Fix: Credit card bill totals excluded from reporting filter
- Fix: Client IP derivation from configured trusted-proxy hop
- Chore: Update Python and frontend dependencies (`uv`, `react-is`, `ty`)

## 0.30.0

- Sync with upstream securo v0.15.0
- New: Invoices module (receivables ledger, invoice lifecycle, line items, logo upload, attachments)
- New: Server-side invoice PDF generation via ReportLab
- New: Public shared invoice tokens (`/i/:token`)
- New: Slovak (`sk`) translations
- New: Azerbaijani Manat (`AZN`) and Turkish Lira (`TRY`) currency support
- New: Azerbaijani jurisdiction tax ID and amount formatting validation rules
- Fix: Enable Banking pagination loops and duplicate transaction import prevention
- Fix: Shared bank connection scoping and connection owner assignment
- Fix: Dashboard pending spend inclusion in category widget
- Update: Frontend upgraded to Vite 8 and TypeScript 7

## 0.29.2

- Add `Cache-Control: no-cache, no-store, must-revalidate` to `index.html` in Nginx to prevent browsers from caching stale bundle script hashes across updates

## 0.29.1

- Fix blank screen on OAuth callbacks and nested routes (`/oauth/callback`, `/auth/oidc/callback`, `/accounts/:id`) by mapping nested `/static/` asset requests in Nginx

## 0.29.0

- Sync with upstream securo v0.14.5
- New: OIDC-only local auth toggle (`local_auth_enabled`)
- New: Encrypted workspace backups with password (AES-256 via pyzipper)
- New: Rule preview before saving
- New: Dashboard calendar/list view for period transactions
- New: Investment order import from broker CSV
- New: Nested AND/OR rule condition groups
- New: Dutch (nl) translations
- New: Vietnamese Dong (VND) and Singapore Dollar (SGD) support
- New: Hidable default categories
- Fix: Reject unsafe regex rule patterns
- Fix: Confirm destructive deletions
- Fix: Pluggy savings subtypes mapping
- Fix: SimpleFIN institutions as first-class rows
- Update: React 19, Zod v4, Tailwind v4, Vite 7
- Update: Supply chain hardening for frontend dependencies

## 0.27.1

- Fix blank page on nested routes (e.g. `/agents/connections`) when static assets resolved as `/agents/static/...`

## 0.27.0

- Opt-in AI agents and built-in MCP server (`agents_enabled`)
- Expose MCP on port 8765 and proxy `/mcp` on the web port
- Persist MCP JWT secret under `/data` so minted tokens survive restarts
- Native (fastembed) embeddings remain unavailable on Alpine; use Ollama or OpenAI for RAG
- Document how to enable MCP, mint a token, and connect Claude/HA clients (mapped ports, not ingress)

## 0.26.10

- Fix OIDC login redirect to use basename for ingress compatibility
- Fix agents SSE fetch URL to use absolute path with basename
- Fix chatUrl helper to include basename prefix

## 0.26.9

- Fix axios baseURL to use absolute path with basename for reliable ingress API routing

## 0.26.8

- Fix account detail page crash when `account.type` is empty string

## 0.26.7

- Fix account detail page crash when projected transactions data is not an array

## 0.26.6

- Fix HA ingress path detection to match `/api/hassio_ingress/<token>` pattern
- Fix account detail page crash when `account.type` is undefined

## 0.26.4

- Fix 401 redirect loop under ingress (was redirecting to `/login` without prefix)
- Fix hardcoded absolute paths in OIDC callback, login handler, agents link, and SSE client
- Extract shared basename utility for consistent ingress path detection

## 0.26.3

- Detect Home Assistant ingress base path dynamically for React Router
- Fix hardcoded absolute API path in agents stream
- Fix favicon paths in index.html

## 0.26.1

- Enable image-based auto-updates via GHCR

## 0.26.0

- Initial HA addon release
- All-in-one: PostgreSQL, Redis, backend, frontend, Celery
- Ingress support
- Bank sync via Pluggy, Enable Banking, SimpleFIN
- OIDC support
