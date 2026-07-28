#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/update_readme.sh <version>
VERSION="$1"
README="README.md"

# Update Carthage installation examples to use the new version
# Use two separate sed commands to avoid BSD sed issues with alternation in capture groups
sed -i.bak -E \
  "s|AppsFlyerRPC-static\.json\" == [0-9]+\.[0-9]+\.[0-9]+|AppsFlyerRPC-static.json\" == ${VERSION}|g" \
  "$README"

sed -i.bak -E \
  "s|AppsFlyerRPC-dynamic\.json\" == [0-9]+\.[0-9]+\.[0-9]+|AppsFlyerRPC-dynamic.json\" == ${VERSION}|g" \
  "$README"

# Matches either a real version or the pre-release "<version>" placeholder,
# so the first release replaces the placeholder and later releases keep updating it.
# Uses % as the sed delimiter since the pattern needs a literal | for alternation.
sed -i.bak -E \
  "s%AppsFlyerRPC-strict\.json\" == ([0-9]+\.[0-9]+\.[0-9]+|<version>)%AppsFlyerRPC-strict.json\" == ${VERSION}%g" \
  "$README"

# Cleanup backup file
rm "${README}.bak"

echo "✅ README.md updated to version $VERSION"

