#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_spm.sh <version>
VERSION="$1"
PACKAGE_FILE="Package.swift"
ZIP_FILE="AppsFlyerRPC.xcframework.zip"

# Create temp zip for checksum calculation
if [ -d AppsFlyerRPC.xcframework ]; then
  zip -r "$ZIP_FILE" AppsFlyerRPC.xcframework > /dev/null
  CHECKSUM=$(swift package compute-checksum "$ZIP_FILE")
  rm "$ZIP_FILE"
else
  echo "Warning: AppsFlyerRPC.xcframework not found, skipping checksum update"
  CHECKSUM="CHECKSUM_TO_BE_UPDATED_AFTER_BUILD"
fi

# Update URL and checksum in Package.swift
sed -i.bak -E \
  -e "s|url: \"https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/[0-9]+\.[0-9]+\.[0-9]+/|url: \"https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/${VERSION}/|" \
  -e "s|checksum: \"[a-f0-9]+\"|checksum: \"${CHECKSUM}\"|" \
  "${PACKAGE_FILE}"

rm "${PACKAGE_FILE}.bak"

