#!/usr/bin/env bash

set -euo pipefail

# NOTE: DNSControl requires a credentials file on disk. See: https://git.io/fhIb3
echo "{}" > creds.json

add_key () {
  # shellcheck disable=SC2094
  cat <<< "$(jq "$1 = \"$2\"" < creds.json)" > creds.json
}

if [[ -n "$CLOUDFLARE_API_USER" && -n "$CLOUDFLARE_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/cloudflare
  add_key ".cloudflare.apiuser" "\$CLOUDFLARE_API_USER"
  add_key ".cloudflare.apikey" "\$CLOUDFLARE_API_KEY"

elif [[ -n "$DIGITALOCEAN_OAUTH_TOKEN" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/digitalocean
  add_key ".digitalocean.token" "\$DIGITALOCEAN_OAUTH_TOKEN"

elif [[ -n "$DNSIMPLE_ACCOUNT_ACCESS_TOKEN" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/dnsimple
  add_key ".dnsimple.token" "\$DNSIMPLE_ACCOUNT_ACCESS_TOKEN"

elif [[ -n "$LINODE_ACCESS_TOKEN" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/linode
  add_key ".linode.token" "\$LINODE_ACCESS_TOKEN"

elif [[ -n "$NSONE_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/ns1
  add_key ".ns1.api_token" "\$NSONE_API_KEY"

elif [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/route53
  add_key ".r53.KeyId" "\$AWS_ACCESS_KEY_ID"
  add_key ".r53.SecretKey" "\$AWS_SECRET_ACCESS_KEY"

  if [[ -n "$AWS_SESSION_TOKEN" ]]
  then
    add_key ".r53.Token" "\$AWS_SESSION_TOKEN"
  fi
fi

sh -c "dnscontrol $*"
