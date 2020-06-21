#!/usr/bin/env bash

set -eo pipefail

OUTPUT=`sh -c "dnscontrol $1"`

echo "$OUTPUT"

# https://github.community/t/set-output-truncates-multiline-strings/16852/3
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "::set-output name=output::$OUTPUT"
