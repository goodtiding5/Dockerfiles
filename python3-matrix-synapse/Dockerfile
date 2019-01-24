# Dockerfile for creating matrix-synapse service

FROM python3-for-matrix:bionic-latest

MAINTAINER Kenneth Zhao <ken@epenguin.com>

ENV UID	1000
ENV GID	1000

RUN pip3 install --no-cache-dir matrix-synapse treq==18.6.0

ADD bin  /opt/bin
ADD conf /opt/conf
RUN cd /usr/local/bin && ln -s /opt/bin/newuser .

RUN mkdir -p /synapse
VOLUME ["/synapse"]

ENTRYPOINT ["/opt/bin/docker-entrypoint.sh"]
CMD ["matrix-synapse"]
