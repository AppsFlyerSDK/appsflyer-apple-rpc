#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_podspec.sh <version>
VERSION="$1"
PODSPEC="AppsFlyerRPC.podspec"

# 1) Bump main s.version
sed -i.bak -E 's|^([[:space:]]*s\.version[[:space:]]*=[[:space:]]*")[0-9]+\.[0-9]+\.[0-9]+(")|\1'"${VERSION}"'\2|' "$PODSPEC"

rm "${PODSPEC}.bak"

