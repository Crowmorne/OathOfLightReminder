#!/usr/bin/env bash
# Prints the section of CHANGELOG.md for the given version, without its heading.
# Fails if CHANGELOG.md has no section for that version, or if it's empty.
#
# Usage: bash .github/scripts/changelog-section.sh 1.2.0

set -euo pipefail

version="${1:?usage: changelog-section.sh <version>}"

# The section starts after the line beginning with "## [<version>]" and ends
# at the next version heading or at the link references at the end of the file.
section=$(awk -v heading="## [$version]" '
  index($0, heading) == 1 { found = 1; next }
  found && (/^## \[/ || /^\[[^]]+\]: /) { exit }
  found { print }
' CHANGELOG.md)

if ! grep -q '[^[:space:]]' <<< "$section"; then
  echo "CHANGELOG.md has no section for $version" >&2
  exit 1
fi

printf '%s\n' "$section"
