#!/usr/bin/env bash
set -euo pipefail

# Run from repo root. Zips AppsFlyerRPC.xcframework, Dynamic/AppsFlyerRPC.xcframework, and Strict/AppsFlyerRPC.xcframework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib_reproducible_zip.sh
source "${SCRIPT_DIR}/lib_reproducible_zip.sh"

# 1) static — must byte-match what update_spm.sh zipped when it computed the checksum
zip_reproducible "." "AppsFlyerRPC.xcframework" "AppsFlyerRPC-static.xcframework.zip"

# 2) dynamic
zip_reproducible "." "Dynamic/AppsFlyerRPC.xcframework" "AppsFlyerRPC-dynamic.xcframework.zip"

# 3) strict — must byte-match what update_spm.sh zipped when it computed the checksum
zip_reproducible "Strict" "AppsFlyerRPC.xcframework" "../AppsFlyerRPC-strict.xcframework.zip"

