#!/usr/bin/env bash
# Capture submission assets (images/screenshot.png + images/tn.png) from
# the live demo. Run from repo root. Re-runnable; overwrites existing files.
#
# Requires: npx (runs agent-browser, https://github.com/vercel-labs/agent-browser)
# Optional: AGENT_BROWSER_EXECUTABLE_PATH, a Chrome/Chromium to use instead of
#           the one `agent-browser install` downloads (needed where that build
#           cannot start, such as Ubuntu with AppArmor limits: point it at the
#           system Chrome)
# Optional: oxipng (lossless PNG compression — recommended)

set -euo pipefail

URL="${BANYAN_DEMO_URL:-https://tiennm99.github.io/banyan/}"
SCREENSHOT="images/screenshot.png"
THUMBNAIL="images/tn.png"
export AGENT_BROWSER_SESSION="banyan-screenshots"

cd "$(dirname "$0")/.."

mkdir -p images

ab() { npx --yes agent-browser "$@"; }

if [ -z "${AGENT_BROWSER_EXECUTABLE_PATH:-}" ]; then
  echo "==> Installing agent-browser's Chrome (cached after first run)"
  ab install
fi

trap 'ab close >/dev/null 2>&1 || true' EXIT

echo "==> Opening $URL"
ab set viewport 1500 1000
ab open "$URL"
ab set media light
ab wait 800

echo "==> Capturing screenshot.png (1500x1000)"
ab screenshot "$SCREENSHOT"

echo "==> Capturing tn.png (900x600)"
ab set viewport 900 600
ab wait 500
ab screenshot "$THUMBNAIL"

if command -v oxipng >/dev/null 2>&1; then
  echo "==> Compressing with oxipng"
  oxipng -o4 --strip safe "$SCREENSHOT" "$THUMBNAIL"
else
  echo "==> oxipng not installed; skipping compression (install for smaller files)"
fi

echo "==> Done"
file "$SCREENSHOT" "$THUMBNAIL"
