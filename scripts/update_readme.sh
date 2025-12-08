#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/update_readme.sh <version>
VERSION="$1"
README="README.md"

# Update Carthage installation examples to use the new version
sed -i.bak -E \
  "s|(AppsFlyerRPC-(static|dynamic)\.json\" == )[0-9]+\.[0-9]+\.[0-9]+|\1${VERSION}|g" \
  "$README"

# Cleanup backup file
rm "${README}.bak"

echo "✅ README.md updated to version $VERSION"

