# Home Assistant OS Add-on: Postiz

[![Release](https://img.shields.io/badge/version-2.25.3-blue.svg?style=flat-square)](CHANGELOG.md)
[![Architectures](https://img.shields.io/badge/arch-amd64%20%7C%20aarch64-brightgreen.svg?style=flat-square)](#)
[![Stage](https://img.shields.io/badge/stage-stable-green.svg?style=flat-square)](#)

[Postiz](https://github.com/gitroomhq/postiz-app) is an open-source social media scheduling, analytics, and automation platform with AI agent workflows and Model Context Protocol (MCP) integrations.

## Features

- **Social Media Scheduling** — Manage and schedule posts across X (Twitter), LinkedIn, YouTube, Instagram, Facebook, TikTok, Threads, Pinterest, Reddit, Bluesky, Mastodon, and Discord.
- **Embedded Zero-Config Architecture** — Includes bundled PostgreSQL and Redis instances for 1-click startup without external dependencies.
- **Persistent Data** — Storage, database, and encryption keys reside under `/data` and are included in Home Assistant snapshots (`backup: hot`).
- **Flexible Deployment** — Support for external PostgreSQL (`db_url`), external Redis (`redis_url`), and Cloudflare R2 object storage.
- **MCP Integration** — Connect Claude, Cursor, and Home Assistant agents to automate social media campaigns.

For complete setup instructions and configuration options, see [DOCS.md](DOCS.md).

