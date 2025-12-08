#!/usr/bin/env bash
set -euo pipefail

# Run from repo root. Zips AppsFlyerRPC.xcframework and Dynamic/AppsFlyerRPC.xcframework

# 1) static
zip -r AppsFlyerRPC-static.xcframework.zip AppsFlyerRPC.xcframework

# 2) dynamic
zip -r AppsFlyerRPC-dynamic.xcframework.zip Dynamic/AppsFlyerRPC.xcframework

