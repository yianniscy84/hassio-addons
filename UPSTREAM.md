# Upstream Tracker

This file tracks upstream versions for each addon.

## Version Matrix

### Securo (securo-finance/securo)

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `securo/` | v0.16.3 | 0.32.0 | 2026-10-04 |

The Securo test add-on (`securo-test/`) was removed on 2026-10-04; `securo/` is now the only tracked Securo add-on and is validated directly via `docker build` + smoke test before release.

### OmniRoute (diegosouzapw/OmniRoute)

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `omniroute/` (production) | v3.8.50 | 0.3.6 | 2026-08-30 |
| `omniroute-test/` (test) | v3.8.50 | 0.3.6 | 2026-08-30 |

Both addons clone from upstream Git tags. Bump `OMNIROUTE_VERSION` in the Dockerfile to update.

### Memos (usememos/memos)

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `memos/` | v0.31.0 | 0.31.0 | 2026-10-06 |

The memos add-on wraps the pre-built `neosmemo/memos` image. Bump `BUILD_FROM` in the Dockerfile (and `version` in `config.yaml`) to update.

## Active Patches & Upstream PRs

### Securo

| Patch File | Upstream PR / Fork Branch | Target Files | Status |
|---|---|---|---|
| [`patches/securo/0002-enable-banking-connection-fingerprint-history.patch`](patches/securo/0002-enable-banking-connection-fingerprint-history.patch) | add-on only (no upstream PR) | `backend/app/core/config.py`<br>`backend/app/providers/enable_banking.py`<br>`backend/app/services/connection_service.py`<br>`backend/tests/test_connection_service.py`<br>`backend/tests/test_providers_enable_banking.py` | Active |

### Superseded by upstream work we adopted early

Upstream's [PR #1074](https://github.com/securo-finance/securo/pull/1074)
("fix(enable-banking): stop silent empty syncs and reauth duplicates") fixes the same
reauthorisation-duplication defect as our retired patch `0001`. It was still **open**
(2026-10-03) at the time of the v0.16.3 sync, so its single commit `53b4269b` was
cherry-picked onto v0.16.3 and is now carried in the add-on source directly:

- `accounts.stable_id` (migration `097`) populated from Enable Banking's
  `identification_hash`, matched on in `_find_existing_connected_account`
- `ProviderDataUnavailable` raised on a bank-side `ASPSP_ERROR` instead of
  reporting a successful empty sync

**Consequence for the next sync:** when #1074 merges, do **not** re-apply anything for
`stable_id` — it will already be in the copied upstream source, and doing so would
double-apply. Patch `0002` should shrink to drop whatever #1074 absorbs. Verify by
diffing `backend/app/models/account.py` for `stable_id` before re-applying.

`0002` retains what #1074 does not cover:

| Fix | Rationale |
|---|---|
| `enable_banking_history_days` (default 999) + `strategy="longest"` | Add-on option; upstream deliberately ships 90 days. The two parts are coupled — dropping `strategy` while keeping 999 would make banks reject the window and fall back to 30 days. |
| `_txn_fingerprint` excludes the session-scoped `account_uid` | #1074 fixes account-level duplication; this fixes transaction-level duplication on re-key. Complementary. |
| Duplicate-connection adoption on OAuth reconnect | #1074 only handles accounts within one connection, not a second `BankConnection` row for the same bank. |
| `_cleanup_legacy_duplicate_accounts` | One-off repair for rows duplicated by add-on 0.31.1/0.31.2. Can be deleted once no installation carries those duplicates. |

When syncing Securo from upstream:
1. Check if the upstream release includes the PR/fix.
2. If included upstream, delete the patch file from `patches/securo/` and remove from this table.
3. If not yet included upstream, apply all active patches after copying upstream code:
   ```bash
   git apply --directory=securo patches/securo/*.patch
   git apply --directory=securo-test patches/securo/*.patch
   ```

## Upstream Repos

- https://github.com/securo-finance/securo
- https://github.com/diegosouzapw/OmniRoute
- https://github.com/usememos/memos

## Sync Notes

### Securo

- Backend and frontend code are copied from upstream, then HAOS-specific modifications are re-applied
- HAOS-modified files (do not overwrite on sync):
  - `*/backend/pyproject.toml` — fastembed excluded (musl incompatibility), ruff/ty pins
  - `*/frontend/src/lib/basename.ts` — ingress base path detection
  - `*/frontend/src/App.tsx` — `<BrowserRouter basename={basename}>`
  - `*/frontend/src/lib/api.ts` — basename in baseURL + login redirect
  - `*/frontend/vite.config.ts` — `base: './'` for relative asset paths
- Active patches from `patches/securo/` must be reapplied if upstream has not yet merged them.
- `uv.lock` must be regenerated after syncing `pyproject.toml` (`uv lock`)
- `frontend/dist/` is NOT committed — built during `docker build`

### OmniRoute

- Source is cloned from upstream during `docker build` (not committed to this repo)
- Both addons use the pre-built `diegosouzapw/omniroute:latest` image as base
- Redis is installed on top via `apt-get` (Debian-based image)
- HAOS-specific files are maintained in this repo:
  - `*/run.sh` — entry script (bashio, Redis, secrets generation)
  - `*/config.yaml` — addon manifest (ports, options, schema)
  - `*/Dockerfile` — extends official image with Redis + bashio stubs

### Memos

- Uses the pre-built `neosmemo/memos` image (pinned tag, not built from source)
- HAOS-specific files maintained in this repo:
  - `memos/run.sh` — entry script (bashio options, `MEMOS_*` exports, Postgres auto `CREATE DATABASE`, re-enters upstream entrypoint for privilege drop)
  - `memos/config.yaml` — addon manifest (port 5230, options, schema)
  - `memos/Dockerfile` — extends official image with bash/python3/psql + bashio stubs
- No ingress: upstream has no base-path support ([usememos/memos#3781](https://github.com/usememos/memos/issues/3781))
- External DB hosts use the internal add-on DNS pattern `{REPO}-{SLUG}` (see `memos/DOCS.md`)
- On update: bump `BUILD_FROM` + `BUILD_VERSION` in `memos/Dockerfile`, `version` in `memos/config.yaml`, and `updater.json`
