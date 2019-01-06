#!/usr/bin/env bats

load bootstrap

PATH="$PATH:$BATS_TEST_DIRNAME/bin"

function setup() {
  export WORKSPACE="${WORKSPACE-"${BATS_TEST_DIRNAME}/.."}"
}

function teardown() {
  rm creds.json
}

function assert_jq_eq {
  MATCH=$2
  RESULT=$(jq -r "$1" < creds.json)

  if [[ "$RESULT" != "$MATCH" ]]
  then
    echo "Expected match "'"'"$MATCH"'"'" was not found in "'"'"$RES"'"'
    return 1
  fi
}

@test "cloudflare default" {
  export CLOUDFLARE_API_USER="info@example.com"
  export CLOUDFLARE_API_KEY="foo"

  run $WORKSPACE/entrypoint.sh

  assert_jq_eq ".cloudflare.apiuser" "\$CLOUDFLARE_API_USER"
  assert_jq_eq ".cloudflare.apikey" "\$CLOUDFLARE_API_KEY"
}

@test "Cloudflare account ID and name only set when both are specified" {
  export CLOUDFLARE_API_USER="info@example.com"
  export CLOUDFLARE_API_KEY="foo"
  export CLOUDFLARE_ACCOUNT_ID="1"
  export CLOUDFLARE_ACCOUNT_NAME="Contoso"

  run $WORKSPACE/entrypoint.sh

  assert_jq_eq ".cloudflare.apiuser" "\$CLOUDFLARE_API_USER"
  assert_jq_eq ".cloudflare.apikey" "\$CLOUDFLARE_API_KEY"
  assert_jq_eq ".cloudflare.accountid" "\$CLOUDFLARE_ACCOUNT_ID"
  assert_jq_eq ".cloudflare.accountname" "\$CLOUDFLARE_ACCOUNT_NAME"
}
