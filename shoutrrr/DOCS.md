# Home Assistant Add-on: Shoutrrr

[Shoutrrr](https://github.com/coollabsio/shoutrrr) is a self-hosted social media scheduler — an open-source alternative to Buffer, Typefully and Hootsuite. Compose a post once and publish it to X, Bluesky, LinkedIn, Facebook, Instagram, Threads and Discord, either immediately or from a recurring queue and month calendar.

Everything (posts, connected-account tokens, analytics, media) stays in `/data` on your Home Assistant device.

---

## Features

- **One post, every platform**: fan a post out to multiple connected accounts, with optional per-network text overrides and automatic thread splitting.
- **Queue & calendar**: recurring posting slots in your workspace timezone plus a month view of everything scheduled.
- **Connected accounts**: X, Bluesky (OAuth or app password), LinkedIn, Facebook Pages, Instagram (via linked Pages), Threads, and Discord webhooks.
- **Analytics & engagement**: follower/post trends, per-post engagement, and a replies inbox where the provider API supports it.
- **Workspaces & team**: multiple workspaces, roles, email invitations, and instance-level settings.
- **Secure by default**: email/password with verification, TOTP two-factor, passkeys (WebAuthn), and optional Google social login.
- **API + MCP**: Laravel Passport bearer tokens, a REST API, and a Model Context Protocol server at `/mcp`.

---

## Add-on Options

| Option | Type | Default | Description |
|---|---|---|---|
| `app_url` | string | `http://homeassistant.local:8080` | Canonical external URL of this instance. Used for links, redirects and every OAuth callback. Must match the URL you actually open. If you use HTTPS, set the `https://` URL. |
| `app_key` | password | `""` | Laravel application key (`base64:` + exactly 32 bytes). Leave empty to auto-generate once and persist at `/data/app_key`. Changing or losing this value invalidates sessions and encrypted data. |
| `log_level` | list | `info` | Log verbosity: `debug`, `info`, `notice`, `warning` or `error`. Logs rotate daily (14 days) in `/data/storage/logs`. |
| `registrations_enabled` | bool | `false` | Allow new accounts after the first owner exists. The first account can always register. |
| `trusted_proxies` | string | `""` | Trusted reverse-proxy IPs/CIDRs, or `*` when the add-on is only reachable through a proxy. Needed for correct scheme, host, and client IP behind a tunnel or reverse proxy. |
| `queue_workers` | integer | `1` | Number of in-container queue workers (1–4). Keep `1` with SQLite; more workers can hit `database is locked`. |
| `mail_enabled` | bool | `false` | Enable SMTP. When disabled, emails are written to the add-on log and email verification stays off (so first-run registration works). |
| `mail_host` | string | `""` | SMTP server hostname. |
| `mail_port` | port | `587` | SMTP port (587 for STARTTLS, 465 for implicit TLS). |
| `mail_username` | string | `""` | SMTP username, if required. |
| `mail_password` | password | `""` | SMTP password, if required. |
| `mail_encryption` | list | `tls` | `tls` = STARTTLS (`smtp` scheme), `ssl` = implicit TLS (`smtps`), `none` = plain. |
| `mail_from_address` | string | `""` | Sender address. Defaults to `shoutrrr@<app_url host>`. |
| `mail_from_name` | string | `Shoutrrr` | Sender display name. |
| `x_client_id` / `x_client_secret` | string / password | `""` | X (Twitter) OAuth 2.0 app credentials. |
| `linkedin_client_id` / `linkedin_client_secret` | string / password | `""` | LinkedIn OAuth 2.0 (OIDC) app credentials. |
| `facebook_client_id` / `facebook_client_secret` | string / password | `""` | Meta app credentials, shared by Facebook Pages and Instagram. |
| `threads_client_id` / `threads_client_secret` | string / password | `""` | Threads app credentials (a separate Meta app). |
| `google_client_id` / `google_client_secret` | string / password | `""` | Google OAuth credentials. When set, "Sign in with Google" is enabled automatically. |
| `metrics_enabled` | bool | `true` | Poll post/account metrics from the platform APIs. |
| `engagement_enabled` | bool | `true` | Poll replies/likes/comments into the engagement inbox. |
| `messages_enabled` | bool | `true` | Enable the direct-messages inbox and DM polling. |

Options are applied on add-on start. Restart the add-on after changing them.

---

## Accessing the App

Shoutrrr is served directly on **port 8080** of your Home Assistant host — there is no Ingress/sidebar entry, because the app has no base-path support.

- **Web UI**: `http://<YOUR_HA_IP>:8080` (or **OPEN WEB UI** on the add-on card)
- **Health check**: `http://<YOUR_HA_IP>:8080/up` (used by the add-on watchdog)
- **REST API**: `http://<YOUR_HA_IP>:8080/api`
- **MCP**: `http://<YOUR_HA_IP>:8080/mcp`

The container internally supervises four processes: the Octane/FrankenPHP web server, a queue worker, the task scheduler, and an (off by default) Inertia SSR process. Publishing and polling only work while the worker and scheduler run.

---

## First Start

1. Start the add-on and wait for `Starting Shoutrrr on port 8080` plus the migration output in the log.
2. Open `http://<YOUR_HA_IP>:8080` and register the first account — it becomes the instance **owner**. Registration stays open for this first account even with `registrations_enabled: false`.
3. Optional: open **Settings → Instance** to review registration, workspace, and polling toggles.
4. Add connected accounts under **Connected Accounts** (see below).

On first boot the add-on:

- generates and persists the Laravel `APP_KEY` at `/data/app_key`,
- symlinks `/var/www/html/storage` to `/data/storage` and `/var/www/html/database/sqlite` to `/data/sqlite`,
- runs upstream database migrations and Laravel optimizations on every start,
- creates the Passport keypair for API/MCP tokens the first time a workspace issues an API key (stored in `/data/storage/oauth-*.key`).

---

## Connecting Accounts

### Bluesky

Two options, neither needs a developer app:

- **App password** (recommended for LAN installs): paste a Bluesky [app password](https://bsky.app/settings/app-passwords).
- **ATProto OAuth**: zero-config, but Bluesky must be able to fetch `https://<app_url>/oauth/bluesky/client-metadata.json` and `jwks.json`. That requires `app_url` to be a **public HTTPS URL**.

### X (Twitter)

1. Sign in to the [X Developer Console](https://console.x.com) and create a Project + App (**New App**).
2. Open **User authentication settings → Set up** and fill in:
   - **App permissions**: `Read and write` (needed for `tweet.write` and `like.write`).
   - **Type of App**: `Web App, Automated App or Bot` — this is a confidential client, the only type that issues a Client Secret.
   - **Callback URI**: `${APP_URL}/accounts/callback/x` — exact match, including scheme and trailing slash.
   - **Website URL**, **Terms of Service**, **Privacy Policy**: any valid URLs.
   - **Request email address from users**: enabled (required for the `users.email` scope; without it `/2/users/me` returns 403).
3. Copy the **OAuth 2.0 Client ID** and **Client Secret** from **Keys and tokens** into `x_client_id` / `x_client_secret`.
4. Scopes Shoutrrr requests: `users.read`, `users.email`, `tweet.read`, `tweet.write`, `media.write`, `like.write`, `offline.access`.

`offline.access` is what lets the connected account refresh instead of expiring silently. X bills API usage per endpoint (see the console's usage/credit page), so a scheduler with metrics and engagement polling consumes credits continuously — turn those toggles off if you only publish.

> X rejects `http://` callbacks for anything other than `http://127.0.0.1`, so connecting an X account over a plain LAN URL such as `http://homeassistant.local:8080` fails with a `redirect_uri` error. Use a public HTTPS `app_url` (reverse proxy or tunnel) for X.

### LinkedIn

1. Create an app at <https://www.linkedin.com/developers/apps> — you need a LinkedIn Page you administer (create one first if necessary).
2. **Auth** tab: add the authorized redirect URL `${APP_URL}/accounts/callback/linkedin`, then copy the **Client ID** and **Primary Client Secret** (the secondary secret is not used).
3. **Products** tab: request both **Share on LinkedIn** (`w_member_social`) and **Sign In with LinkedIn using OpenID Connect** (`openid`, `profile`, `email`). Both must show as *Added* before you authorize; a pending product makes LinkedIn fail with `unauthorized_scope_error`.
4. Set `linkedin_client_id` / `linkedin_client_secret` and restart the add-on.
5. Scopes Shoutrrr requests: `openid`, `profile`, `email`, `w_member_social`.

Notes:

- The connection posts as the **signed-in member**. Posting to a Company Page needs `w_organization_social` from the Community Management API (see below).
- Member access tokens live ~60 days. Programmatic refresh requires Marketing Developer Platform access, so expect to reconnect the account when Shoutrrr marks it expired.
- Engagement polling for LinkedIn additionally needs `r_member_social_feed`; Shoutrrr only requests it when LinkedIn Community Management is enabled in the instance settings.

#### Posting to a LinkedIn Page (company)

Shoutrrr can publish as a Page, but the Page must be discovered through the partner-gated Community Management API:

1. In the LinkedIn app, request the **Community Management API** product and complete app verification. Only then can the app be granted `rw_organization_admin`, `r_organization_social` and `w_organization_social`.
2. Make sure your LinkedIn account is an **approved admin** of the Page (`organizationAcls` only returns APPROVED roles).
3. In Shoutrrr open **Settings → Instance → Platforms** and enable **“LinkedIn Pages & engagement inbox (Community Management API)”** — this adds the restricted scopes to the LinkedIn consent request.
4. Reconnect LinkedIn. After authorizing, Shoutrrr lists your personal profile **and** every Page you administer; pick the Page (you can select both).
5. Re-target existing drafts/queued posts to the Page account — posts already pointed at the member account keep publishing as the member.

Enabling step 3 before the product is approved makes the LinkedIn authorization fail with `unauthorized_scope_error`, including for personal accounts.

### Facebook + Instagram (one Meta app)

1. Create a Facebook Login app at <https://developers.facebook.com>.
2. Redirect URI: `${APP_URL}/accounts/callback/meta`
3. Scopes: `pages_show_list`, `pages_read_engagement`, `pages_manage_posts`, `pages_read_user_content`, `pages_manage_engagement`, `read_insights`, `business_management`, `instagram_basic`, `instagram_content_publish`, `instagram_manage_comments`, `instagram_manage_insights`
4. Set `facebook_client_id` / `facebook_client_secret`.

Instagram accounts are discovered through the Facebook Pages you manage (a Page with a linked Instagram professional account). Publishing to non-test accounts requires Meta App Review and Business Verification.

### Threads

Use a **separate** Meta app with the Threads use case.

1. Redirect URI: `${APP_URL}/accounts/callback/threads`
2. Scopes: `threads_basic`, `threads_content_publish`, `threads_manage_replies`, `threads_manage_insights`, `threads_delete`
3. Set `threads_client_id` / `threads_client_secret`.

### Discord

No add-on configuration — add a channel webhook URL inside Shoutrrr.

> OAuth callbacks are derived from `app_url`, so change that option **before** registering the redirect URIs with each provider.

---

## Email (SMTP)

Emails are only needed for invitations, password resets, notifications, and (optionally) address verification. Without SMTP:

- `MAIL_MAILER=log`, so mails appear in the add-on log only,
- email verification is disabled automatically, which keeps first-run registration friction-free.

To enable SMTP, set `mail_enabled: true` plus host/port/credentials. With SMTP active, Shoutrrr enables email verification for new accounts. Use `tls` for port 587 (STARTTLS) and `ssl` for port 465.

---

## HTTPS and Reverse Proxies

For anything beyond LAN access — Bluesky OAuth, X/LinkedIn/Meta callbacks, passkeys — use a public HTTPS URL:

1. Put Shoutrrr behind a TLS-terminating proxy or tunnel (Cloudflare Tunnel, nginx, Traefik, Caddy) pointing at `http://<HA_IP>:8080`.
2. Set `app_url` to the public HTTPS URL, e.g. `https://social.example.com`.
3. Set `trusted_proxies` to `*` (proxy-only access) or the proxy's IP/CIDR list.

When `app_url` starts with `https://`, the add-on automatically sets `OCTANE_HTTPS=true` and `SESSION_SECURE_COOKIE=true`. If logins redirect to `http://` or you see a redirect loop, those two values and `trusted_proxies` are the first things to check.

---

## API and MCP

Bearer tokens are minted per workspace under **Settings → API keys** (Laravel Passport). Use them for:

- **REST API**: `GET/POST http://<HA_IP>:8080/api/...`
- **MCP**: `http://<HA_IP>:8080/mcp` — requires an `Authorization: Bearer <token>` header. Opening `/mcp` in a browser shows a landing page; MCP clients use the same URL.

Passport keys live in `/data/storage`, so tokens survive restarts and add-on updates.

---

## Data, Backups and Resources

| Path | Contents |
|---|---|
| `/data/sqlite/database.sqlite` | Users, workspaces, posts, targets, analytics, queue/session/cache tables |
| `/data/storage/app/public` | Uploaded images and videos |
| `/data/storage/logs` | Daily-rotated logs (14 days) |
| `/data/storage/oauth-*.key` | Passport keypair for API/MCP tokens |
| `/data/app_key` | Laravel `APP_KEY` |

Home Assistant snapshots include all of `/data`. Video uploads are allowed up to Shoutrrr's 1 GiB ceiling, so snapshots can become large if you publish many videos — prune media from inside the app if needed.

Resource notes:

- Expect roughly 600 MB of RAM at idle (Octane/FrankenPHP + queue worker + scheduler); plan for ~1 GB to leave headroom for video processing.
- PHP runs with a 512 MB memory limit and `ffmpeg` is available for video thumbnails.
- SQLite plus the database queue/session drivers means one worker is the safe default (`queue_workers: 1`). Raising it risks `database is locked`.
- CPU-heavy work (video processing, polling many accounts) competes with Home Assistant; disable `metrics_enabled` / `engagement_enabled` / `messages_enabled` to reduce background load.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Login redirects to `http://` or loops | `app_url` scheme mismatch, or proxy headers untrusted | Set `app_url` to the exact URL you use; set `trusted_proxies` (`*` behind a proxy) and restart. |
| Page loads unstyled / features fail in the browser console | Content-Security-Policy blocks a custom CDN/proxy origin | Serve assets from the same origin as `app_url`, or front the app with a proxy that does not rewrite asset hosts. |
| OAuth callback error (`redirect_uri` mismatch) | Provider app registered a different URL than `app_url` | Update the provider's redirect URI to `${app_url}/accounts/callback/...` and restart the add-on. |
| Bluesky OAuth fails but app passwords work | `app_url` is not publicly reachable over HTTPS | Use an app password, or expose the add-on publicly with HTTPS. |
| `database is locked` errors | Multiple queue workers on SQLite | Set `queue_workers: 1`. |
| Invitations / password reset emails missing | SMTP disabled (`mail_enabled: false`) | Configure SMTP; with the log mailer, read the message from the add-on log instead. |
| Scheduled posts never publish | Worker or scheduler not running, or the queue stalled | Check the add-on log for `[program:worker]` / `[program:schedule]` output and restart. |
| `Invalid APP_KEY` / sessions logged out after update | `app_key` option was changed, or `/data/app_key` was deleted | Restore the previous key (from a snapshot of `/data/app_key`) and restart. |
| Add-on exits with `app_key decodes to N bytes` | Supplied `app_key` is not 32 bytes (e.g. copied from a different app) | Clear `app_key` to auto-generate one, or paste a valid `base64:` key that decodes to 32 bytes. |
| No web UI on port 8080 | Host port conflict or add-on still starting | Change the host side of the port mapping, and wait for the migration output to finish. |
