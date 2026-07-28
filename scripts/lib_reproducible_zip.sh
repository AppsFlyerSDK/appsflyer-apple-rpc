#!/usr/bin/env bash
# Shared by update_spm.sh and zip_artifacts.sh.
#
# update_spm.sh computes the SPM checksum in the prepare-release job; zip_artifacts.sh
# builds the actual uploaded artifact later, in a separate publish-release job with its
# own `actions/checkout`. Plain `zip -r` embeds each file's mtime, and actions/checkout
# resets mtimes to checkout time on every run, so the same source tree zipped in two
# different jobs produces two different checksums even though the content is identical.
# Normalizing mtimes before zipping (and stripping extra attributes) makes the archive
# byte-identical across both jobs, so the checksum baked into Package.swift always
# matches the artifact that actually gets uploaded.
# Also makes the archive's internal layout explicit and shared: both callers zip a
# framework dir from inside its own parent (chdir first), so the archive always
# contains a flat "<framework>.xcframework/..." — never a caller-specific prefix that
# would make two otherwise-identical archives diverge in structure, not just mtime.
zip_reproducible() {
  local chdir="$1"
  local target="$2"
  local output_zip="$3"

  (
    cd "$chdir"
    find "$target" -exec touch -h -t 197001010000 {} +
    rm -f "$output_zip"
    zip -X -r -q "$output_zip" "$target"
  )
}
