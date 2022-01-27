# Use alpine base image
FROM alpine

# Install any needed packages

RUN apk update \
  && apk add --no-cache curl git \
  && curl -sLO https://github.com/rcdailey/trash-updater/releases/latest/download/trash-linux-x64.zip \
  && unzip trash-linux-x64.zip \
  && mkdir -p /app \
  && mv trash /app/ \
  && chmod +x /app/trash

# Define environment variable
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG C.UTF-8
ENV TZ America/Los_Angeles

CMD ["sh", "/app/trash"]
