#!/usr/bin/env bats

load bootstrap

PATH="$PATH:$BATS_TEST_DIRNAME/bin"

function setup() {
  export WORKSPACE="${WORKSPACE-"${BATS_TEST_DIRNAME}/.."}"
}

function teardown() {
  rm creds.json

  unset "${!CLOUDFLARE@}"
  unset "${!AWS@}"
  unset "${!DIGITALOCEAN@}"
}

function assert_key_equals {
  key="$1"
  got=$(jq -r "$key" < creds.json)
  expected=$2

  if [[ "$got" != "$expected" ]]
  then
    echo "Expected \"$got\" to equal \"$expected\""
    return 1
  fi
}

function assert_key_not_exists {
  key="$1"
  path=${key%.*}
  last=${key##*.}
  got=$(jq "$path | has(\"$last\")" < creds.json)

  if [[ "$got" == "true" ]]
  then
    echo "Expected key \"$key\" to not exist."
    return 1
  fi
}

# Cloudflare
@test "Cloudflare API user and key are set in credentials file" {
  export CLOUDFLARE_API_USER="info@example.com"
  export CLOUDFLARE_API_KEY="foo"

  run "$WORKSPACE/entrypoint.sh"

  assert_key_equals ".cloudflare.apiuser" "\$CLOUDFLARE_API_USER"
  assert_key_equals ".cloudflare.apikey" "\$CLOUDFLARE_API_KEY"

  assert_key_not_exists ".cloudflare.accountid"
  assert_key_not_exists ".cloudflare.accountname"
}

@test "Cloudflare API user and key, and optional account ID and name are set" {
  export CLOUDFLARE_API_USER="info@example.com"
  export CLOUDFLARE_API_KEY="foo"
  export CLOUDFLARE_ACCOUNT_ID="1"
  export CLOUDFLARE_ACCOUNT_NAME="Contoso"

  run "$WORKSPACE/entrypoint.sh"

  assert_key_equals ".cloudflare.apiuser" "\$CLOUDFLARE_API_USER"
  assert_key_equals ".cloudflare.apikey" "\$CLOUDFLARE_API_KEY"
  assert_key_equals ".cloudflare.accountid" "\$CLOUDFLARE_ACCOUNT_ID"
  assert_key_equals ".cloudflare.accountname" "\$CLOUDFLARE_ACCOUNT_NAME"
}

# DigitalOcean
@test "DigitalOcean token is set in credentials file" {
  export DIGITALOCEAN_OAUTH_TOKEN="secret"

  run "$WORKSPACE/entrypoint.sh"

  assert_key_equals ".digitalocean.token" "\$DIGITALOCEAN_OAUTH_TOKEN"
}

# Route 53
@test "AWS access key ID and secret access key are set in credentials file" {
  export AWS_ACCESS_KEY_ID="access_key_foo"
  export AWS_SECRET_ACCESS_KEY="very_secret"

  run "$WORKSPACE/entrypoint.sh"

  assert_key_equals ".r53.KeyId" "\$AWS_ACCESS_KEY_ID"
  assert_key_equals ".r53.SecretKey" "\$AWS_SECRET_ACCESS_KEY"

  assert_key_not_exists ".r53.Token"
}

@test "AWS access keys, and optional session token are set in credentials file" {
  export AWS_ACCESS_KEY_ID="access_key_foo"
  export AWS_SECRET_ACCESS_KEY="very_secret"
  export AWS_SESSION_TOKEN="session_token"

  run "$WORKSPACE/entrypoint.sh"

  assert_key_equals ".r53.KeyId" "\$AWS_ACCESS_KEY_ID"
  assert_key_equals ".r53.SecretKey" "\$AWS_SECRET_ACCESS_KEY"
  assert_key_equals ".r53.Token" "\$AWS_SESSION_TOKEN"
}
