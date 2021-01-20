#!/usr/bin/env bash

set -eo pipefail

# Resolve to full paths
CONFIG_ABS_PATH="$(readlink -f "${INPUT_CONFIG_FILE}")"
CREDS_ABS_PATH="$(readlink -f "${INPUT_CREDS_FILE}")"

WORKING_DIR="$(dirname "${CONFIG_ABS_PATH}")"
cd "$WORKING_DIR"

ARGS=(
  "$1"
   --config "$CONFIG_ABS_PATH"
)

# 'check' sub-command doesn't require credentials
if [ "$1" != "check" ]; then
    ARGS+=(--creds "$CREDS_ABS_PATH")
fi

IFS=
OUTPUT="$(dnscontrol "${ARGS[@]}")"

echo "$OUTPUT"

# https://github.community/t/set-output-truncates-multiline-strings/16852/3
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "::set-output name=output::$OUTPUT"
