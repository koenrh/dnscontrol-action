FROM stackexchange/dnscontrol:4.1.13@sha256:013f15cb13d551ae20727bc315fc437a2c77727b7167f238e68a1272a8cb51fb

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
