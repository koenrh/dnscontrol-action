#!/usr/bin/env bash

set -o pipefail

escape() {
  local input="$1"

  # https://github.community/t/set-output-truncates-multiline-strings/16852/3
  input="${input//'%'/'%25'}"
  input="${input//$'\n'/'%0A'}"
  input="${input//$'\r'/'%0D'}"

  echo "$input"
}

# Resolve to full paths
CONFIG_ABS_PATH="$(readlink -f "${INPUT_CONFIG_FILE}")"
CREDS_ABS_PATH="$(readlink -f "${INPUT_CREDS_FILE}")"

WORKING_DIR="$(dirname "${CONFIG_ABS_PATH}")"
cd "$WORKING_DIR" || exit

ARGS=(
  "$@"
   --config "$CONFIG_ABS_PATH"
)

# 'check' sub-command doesn't require credentials
if [ "$1" != "check" ]; then
    ARGS+=(--creds "$CREDS_ABS_PATH")
fi

IFS=
OUTPUT="$(dnscontrol "${ARGS[@]}")"
EXIT_CODE="$?"

echo "$OUTPUT"

# Filter output to reduce 'preview' PR comment length
FILTERED_OUTPUT="$(echo "$OUTPUT" | /filter-preview-output.sh)"

OUTPUT="$(escape "$OUTPUT")"
FILTERED_OUTPUT="$(escape "$FILTERED_OUTPUT")"

echo "::set-output name=output::$OUTPUT"
echo "::set-output name=preview_comment::$FILTERED_OUTPUT"

exit $EXIT_CODE
