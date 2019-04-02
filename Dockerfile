# Forked from https://github.com/maver1ck/druid-docker

FROM anapsix/alpine-java:8_server-jre_unlimited

LABEL MAINTAINER "Khwunchai Jaengsawang <khwunchai.j@ku.th>"

ARG MYSQL_CONNECTOR_VERSION=5.1.38
ENV DRUID_VERSION=0.12.3

# Druid env variable
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
    && ln -s /opt/druid-$DRUID_VERSION /opt/druid \
    && curl http://static.druid.io/artifacts/releases/mysql-metadata-storage-$DRUID_VERSION.tar.gz \
      | tar -xzf - -C /opt/druid/extensions \
    # && mkdir -p /opt/druid/extensions/mysql-metadata-storage \
    # && curl -o /opt/druid/extensions/mysql-metadata-storage/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
      # http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
    && mkdir -p /opt/druid/extensions/druid-distinctcount \
    && curl -o /opt/druid/extensions/druid-distinctcount/druid-distinctcount-$DRUID_VERSION.jar \
      http://central.maven.org/maven2/io/druid/extensions/contrib/druid-distinctcount/$DRUID_VERSION/druid-distinctcount-$DRUID_VERSION.jar \
    && mkdir -p /opt/druid/extensions/druid-google-extensions \
    && curl -o /opt/druid/extensions/druid-google-extensions/druid-google-extensions-$DRUID_VERSION.jar \
      http://central.maven.org/maven2/io/druid/extensions/contrib/druid-google-extensions/$DRUID_VERSION/druid-google-extensions-$DRUID_VERSION.jar

COPY conf /opt/druid/conf
COPY start-druid.sh /start-druid.sh

ENTRYPOINT ["/start-druid.sh"]
