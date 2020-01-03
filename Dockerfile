FROM stackexchange/dnscontrol@sha256:1dcbcbb72d6c1ed273b3479af9ae1ce75ccc3b0f74b91722f8a4a9f1ccacd9e6

LABEL repository="https://github.com/koenrh/dnscontrol-action"
LABEL maintainer="Koen Rouwhorst <info@koenrouwhorst.nl>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

RUN apk add --no-cache bash jq

COPY README.md /

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
