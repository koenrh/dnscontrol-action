FROM alpine:3.17.2@sha256:ff6bdca1701f3a8a67e328815ff2346b0e4067d32ec36b7992c1fdc001dc8517

LABEL repository="https://github.com/koenrh/dnscontrol-action"
LABEL maintainer="Koen Rouwhorst <info@koenrouwhorst.nl>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

ENV DNSCONTROL_VERSION="3.27.1"
ENV DNSCONTROL_CHECKSUM="5ef737707a49e73c02ad57eb98953a667def224cdf0b0e04b741d26df2fdcdd6"

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates curl libc6-compat

RUN curl -sL "https://github.com/StackExchange/dnscontrol/releases/download/v$DNSCONTROL_VERSION/dnscontrol-Linux" \
  -o dnscontrol && \
  echo "$DNSCONTROL_CHECKSUM  dnscontrol" | sha256sum -c - && \
  chmod +x dnscontrol && \
  mv dnscontrol /usr/local/bin/dnscontrol

RUN ["dnscontrol", "version"]

COPY README.md entrypoint.sh bin/filter-preview-output.sh /
ENTRYPOINT ["/entrypoint.sh"]
