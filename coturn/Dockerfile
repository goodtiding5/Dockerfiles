# Dockerfile for creating coturn service

FROM alpine:edge

MAINTAINER Kenneth Zhao <ken@epenguin.com>

ENV UID	1000
ENV GID	1000

ENV SECRET	""
ENV DOMAIN	"domain.ltd"
ENV REALM	"turn.domain.ltd"
ENV CERT	"/ssl/tls.crt"
ENV KEY		"/ssl/tls.key"
ENV DHFILE	"/ssl/tls.dh"

RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
	coturn \
	curl \
	su-exec \
 && rm -rf /var/cache/apk/* \
	/tmp/*

ADD bin /opt/bin/

EXPOSE 3478/tcp 3478/udp 3479/tcp 3479/udp
EXPOSE 5349/tcp 5349/udp 5350/tcp 5350/udp

RUN mkdir -p /coturn /ssl
VOLUME ["/coturn", "/ssl"]

ENTRYPOINT ["/opt/bin/docker-entrypoint.sh"]
CMD ["turnserver"]
