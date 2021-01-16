#!/usr/bin/env bash

set -eo pipefail

WORKING_DIR="${INPUT_DNSCONTROL_CONFIG_FILE%/*}"
CONFIG_FILE="$(basename "${INPUT_DNSCONTROL_CONFIG_FILE}")"
cd "$WORKING_DIR"

IFS=
OUTPUT="$(dnscontrol "$1" --config "$CONFIG_FILE" --creds "$INPUT_DNSCONTROL_CREDS_FILE")"

echo "$OUTPUT"

# https://github.community/t/set-output-truncates-multiline-strings/16852/3
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "::set-output name=output::$OUTPUT"
