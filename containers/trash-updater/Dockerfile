# Use alpine base image
FROM ghcr.io/k8s-at-home/ubuntu:latest

USER root

# Install any needed packages

RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    unzip \
    apt-utils \
  && curl -fsSL -o /tmp/app.zip https://github.com/rcdailey/trash-updater/releases/latest/download/trash-linux-x64.zip \
  && unzip -q /tmp/app.zip -d /app \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/ \
  && chown -R kah:kah /app \
  && chmod 755 /app/trash \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

ENV DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp

USER kah

CMD ["sh", "/app/trash"]
