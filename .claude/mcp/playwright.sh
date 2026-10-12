#!/usr/bin/env bash
# Starts the Playwright MCP server. In Claude Code cloud sessions, reuse the
# pre-installed Chromium instead of downloading a browser.
args=(--headless --browser chromium)
if [ -x /opt/pw-browsers/chromium ]; then
  args+=(--executable-path /opt/pw-browsers/chromium)
fi
exec npx -y @playwright/mcp@0.0.83 "${args[@]}" "$@"
