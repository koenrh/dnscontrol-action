#!/usr/bin/env bash

set -eo pipefail

# Resolve to full paths
CONFIG_ABS_PATH="$(readlink -f "${INPUT_DNSCONTROL_CONFIG_FILE}")"
CREDS_ABS_PATH="$(readlink -f "${INPUT_DNSCONTROL_CREDS_FILE}")"


WORKING_DIR="$(dirname "${CONFIG_ABS_PATH}")"
#CONFIG_FILE="$(basename "${INPUT_DNSCONTROL_CONFIG_FILE}")"
cd "$WORKING_DIR"

IFS=
OUTPUT="$(dnscontrol "$1" --config "$CONFIG_ABS_PATH" --creds "$CREDS_ABS_PATH")"

echo "$OUTPUT"

# https://github.community/t/set-output-truncates-multiline-strings/16852/3
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "::set-output name=output::$OUTPUT"
