#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_spm.sh <version>
# Updates the url+checksum pair for each binaryTarget (static, strict) independently,
# matched by that variant's zip filename so the two targets' checksums never cross-contaminate.
VERSION="$1"
PACKAGE_FILE="Package.swift"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib_reproducible_zip.sh
source "${SCRIPT_DIR}/lib_reproducible_zip.sh"

for VARIANT_DIR_NAME in "static:AppsFlyerRPC.xcframework" "strict:Strict/AppsFlyerRPC.xcframework"; do
  VARIANT="${VARIANT_DIR_NAME%%:*}"
  XCFRAMEWORK_DIR="${VARIANT_DIR_NAME#*:}"
  ZIP_FILE="AppsFlyerRPC-${VARIANT}.xcframework.zip"

  if [ -d "$XCFRAMEWORK_DIR" ]; then
    # Zip the same way zip_artifacts.sh will later zip the real release artifact
    # (same chdir root, same flat layout, same normalized mtimes) — otherwise this
    # checksum would never match the artifact publish-release.yml actually uploads.
    ZIP_ROOT="$(dirname "$XCFRAMEWORK_DIR")"
    ZIP_TARGET="$(basename "$XCFRAMEWORK_DIR")"
    if [ "$ZIP_ROOT" = "." ]; then
      OUTPUT_FROM_ROOT="$ZIP_FILE"
    else
      OUTPUT_FROM_ROOT="../${ZIP_FILE}"
    fi
    zip_reproducible "$ZIP_ROOT" "$ZIP_TARGET" "$OUTPUT_FROM_ROOT"
    CHECKSUM=$(swift package compute-checksum "$ZIP_FILE")
    rm "$ZIP_FILE"
  else
    echo "Warning: ${XCFRAMEWORK_DIR} not found, skipping checksum update for ${VARIANT}"
    CHECKSUM="CHECKSUM_PLACEHOLDER"
  fi

  NEW_URL="https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/${VERSION}/AppsFlyerRPC-${VARIANT}.xcframework.zip"

  # Replace this variant's url line, then the checksum line right after it —
  # matched by variant-specific zip filename so the two targets never cross-contaminate.
  # If the variant is still bootstrapped as a local `path:` reference (pre-first-release),
  # convert it to a url:+checksum: pair instead.
  VARIANT="$VARIANT" NEW_URL="$NEW_URL" CHECKSUM="$CHECKSUM" XCFRAMEWORK_DIR="$XCFRAMEWORK_DIR" python3 - "$PACKAGE_FILE" <<'PYEOF'
import os, sys

path = sys.argv[1]
variant = os.environ["VARIANT"]
new_url = os.environ["NEW_URL"]
checksum = os.environ["CHECKSUM"]
xcframework_dir = os.environ["XCFRAMEWORK_DIR"]
zip_marker = f"AppsFlyerRPC-{variant}.xcframework.zip"

with open(path) as f:
    lines = f.readlines()

found = False
i = 0
while i < len(lines):
    line = lines[i]
    indent = line[:len(line) - len(line.lstrip())]

    if "path:" in line and f'"{xcframework_dir}"' in line:
        lines[i] = f'{indent}url: "{new_url}",\n{indent}checksum: "{checksum}"\n'
        found = True
        break

    if "url:" in line and zip_marker in line:
        lines[i] = f'{indent}url: "{new_url}",\n'
        for j in range(i + 1, len(lines)):
            if "checksum:" in lines[j]:
                cindent = lines[j][:len(lines[j]) - len(lines[j].lstrip())]
                lines[j] = f'{cindent}checksum: "{checksum}"\n'
                found = True
                break
        break
    i += 1

if not found:
    sys.exit(f"ERROR: could not find url/checksum pair or path: reference for variant '{variant}' in {path}")

with open(path, "w") as f:
    f.writelines(lines)
PYEOF
done

