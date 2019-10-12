#!/usr/bin/env bash

set -eo pipefail

# NOTE: DNSControl requires a credentials file on disk. See: https://git.io/fhIb3
echo "{}" > creds.json

add_key () {
  # shellcheck disable=SC2094
  cat <<< "$(jq "$1 = \"$2\"" < creds.json)" > creds.json
}

if [[ -n "$INPUT_CLOUDFLAREAPIUSER" && -n "$INPUT_CLOUDFLAREAPIKEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/cloudflare
  add_key ".cloudflare.apiuser" "\$INPUT_CLOUDFLAREAPIUSER"
  add_key ".cloudflare.apikey" "\$INPUT_CLOUDFLAREAPIKEY"

  if [[ -n "$INPUT_CLOUDFLAREACCOUNTID" && -n "$INPUT_CLOUDFLAREACCOUNTNAME" ]]
  then
    add_key ".cloudflare.accountid" "\$INPUT_CLOUDFLAREACCOUNTID"
    add_key ".cloudflare.accountname" "\$INPUT_CLOUDFLAREACCOUNTNAME"
  fi
fi

if [[ -n "$DIGITALOCEAN_OAUTH_TOKEN" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/digitalocean
  add_key ".digitalocean.token" "\$DIGITALOCEAN_OAUTH_TOKEN"
fi

if [[ -n "$DNSIMPLE_ACCOUNT_ACCESS_TOKEN" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/dnsimple
  add_key ".dnsimple.token" "\$DNSIMPLE_ACCOUNT_ACCESS_TOKEN"
fi

if [[ -n "$GANDI_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/gandi
  add_key ".gandi.apikey" "\$GANDI_API_KEY"
fi

if [[ -n "$GOOGLE_CLOUD_PROJECT_ID" && -n "$GOOGLE_CLOUD_PRIVATE_KEY_ID"
  && -n "$GOOGLE_CLOUD_PRIVATE_KEY" && -n "$GOOGLE_CLOUD_CLIENT_EMAIL"
  && -n "$GOOGLE_CLOUD_CLIENT_ID" && -n "$GOOGLE_CLOUD_CLIENT_X509_CERT_URL" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/gcloud
  add_key ".gcloud.type" "service_account"
  add_key ".gcloud.project_id": "\$GOOGLE_CLOUD_PROJECT_ID",
  add_key ".gcloud.private_key_id": "\$GOOGLE_CLOUD_PRIVATE_KEY_ID",
  add_key ".gcloud.private_key": "\$GOOGLE_CLOUD_PRIVATE_KEY",
  add_key ".gcloud.client_email": "\$GOOGLE_CLOUD_CLIENT_EMAIL",
  add_key ".gcloud.client_id": "\$GOOGLE_CLOUD_CLIENT_ID",
  add_key ".gcloud.auth_uri": "https://accounts.google.com/o/oauth2/auth",
  add_key ".gcloud.token_uri": "https://accounts.google.com/o/oauth2/token",
  add_key ".gcloud.auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  add_key ".gcloud.client_x509_cert_url": "\$GOOGLE_CLOUD_CLIENT_X509_CERT_URL"
fi

if [[ -n "$LINODE_ACCESS_TOKEN" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/linode
  add_key ".linode.token" "\$LINODE_ACCESS_TOKEN"
fi

if [[ -n "$NAME_COM_API_USER" && -n "$NAME_COM_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/name.com<Paste>
  add_key ".[\"name.com\"].apiuser" "\$NAME_COM_API_USER"
  add_key ".[\"name.com\"].apikey" "\$NAME_COM_API_KEY"

  if [[ -n "$NAME_COM_API_URL" ]]
  then
    add_key ".[\"name.com\"].apiurl" "\$NAME_COM_API_URL"
  fi
fi

if [[ -n "$NAMECHEAP_API_USER" && -n "$NAMECHEAP_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/namecheap
  add_key ".namecheap.apiuser" "\$NAMECHEAP_API_USER"
  add_key ".namecheap.apikey" "\$NAMECHEAP_API_KEY"

  if [[ -n "$NAMECHEAP_BASE_URL" ]]
  then
    add_key ".namecheap.BaseURL" "\$NAMECHEAP_BASE_URL"
  fi
fi

if [[ -n "$NSONE_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/ns1
  add_key ".ns1.api_token" "\$NSONE_API_KEY"
fi

if [[ -n "$OVH_APP_KEY" && -n "$OVH_APP_SECRET_KEY" && -n "$OVH_CONSUMER_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/ovh
  add_key ".ovh.app-key" "\$OVH_APP_KEY"
  add_key ".ovh.app-seret-key" "\$OVH_APP_SECRET_KEY"
  add_key ".ovh.consumer-key" "\$OVH_CONSUMER_KEY"
fi

if [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/route53
  add_key ".r53.KeyId" "\$AWS_ACCESS_KEY_ID"
  add_key ".r53.SecretKey" "\$AWS_SECRET_ACCESS_KEY"

  if [[ -n "$AWS_SESSION_TOKEN" ]]
  then
    add_key ".r53.Token" "\$AWS_SESSION_TOKEN"
  fi
fi

if [[ -n "$SOFTLAYER_USERNAME" && -n "$SOFTLAYER_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/softlayer
  add_key ".softlayer.username" "\$SOFTLAYER_USERNAME"
  add_key ".softlayer.api_key" "\$SOFTLAYER_API_KEY"
fi

if [[ -n "$VULTR_TOKEN" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/vultr
  add_key ".vultr.token" "\$VULTR_TOKEN"
fi

sh -c "dnscontrol $*"
