#!/usr/bin/env python3
"""
Upstream release checker for Home Assistant OS add-ons in this repository.

Queries GitHub for latest upstream releases and compares against local
add-on configuration (`config.yaml` and `updater.json`).

Usage:
    python scripts/check_upstream_updates.py [--markdown] [--json] [--check]
"""

import argparse
import json
import os
import re
import ssl
import sys
import urllib.request
from pathlib import Path

# Add-on catalog: directory name -> upstream repository
ADDONS = {
    "securo": "securo-finance/securo",
    "omniroute": "diegosouzapw/OmniRoute",
    "memos": "usememos/memos",
    "blinko": "blinkospace/blinko",
    "freellmapi": "tashfeenahmed/freellmapi",
    "shoutrrr": "coollabsio/shoutrrr",
    "postiz": "gitroomhq/postiz-app",
}


def normalize_version(tag: str) -> str:
    """Strip leading 'v' and whitespace for semantic comparison."""
    if not tag:
        return ""
    tag = tag.strip()
    return tag[1:] if tag.startswith("v") or tag.startswith("V") else tag


def get_local_addon_info(addon_dir: Path) -> dict:
    """Extract version information from local addon files."""
    config_file = addon_dir / "config.yaml"
    updater_file = addon_dir / "updater.json"

    addon_version = "Unknown"
    tracked_upstream = "Unknown"
    last_updated = "Unknown"

    if config_file.exists():
        try:
            content = config_file.read_text(encoding="utf-8")
            match = re.search(r'^version:\s*["\']?([^"\'\s]+)["\']?', content, re.MULTILINE)
            if match:
                addon_version = match.group(1)
        except Exception:
            pass

    if updater_file.exists():
        try:
            data = json.loads(updater_file.read_text(encoding="utf-8"))
            tracked_upstream = data.get("upstream_version", "Unknown")
            last_updated = data.get("last_update", "Unknown")
        except Exception:
            pass

    return {
        "addon_version": addon_version,
        "tracked_upstream": tracked_upstream,
        "last_updated": last_updated,
    }


def fetch_upstream_latest(repo: str) -> dict:
    """Fetch latest release or tag info from GitHub API."""
    headers = {
        "User-Agent": "hassio-addons-updater",
        "Accept": "application/vnd.github.v3+json",
    }
    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"

    ctx = ssl.create_default_context()
    latest_tag = None
    published_at = None
    html_url = None

    # Try releases/latest first
    try:
        url = f"https://api.github.com/repos/{repo}/releases/latest"
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, context=ctx, timeout=12) as resp:
            data = json.loads(resp.read().decode())
            latest_tag = data.get("tag_name")
            published_at = data.get("published_at", "")[:10]
            html_url = data.get("html_url")
    except Exception:
        pass

    # Fallback to tags if releases/latest is not available or empty
    if not latest_tag:
        try:
            url = f"https://api.github.com/repos/{repo}/tags?per_page=1"
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, context=ctx, timeout=12) as resp:
                data = json.loads(resp.read().decode())
                if data:
                    latest_tag = data[0].get("name")
                    html_url = f"https://github.com/{repo}/releases/tag/{latest_tag}"
        except Exception as e:
            return {"error": str(e), "latest_tag": None, "published_at": None, "html_url": None}

    return {
        "latest_tag": latest_tag,
        "published_at": published_at,
        "html_url": html_url,
        "error": None,
    }


def check_updates(repo_root: Path) -> list:
    """Check all add-ons for updates against their upstream repository."""
    results = []
    for slug, repo in ADDONS.items():
        addon_dir = repo_root / slug
        local_info = get_local_addon_info(addon_dir)
        upstream_info = fetch_upstream_latest(repo)

        tracked = local_info["tracked_upstream"]
        latest = upstream_info["latest_tag"] or "N/A"

        norm_tracked = normalize_version(tracked)
        norm_latest = normalize_version(latest)

        if upstream_info.get("error"):
            status = "Error"
        elif not upstream_info.get("latest_tag"):
            status = "No release found"
        elif norm_tracked != "Unknown" and norm_tracked != norm_latest:
            status = "Update Available"
        elif norm_tracked != "Unknown" and norm_tracked == norm_latest:
            status = "Up to date"
        else:
            status = "Unknown"

        results.append({
            "slug": slug,
            "repo": repo,
            "addon_version": local_info["addon_version"],
            "tracked_upstream": tracked,
            "latest_upstream": latest,
            "published_at": upstream_info.get("published_at") or "",
            "last_updated": local_info["last_updated"],
            "status": status,
            "release_url": upstream_info.get("html_url") or f"https://github.com/{repo}/releases",
            "error": upstream_info.get("error"),
        })

    return results


def print_markdown(results: list) -> None:
    """Print results formatted as GitHub Markdown table."""
    print("| Addon | Upstream Repo | Current Addon | Tracked Upstream | Latest Upstream | Released | Status |")
    print("| :--- | :--- | :--- | :--- | :--- | :--- | :--- |")
    for r in results:
        status_md = f"**{r['status']}**" if r["status"] == "Update Available" else r["status"]
        latest_link = f"[{r['latest_upstream']}]({r['release_url']})" if r["latest_upstream"] != "N/A" else "N/A"
        print(f"| `{r['slug']}` | [{r['repo']}](https://github.com/{r['repo']}) | `{r['addon_version']}` | `{r['tracked_upstream']}` | {latest_link} | {r['published_at']} | {status_md} |")


def print_table(results: list) -> None:
    """Print results formatted as plain text aligned table."""
    headers = ["Addon", "Current Addon", "Tracked Upstream", "Latest Upstream", "Released", "Status"]
    rows = [
        [
            r["slug"],
            r["addon_version"],
            r["tracked_upstream"],
            r["latest_upstream"],
            r["published_at"],
            r["status"],
        ]
        for r in results
    ]

    widths = [len(h) for h in headers]
    for row in rows:
        for i, cell in enumerate(row):
            widths[i] = max(widths[i], len(str(cell)))

    fmt = "  ".join(f"{{:<{w}}}" for w in widths)
    separator = "  ".join("-" * w for w in widths)

    print(fmt.format(*headers))
    print(separator)
    for r in rows:
        print(fmt.format(*r))


def main() -> int:
    parser = argparse.ArgumentParser(description="Check for upstream updates across all add-ons.")
    parser.add_argument("--markdown", "-m", action="store_true", help="Output as markdown table")
    parser.add_argument("--json", "-j", action="store_true", help="Output as JSON")
    parser.add_argument(
        "--check",
        "-c",
        action="store_true",
        help="Exit with code 1 if any updates are available (useful for CI)",
    )
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parent.parent
    results = check_updates(repo_root)

    if args.json:
        print(json.dumps(results, indent=2))
    elif args.markdown:
        print_markdown(results)
    else:
        print_table(results)

    updates_available = any(r["status"] == "Update Available" for r in results)
    if args.check and updates_available:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
