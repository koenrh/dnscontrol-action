FROM stackexchange/dnscontrol:4.1.1@sha256:0f71c67201ca7d23fb9fa75c6afd263eab8f6958b14ff3a56c89d4c4e9c52f2f

LABEL repository="https://github.com/Jniklas2/DNSControl-Action"
LABEL maintainer="Jniklas2 <github@sl.crcr.tech>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates curl libc6-compat

RUN ["dnscontrol", "version"]

COPY README.md entrypoint.sh bin/filter-preview-output.sh /
ENTRYPOINT ["/entrypoint.sh"]
