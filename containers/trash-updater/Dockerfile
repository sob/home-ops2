# Use alpine base image
FROM ghcr.io/k8s-at-home/ubuntu:latest

USER root

ARG VERSION
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

ENV \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  DEBIAN_FRONTEND="noninteractive" \
  API_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
  DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp

RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    unzip \
    tzdata \
    tree \
    tini \
  && curl -fsSL -o /tmp/app.zip https://github.com/rcdailey/trash-updater/releases/latest/download/trash-linux-x64.zip \
  && unzip -q /tmp/app.zip -d /app \
  && chown -R kah:kah /app \
  && chmod 755 /app/trash \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/ \
    /var/tmp/*

USER kah

CMD ["/usr/bin/tini", "--h"]
