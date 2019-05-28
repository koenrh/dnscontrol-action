FROM stackexchange/dnscontrol:v2.9@sha256:36354bc0e988cdc0fd4c9e69dee3408ca6f98014ea1c7220dff1362c1799a904

LABEL repository="https://github.com/koenrh/dnscontrol-action"
LABEL maintainer="Koen Rouwhorst <info@koenrouwhorst.nl>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

RUN apk add --no-cache \
  bash~=4 \
  jq~=1.6

COPY README.md /

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
