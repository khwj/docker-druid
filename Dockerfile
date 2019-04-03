# Forked from https://github.com/maver1ck/druid-docker

FROM anapsix/alpine-java:8_server-jre_unlimited

LABEL MAINTAINER "Khwunchai Jaengsawang <khwunchai.j@ku.th>"

ARG MYSQL_CONNECTOR_VERSION=5.1.38
ENV DRUID_VERSION=0.13.0-incubating

RUN apk update \
    && apk add --no-cache bash curl \
    && mkdir /tmp/druid \
    && curl https://www-eu.apache.org/dist/incubator/druid/$DRUID_VERSION/apache-druid-$DRUID_VERSION-src.tar.gz \
      | tar -xzf - -C /opt \
    && ln -s /opt/apache-druid-$DRUID_VERSION-src /opt/druid \
    # && curl http://static.druid.io/artifacts/releases/mysql-metadata-storage-$DRUID_VERSION.tar.gz \
    && mkdir -p /opt/druid/extensions/mysql-metadata-storage \
    && curl -o /opt/druid/extensions/mysql-metadata-storage/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
      http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
    # && mkdir -p /opt/druid/extensions/mysql-metadata-storage \
    # && curl -o /opt/druid/extensions/mysql-metadata-storage/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
    #   http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
    && mkdir -p /opt/druid/extensions/druid-google-extensions \
    && curl -o /opt/druid/extensions/druid-google-extensions/druid-google-extensions-$DRUID_VERSION.jar \
      http://central.maven.org/maven2/org/apache/druid/druid-api/$DRUID_VERSION/druid-api-$DRUID_VERSION.jar

COPY conf /opt/druid/conf
COPY start-druid.sh /start-druid.sh

ENTRYPOINT ["/start-druid.sh"]
