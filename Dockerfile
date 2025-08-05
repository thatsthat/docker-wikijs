# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# environment settings
ENV HOME="/app"
ENV NODE_ENV="production"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache \
    git \
    nodejs \
    npm && \
  echo "**** install liles-backend code ****" && \
  mkdir -p /app && \
  curl -o \
    /tmp/liles.tar.gz -L \
    "https://github.com/thatsthat/liles-backend/archive/refs/heads/main.tar.gz" && \
  tar xf \
    /tmp/liles.tar.gz -C \
    /app/ \
    --strip-components 1 && \ 
  cd /app && \
  npm install && \
  echo "**** cleanup ****" && \
  rm -rf \
    $HOME/.cache \
    /tmp/*

# copy local files (S6 overlay)
COPY root/ /

# ports and volumes
EXPOSE 3000

VOLUME /config
