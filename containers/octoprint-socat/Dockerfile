ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

FROM octoprint/octoprint:${VERSION}

RUN apt-get update && apt-get install -y \
  socat

COPY ./containers/octoprint-socat/root/ /
ENV ENABLE_SOCAT true
ENV SOCAT_TARGET 127.0.0.1:2000
