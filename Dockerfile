# Forked from https://github.com/maver1ck/druid-docker

FROM anapsix/alpine-java:8_server-jre_unlimited

LABEL MAINTAINER "Khwunchai Jaengsawang <khwunchai.j@ku.th>"

ENV DRUID_VERSION      0.13.0

# Druid env variable
ENV DRUID_XMX          '-'
ENV DRUID_XMS          '-'
ENV DRUID_NEWSIZE      '-'
ENV DRUID_MAXNEWSIZE   '-'
ENV DRUID_HOSTNAME     '-'
ENV DRUID_LOGLEVEL     '-'
ENV DRUID_EXTENSIONS   '-'
ENV DRUID_USE_CONTAINER_IP '-'
ENV DRUID_SEGMENTCACHE_LOCATION  '-'
ENV DRUID_DEEPSTORAGE_LOCAL_DIR  '-'

RUN apk update \
    && apk add --no-cache bash curl \
    && mkdir /tmp/druid \
    && curl \
    http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz | tar -xzf - -C /opt \
    && ln -s /opt/druid-$DRUID_VERSION /opt/druid
RUN curl http://static.druid.io/artifacts/releases/mysql-metadata-storage-$DRUID_VERSION.tar.gz | tar -xzf - -C /opt/druid/extensions

COPY conf /opt/druid/conf
COPY start-druid.sh /start-druid.sh

ENTRYPOINT ["/start-druid.sh"]
