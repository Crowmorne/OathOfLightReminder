#!/usr/bin/env bash
# Checks that the code only uses text keys that Locales/enUS.lua defines,
# and that every other language file only translates keys that exist there.
# Keys must be written out in full (L.SOME_KEY); L[...] is not allowed,
# because it can't be checked.
#
# Usage: bash .github/scripts/check-locales.sh

set -euo pipefail

english="Locales/enUS.lua"
failed=0

# Keys assigned at the start of a line in the given file: L.SOME_KEY = ...
assigned_keys() {
  grep -oE '^L\.[A-Z0-9_]+ *=' "$1" | sed -E 's/^L\.([A-Z0-9_]+).*/\1/' | sort -u
}

defined=$(assigned_keys "$english")

# Prints each key from stdin that enUS.lua doesn't define, prefixed with where it came from.
report_unknown() {
  local where="$1" key
  while read -r key; do
    if [[ -n "$key" ]] && ! grep -qx "$key" <<< "$defined"; then
      echo "$where: unknown text key L.$key" >&2
      failed=1
    fi
  done
}

code_files=$(git ls-files '*.lua' | grep -v '^Locales/')

# Keys used in the code.
for file in $code_files; do
  report_unknown "$file" < <(grep -oE '\bL\.[A-Z0-9_]+' "$file" | sed 's/^L\.//' | sort -u)
  if grep -nHE '\bL\[' "$file" >&2; then
    echo "  use L.SOME_KEY instead of L[...]" >&2
    failed=1
  fi
done

# Keys translated by the other languages.
for file in $(git ls-files 'Locales/*.lua' | grep -vx "$english"); do
  report_unknown "$file" < <(assigned_keys "$file")
done

exit "$failed"
