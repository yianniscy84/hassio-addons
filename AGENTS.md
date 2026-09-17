# Home Assistant OS Addons (`hassio-addons`)

Multi-addon repository providing Home Assistant OS (HAOS) add-ons. HAOS builds add-ons directly from source upon version bumps detected in `config.yaml`.

Repository URL: `https://github.com/yianniscy84/hassio-addons`

---

## Add-on Catalog

| Addon Directory | Type | Slug | Upstream Project | Web / Ingress | MCP Port | Direct Port | Base Stack |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [`securo/`](securo/) | Production | `securo` | `securo-finance/securo` | Port 80 / Ingress | 8765 | 8080 | Python 3.12 (FastAPI), React, PG 16, Redis, Celery, Alpine |
| [`securo-test/`](securo-test/) | Test | `securo-test` | `securo-finance/securo` | Port 81 / Ingress | 8766 | 8081 | Same as securo |
| [`omniroute/`](omniroute/) | Production | `omniroute` | `diegosouzapw/OmniRoute` | No Ingress | — | 20128 | Node.js (upstream image), Redis, Debian (direct access) |
| [`omniroute-test/`](omniroute-test/) | Test | `omniroute-test` | `diegosouzapw/OmniRoute` | No Ingress | — | 20129 | Node.js (upstream image), Redis, Debian (direct access) |

---

## Essential Commands

> **Important:** Run Docker commands from within the specific target add-on directory. Dockerfile build context is the add-on folder (e.g. `cd securo && docker build ...`).

### Local Smoke Tests

```bash
# Securo (from securo/ or securo-test/)
cd securo
docker build -t securo-addon .
docker run -d --name securo-test -p 8080:80 -p 8765:8765 -v securo-data:/data securo-addon
# Access UI: http://localhost:8080 | MCP: http://localhost:8765/mcp

# OmniRoute (from omniroute/ or omniroute-test/)
cd omniroute
docker build -t omniroute-addon .
docker run -d --name omniroute-test -p 20128:20128 -v omniroute-data:/data omniroute-addon
# Access UI & API: http://localhost:20128
```

---

## Architecture & Add-on Quirks

### Securo (Python 3.12 / Alpine)
- **Dependency Management:** No `requirements.txt`. Lockfile is `backend/uv.lock` generated via `uv export --frozen --no-emit-project`.
- **Alpine / Musl Constraints:** Packages require musllinux wheels. `onnxruntime` (`fastembed`) lacks musl wheels and is excluded from `backend/pyproject.toml`. Default embeddings use `ollama` or OpenAI compatibility.
- **Nginx Static Asset Routing:** `nginx.conf` maps `^/(?:.+/)?static/(.+)$` to `/var/www/securo/static/$1` so nested routes (e.g., `/oauth/callback`, `/auth/oidc/callback`, `/accounts/:id`) resolve Vite's relative asset paths properly under direct domains and HA Ingress.
- **Database & Extensions:** PostgreSQL 16 at `/data/postgres`. Requires `postgresql16-contrib` (`pgcrypto`) and compiled `pgvector`. Migrations run via `alembic upgrade head` on startup in `run.sh`.
- **Background Tasks:** Redis is ephemeral cache/broker. Celery runs as background worker/beat inside the container.
- **Configuration & Bashio:** Options are parsed from `/data/options.json` via `bashio`. Shebang must remain `#!/usr/bin/with-contenv bashio`.

### OmniRoute (Node.js / Debian)
- **Upstream Base Image:** Extends `diegosouzapw/omniroute:latest`. No source build.
- **Runtime Stack:** Adds `redis-server`, `curl`, `tzdata`, `python3`.
- **Entrypoint (`run.sh`):** Boots Redis → OmniRoute (`node dev/run-standalone.mjs`). Both `omniroute` (port 20128) and `omniroute-test` (port 20129) run standalone without Nginx/Ingress.
- **Persistent Secrets:** Stored at `/data/jwt_secret` and `/data/api_key_secret`.

---

## Upstream Synchronization

See [`UPSTREAM.md`](UPSTREAM.md) for version matrix and sync tracking.

### Securo Sync Checklist
1. Copy updated `backend/` and `frontend/` from upstream repository.
2. **Preserve HAOS-specific files:**
   - `backend/pyproject.toml` (fastembed exclusion & pinned dependencies)
   - `frontend/src/lib/basename.ts` (dynamic ingress base path detection)
   - `frontend/src/App.tsx` (`<BrowserRouter basename={basename}>`)
   - `frontend/src/lib/api.ts` (`basename` in `baseURL` + login redirect)
   - `frontend/vite.config.ts` (`base: './'`)
3. **Re-apply active patches (see [`UPSTREAM.md`](UPSTREAM.md)):**
   - Check if upstream merged the PR in the new release.
   - If not yet merged upstream, re-apply active patches:
     `git apply --directory=securo patches/securo/*.patch`
     `git apply --directory=securo-test patches/securo/*.patch`
   - If merged upstream, remove obsolete patch file from `patches/securo/` and update `UPSTREAM.md`.
4. Regenerate lockfile if backend dependencies changed: `cd backend && uv lock`.
5. Update `UPSTREAM.md` with new upstream version and sync timestamp.

---

## Release Procedure (All Add-ons)

1. Bump `version` in `<addon>/config.yaml` (e.g., `version: "0.29.1"`).
2. **Add release notes in `<addon>/CHANGELOG.md`** under `## X.Y.Z`.
3. Update version in `UPSTREAM.md` and `<addon>/updater.json` if applicable.
4. Commit and push to `origin/main`. HAOS automatically detects the version bump and prompts users to update.

---

## Troubleshooting Guide

| Issue | Cause | Fix |
| :--- | :--- | :--- |
| `hash mismatch` during `pip install` | Outdated `uv.lock` | Run `cd <addon>/backend && uv lock` and commit both files. |
| Blank screen on deep links / OAuth callback | Nested relative asset resolution | Ensure `nginx.conf` contains the static alias route `location ~* ^/(?:.+/)?static/(.+)$`. |
| Cloudflare Error 524 on OAuth callback | Reverse proxy routing to wrong host port | Direct domains must route to Securo's host port (`8080`), not HA port `8123`. |
| `onnxruntime` build failure | No musl wheel on Alpine | Keep `fastembed` excluded from `pyproject.toml`. |
| `bashio` not found | Broken shebang or missing stub | Ensure shebang is `#!/usr/bin/with-contenv bashio`. |
| PostgreSQL migration error (vector/crypto) | Missing extension libraries | Verify `postgresql16-contrib` and `pgvector` compile in `Dockerfile`. |

---

## Git & Version Control
- **Never Commit or Push Without Asking:** NEVER run `git commit` or `git push` without explicit user permission/confirmation. Always ask and receive explicit approval first.

---

## Response Style & Efficiency
- Direct answers first. Technical reasoning follows when necessary.
- No conversational preamble, hollow closings, or restating the prompt.
- Structured output (code, tables, diffs).
- Clickable file links for all references.