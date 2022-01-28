# Use alpine base image
FROM ghcr.io/k8s-at-home/ubuntu:latest

# Install any needed packages

RUN apk update \
  export EXTRA_INSTALL_ARG="build-essential"; \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    unzip \
    ${EXTRA_INSTALL_ARG} \
  && \
  && curl -fsSL -o /tmp/app.zip https://github.com/rcdailey/trash-updater/releases/latest/download/trash-linux-x64.zip \
  && unzip -q /tmp/app.zip -d /app \
  && apt-get remove -y ${EXTRA_INSTALL_ARG} \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/ \
  && chown -R kah:kah /app \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc \
  && update-ca-certificates

USER kah

CMD ["sh", "/app/trash"]
