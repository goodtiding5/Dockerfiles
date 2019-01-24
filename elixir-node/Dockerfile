FROM elixir:1.8-alpine

LABEL maintainer="Kenneth Zhao <kenneth.zhao@gmail.com>"

ENV NODE_VERSION=10.15.0
ENV TERM=xterm

RUN set -xe \
&&  buildDeps=' \
    binutils-gold \
    tar \
    xz \
    curl \
    g++ \
    gcc \
    gnupg \
    libgcc \
    linux-headers \
    make \
    python \
    paxctl \
    ' \
&&  apk add --no-cache libstdc++ \
&&  apk add --no-cache --virtual .build-deps $buildDeps \
&&  curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
&&  mkdir -p /usr/src/nodejs \
&&  tar -xC /usr/src/nodejs --strip-components=1 -f "node-v$NODE_VERSION.tar.xz" \
&&  rm -f "node-v$NODE_VERSION.tar.xz" \
&&  cd /usr/src/nodejs \
&&  ./configure \
&&  make -j$(getconf _NPROCESSORS_ONLN) \
&&  make install \
&&  paxctl -cm /usr/local/bin/node \
&&  cd / \
&&  rm -rf /usr/src/nodejs \
&&  apk del .build-deps \
&&  rm -rf /var/cache/apk/* /usr/share/man /tmp/*

CMD [ "sh" ]
