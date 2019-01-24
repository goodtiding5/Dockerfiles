# Dockerfile for creating matrix-synapse service

FROM ubuntu:bionic

MAINTAINER Kenneth Zhao <ken@epenguin.com>

ENV UID	1000
ENV GID	1000

ARG DEBIAN_FRONTEND=noninteractive

RUN set -xe \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get -qq install --no-install-recommends -y \
	python3 \
	python3-pillow \
	python3-cffi \
	python3-psycopg2 \
	python3-nacl \
	python3-cryptography \
	python3-bcrypt \
	python3-twisted \
	python3-psutil \
	python3-jinja2 \
	python3-requests \
	python3-simplejson \
	python3-yaml \
	python3-netaddr \
	python3-phonenumbers \
	python3-bleach \
	python3-dateutil \
	python3-daemonize \
	python3-defusedxml \
	python3-prometheus-client \
	python3-ldap3 \
	python3-future \
	python3-jsonschema \
	python3-signedjson \
	python3-sortedcontainers \
	python3-unpaddedbase64 \
	python3-pysaml2 \
	python3-frozendict \
	python3-pip \
	python3-setuptools \
	python3-distutils \
	netcat-traditional \
	vim-tiny \
	curl \
	gosu \
 && ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf \
	/var/lib/apt/lists/* \
	/var/lib/dpkg/info/* \
	/root/.cache \
	/var/cache/debconf/* \
	/tmp/*
