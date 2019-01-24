# Dockerfile for creating matrix-synapse service

FROM python:3.6-alpine

MAINTAINER Kenneth Zhao <ken@epenguin.com>

ENV UID	1000
ENV GID	1000

RUN apk --no-cache --update --available upgrade \
 && apk add --no-cache --update \
		ca-certificates \
		lcms2 \
		libjpeg-turbo \
		libwebp \
		openjpeg \
		tiff \
		zlib \
		libffi \
		libpq \
 && apk add --no-cache --virtual .build-deps  \
		coreutils \
		dpkg \
		dpkg-dev \
		findutils \
		build-base \
		linux-headers \
		pax-utils \
		lcms2-dev \
		libjpeg-turbo-dev \
		libwebp-dev \
		openjpeg-dev \
		tiff-dev \
		zlib-dev \
		libffi-dev \
		postgresql-dev \
 && pip3 install --no-cache-dir matrix-synapse \
 && apk del .build-deps \
 && apk add --no-cache su-exec \
 && rm -rf /var/cache/apk/* \
	/tmp/*

COPY bin/* /usr/local/bin
RUN mkdir -p /synapse
VOLUME ["/synapse"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["matrix-synapse"]
