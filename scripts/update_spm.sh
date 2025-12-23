#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_spm.sh <version>
VERSION="$1"
PACKAGE_FILE="Package.swift"
ZIP_FILE="AppsFlyerRPC-static.xcframework.zip"

# Create temp zip for checksum calculation
if [ -d AppsFlyerRPC.xcframework ]; then
  zip -r "$ZIP_FILE" AppsFlyerRPC.xcframework > /dev/null
  CHECKSUM=$(swift package compute-checksum "$ZIP_FILE")
  rm "$ZIP_FILE"
else
  echo "Warning: AppsFlyerRPC.xcframework not found, skipping checksum update"
  CHECKSUM="CHECKSUM_PLACEHOLDER"
fi

# Check if using path or url in Package.swift
if grep -q "path:" "$PACKAGE_FILE"; then
  # Convert from path to url + checksum (first release)
  sed -i.bak -E \
    -e "s|path: \"AppsFlyerRPC.xcframework\"|url: \"https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/${VERSION}/AppsFlyerRPC-static.xcframework.zip\",\\
            checksum: \"${CHECKSUM}\"|" \
    "${PACKAGE_FILE}"
else
  # Update existing URL and checksum
  sed -i.bak -E \
    -e "s|url: \"https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/[0-9]+\.[0-9]+\.[0-9]+/AppsFlyerRPC-static.xcframework.zip\"|url: \"https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/${VERSION}/AppsFlyerRPC-static.xcframework.zip\"|" \
    -e "s|checksum: \"[^\"]+\"|checksum: \"${CHECKSUM}\"|" \
    "${PACKAGE_FILE}"
fi

rm "${PACKAGE_FILE}.bak"

