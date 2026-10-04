# Changelog

## 0.32.0

- Sync with upstream Securo v0.16.3 (includes v0.16.2 and v0.16.3)
- New: Recurring invoices — an agreement that emits one invoice per period, with dated price terms
- New: Invoice instalments ("3x", "half upfront / half on delivery") as rows that settle in order
- New: Invoice deductions — debt closed by withholding or a fee, without money arriving
- New: Invoice product and service catalog with per-item pricing
- New: Per-workspace timezone
- New: Rename a bank-synced transaction from the edit dialog, with the bank's text kept underneath and a Restore original link
- New: Kazakhstani tenge (`KZT`)
- Fix: Default categories and groups can be deleted, relocating entries still in use
- Fix: A refund now counts against its category's budget instead of being ignored
- Fix: OFX import tolerates a non-standard encoding header in the SGML preamble
- Fix: OFX import keeps every row when a bank reuses one FITID (key now includes amount and type)
- Fix: CSV import infers the thousands separator per column instead of treating a lone comma as a decimal point
- Fix: Enable Banking names a transaction after the counterparty when the bank sends no description, and keeps transactions carrying only a transaction date
- Fix: Enable Banking reauthorisation no longer duplicates accounts — matches on the bank's own `identification_hash` (`accounts.stable_id`, migration `097`), with a masked-identifier fallback for rows predating the column
- Fix: Enable Banking surfaces a bank-side `ASPSP_ERROR` as needing retry instead of reporting a successful empty sync
- Fix: Enable Banking requests the longest window the bank serves (`strategy="longest"`), configurable via `enable_banking_history_days` (default 999), still falling back to 30 days on `WRONG_TRANSACTIONS_PERIOD`
- Fix: Transaction fingerprints no longer include the session-scoped account UID, so a reconnect cannot re-import an account's whole history as new transactions
- Fix: A lapsed connection is adopted on reconnect instead of leaving a second row for the same bank (only when exactly one stale connection matches, never an active one)
- Fix: Legacy duplicate accounts created by add-on 0.31.1/0.31.2 are consolidated onto one account on the next sync
- Fix: Dashboard and sidebar agree on account balances and ordering
- Fix: Per-account institution hint for brokerage accounts grouped under a banking connection
- Fix: Shared credit line counted once in the net worth tooltip
- Fix: Editing a tracked holding no longer wipes its cost basis
- Fix: Import history totals shown in the statement currency, not the workspace currency
- Fix: "% of portfolio" populated for holdings in your own currency
- Fix: A user with reconciliation history can be deleted
- Fix: Agent chat with current Claude models (the unsupported `temperature` is no longer sent)
- Fix: CSV import handles any currency symbol, not just `R$`, and matches the type column case-insensitively
- Fix: Balance chart renamed to Balance Evolution to match what it plots
- Fix: Connection status badges and labels translated across all locales
- Database: Automatic migrations `092`–`097` for invoice schedules, catalog, instalments, workspace timezone, reconciliation FK delete actions, and `accounts.stable_id`
- Chore: Update `uv` lockfile and backend dependencies for upstream v0.16.3

## 0.31.2

- Sync with upstream Securo v0.16.1
- New: Custom date range picker for report analysis (Net Worth, Income & Expenses)
- New: Transfer matching rules tab directly on the Rules page
- New: Four new currencies: Serbian Dinar (`RSD`), Jamaican Dollar (`JMD`), Saudi Riyal (`SAR`), Qatari Riyal (`QAR`)
- New: Collapsible desktop sidebar for wider workspace views
- Fix: Harden bank connection sync correctness and duplicate prevention across providers
- Fix: Persist manual transaction external IDs across edits
- Fix: Return newest messages when agent conversation history window is exceeded
- Fix: Allow receipt attachments upload over plain HTTP
- Fix: Strip marker characters (`*`, `#`) from CSV template headers for auto-detection
- Fix: Deduplicate Pluggy shared credit balance calculations
- Fix: Shape `get_account_summary` MCP tool payload consistently with other tools
- Database: Automatic migrations `090` (account shared balance group) and `091` (suggestion transaction kind)
- Chore: Update Python and dependency lockfile (`uv` 0.12.17)

## 0.31.1

- Fix: Prevent duplicate bank accounts on Enable Banking reauthorization by matching existing accounts on masked number and currency when ephemeral session UIDs rotate
- Fix: Prevent duplicate bank connections by automatically adopting existing disconnected/expired connections matching the institution name on OAuth reconnect
- Fix: Stable transaction fingerprints across Enable Banking reauth sessions by excluding ephemeral session account UIDs from hash calculation
- Fix: Expand initial Enable Banking transaction sync history to 999 days using `strategy="longest"` (configurable via `enable_banking_history_days`)
- Fix: Automatic self-healing consolidation of legacy duplicate accounts and transactions under a connection, preserving the original account UUID and custom display names
- New: Add `enable_banking_history_days` configuration option in add-on options (default: 999)

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
