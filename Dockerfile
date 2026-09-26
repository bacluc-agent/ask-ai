ARG ALPINE_VERSION=3.24.2

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache ca-certificates curl

# renovate: datasource=github-release-attachments depName=sigoden/aichat
ARG AICHAT_VERSION=v0.30.0
ARG AICHAT_SHA256=6b0cc08c5ceb551dc52bfac2221752f82215be5908c70605d655e9b91ab1557c

RUN curl -f -L -o /tmp/aichat.tar.gz \
    "https://github.com/sigoden/aichat/releases/download/${AICHAT_VERSION}/aichat-${AICHAT_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
    && echo "${AICHAT_SHA256}  /tmp/aichat.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/aichat.tar.gz -C /usr/local/bin aichat \
    && rm /tmp/aichat.tar.gz \
    && chmod +x /usr/local/bin/aichat

ENTRYPOINT ["/usr/local/bin/aichat"]
