# Upstream Tracker

This file tracks upstream versions for each addon.

## Version Matrix

### Securo (securo-finance/securo)

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `securo/` (production) | v0.16.0 | 0.31.1 | 2026-09-17 |
| `securo-test/` (test) | v0.16.0 | 0.31.1 | 2026-09-17 |

The production and test addons track different upstream versions. Test gets updates first; production is synced after testing.

### OmniRoute (diegosouzapw/OmniRoute)

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `omniroute/` (production) | v3.8.50 | 0.3.6 | 2026-08-30 |
| `omniroute-test/` (test) | v3.8.50 | 0.3.6 | 2026-08-30 |

Both addons clone from upstream Git tags. Bump `OMNIROUTE_VERSION` in the Dockerfile to update.

## Active Patches & Upstream PRs

### Securo

| Patch File | Upstream PR / Fork Branch | Target Files | Status |
|---|---|---|---|
| [`patches/securo/0001-enable-banking-duplicate-reconnect.patch`](patches/securo/0001-enable-banking-duplicate-reconnect.patch) | [`yianniscy84/securo:fix/enable-banking-duplicate-reconnect`](https://github.com/yianniscy84/securo/tree/fix/enable-banking-duplicate-reconnect) | `backend/app/services/connection_service.py`<br>`backend/app/providers/enable_banking.py`<br>`backend/app/core/config.py` | Active (pending upstream merge) |

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
