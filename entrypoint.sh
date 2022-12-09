#!/usr/bin/env bash

set -o pipefail

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

# Set output
# https://github.com/orgs/community/discussions/26288#discussioncomment-3876281
DELIMITER="DNSCONTROL-$RANDOM"

{
  echo "output<<$DELIMITER"
  echo "$OUTPUT"
  echo "$DELIMITER"

  echo "preview_comment<<$DELIMITER"
  echo "$FILTERED_OUTPUT"
  echo "$DELIMITER"
} >> "$GITHUB_OUTPUT"

exit $EXIT_CODE
