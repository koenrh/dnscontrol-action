#!/usr/bin/env bash

set -eo pipefail

IFS=
OUTPUT="$(dnscontrol "$1" --config "$INPUT_DNSCONTROL_CONFIG_FILE" --cred "$INPUT_DNSCONTROL_CREDS_FILE")"

echo "$OUTPUT"

# https://github.community/t/set-output-truncates-multiline-strings/16852/3
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "::set-output name=output::$OUTPUT"
