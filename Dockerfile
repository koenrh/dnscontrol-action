FROM golang:1.18.2-alpine@sha256:fc40d64be9455a422d513f216acbdd015332275f250c397421c810d2df9c41ae AS install

LABEL repository="https://github.com/koenrh/dnscontrol-action"
LABEL maintainer="Koen Rouwhorst <info@koenrouwhorst.nl>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

ENV DNSCONTROL_VERSION="3.16.0"

RUN go install -ldflags="-s -w" github.com/StackExchange/dnscontrol/v3@v${DNSCONTROL_VERSION}

FROM alpine:3.15@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates

COPY --from=install /go/bin/dnscontrol /usr/local/bin/dnscontrol

RUN ["dnscontrol", "version"]

COPY README.md entrypoint.sh bin/filter-preview-output.sh /
ENTRYPOINT ["/entrypoint.sh"]
