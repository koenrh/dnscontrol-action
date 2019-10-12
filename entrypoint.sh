#!/usr/bin/env bash

set -eo pipefail

# NOTE: DNSControl requires a credentials file on disk. See: https://git.io/fhIb3
echo "{}" > creds.json

add_key () {
  # shellcheck disable=SC2094
  cat <<< "$(jq "$1 = \"$2\"" < creds.json)" > creds.json
}

CLOUDFLARE_API_USER="${INPUT_CLOUDFLAREAPIUSER:-$CLOUDFLARE_API_USER}"
CLOUDFLARE_API_KEY="${INPUT_CLOUDFLAREAPIKEY:-$CLOUDFLARE_API_KEY}"
CLOUDFLARE_ACCOUNT_ID="${INPUT_CLOUDFLAREACCOUNTID:-$CLOUDFLARE_ACCOUNT_ID}"
CLOUDFLARE_ACCOUNT_NAME="${INPUT_CLOUDFLAREACCOUNTNAME:-$CLOUDFLARE_ACCOUNT_NAME}"

DIGITALOCEAN_OAUTH_TOKEN="${INPUT_DIGITALOCEANOAUTHTOKEN:-$DIGITALOCEAN_OAUTH_TOKEN}"

DNSIMPLE_ACCOUNT_ACCESS_TOKEN="${INPUT_DNSIMPLEACCOUNTACCESSTOKEN:-$DNSIMPLE_ACCOUNT_ACCESS_TOKEN}"

GANDI_API_KEY="${INPUT_GANDIAPIKEY:-$GANDI_API_KEY}"

GOOGLE_CLOUD_PROJECT_ID="${INPUT_GOOGLECLOUDPROJECTID:-$GOOGLE_CLOUD_PROJECT_ID}"
GOOGLE_CLOUD_PRIVATE_KEY_ID="${INPUT_GOOGLECLOUDPRIVATEKEYID:-$GOOGLE_CLOUD_PRIVATE_KEY_ID}"
GOOGLE_CLOUD_PRIVATE_KEY="${INPUT_GOOGLECLOUDPRIVATEKEY:-$GOOGLE_CLOUD_PRIVATE_KEY}"
GOOGLE_CLOUD_CLIENT_EMAIL="${INPUT_GOOGLECLOUDCLIENTEMAIL:-$GOOGLE_CLOUD_CLIENT_EMAIL}"
GOOGLE_CLOUD_CLIENT_ID="${INPUT_GOOGLECLOUDCLIENTID:-$GOOGLE_CLOUD_CLIENT_ID}"
GOOGLE_CLOUD_CLIENT_X509_CERT_URL="${INPUT_GOOGLECLOUDCLIENTX509CERTURL:-$GOOGLE_CLOUD_CLIENT_X509_CERT_URL}"

LINODE_ACCESS_TOKEN="${INPUT_LINODEACCESSTOKEN:-$LINODE_ACCESS_TOKEN}"

NAME_COM_API_USER="${INPUT_NAMECOMAPIUSER:-$NAME_COM_API_USER}"
NAME_COM_API_KEY="${INPUT_NAMECOMAPIKEY:-$NAME_COM_API_KEY}"
NAME_COM_API_URL="${INPUT_NAMECOMAPIURL:-$NAME_COM_API_URL}"

NAMECHEAP_API_USER="${INPUT_NAMECOMAPIUSER:-$NAME_COM_API_USER}"
NAMECHEAP_API_KEY="${INPUT_NAMECOMAPIKEY:-$NAME_COM_API_KEY}"
NAMECHEAP_BASE_URL="${INPUT_NAMECOMBASEURL:-$NAME_COM_BASE_URL}"

NSONE_API_KEY="${INPUT_NSONEAPIKEY:-$NSONE_API_KEY}"

OVH_APP_KEY="${INPUT_OVHAPPKEY:-$OVH_APP_KEY}"
OVH_APP_SECRET_KEY="${INPUT_OVHAPPSECRETKEY:-$OVH_APP_SECRET_KEY}"
OVH_CONSUMER_KEY="${INPUT_OVHCONSUMERKEY:-$OVH_CONSUMER_KEY}"

AWS_ACCESS_KEY_ID="${INPUT_AWSACCESSKEYID:-$AWS_ACCESS_KEY_ID}"
AWS_SECRET_ACCESS_KEY="${INPUT_AWSSECRETACCESSKEYID:-$AWS_SECRET_ACCESS_KEY}"
AWS_SESSION_TOKEN="${INPUT_AWSSESSIONTOKEN:-$AWS_SESSION_TOKEN}"

SOFTLAYER_USERNAME="${INPUT_SOFTLAYERUSERNAME:-$SOFTLAYER_USERNAME}"
SOFTLAYER_API_KEY="${INPUT_SOFTLAYERAPIKEY:-$SOFTLAYER_API_KEY}"

VULTR_TOKEN="${INPUT_VULTRTOKEN:-$VULTR_TOKEN}"

if [[ -n "$CLOUDFLARE_API_USER" && -n "$CLOUDFLARE_API_KEY" ]]
then
  # NOTE: https://stackexchange.github.io/dnscontrol/providers/cloudflare
  add_key ".cloudflare.apiuser" "\$CLOUDFLARE_API_USER"
  add_key ".cloudflare.apikey" "\$CLOUDFLARE_API_KEY"

  if [[ -n "$CLOUDFLARE_ACCOUNT_ID" && -n "$CLOUDFLARE_ACCOUNT_NAME" ]]
  then
    add_key ".cloudflare.accountid" "\$CLOUDFLARE_ACCOUNT_ID"
    add_key ".cloudflare.accountname" "\$CLOUDFLARE_ACCOUNT_NAME"
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
