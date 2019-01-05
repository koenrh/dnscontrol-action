FROM stackexchange/dnscontrol:v0.2.8@sha256:8616af71f1767cec6c5191c5eff5fb8c7990fda46652e1c3f2244e395fd2be22

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
