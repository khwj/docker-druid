# Forked from https://github.com/maver1ck/druid-docker

FROM anapsix/alpine-java:8_server-jre_unlimited

LABEL MAINTAINER "Khwunchai Jaengsawang <khwunchai.j@ku.th>"

ARG MYSQL_CONNECTOR_VERSION=5.1.38
ENV DRUID_VERSION=0.14.0-incubating

RUN apk update \
  && apk add --no-cache bash curl \
  && mkdir /tmp/druid \
  && curl https://www-us.apache.org/dist/incubator/druid/$DRUID_VERSION/apache-druid-$DRUID_VERSION-bin.tar.gz \
  | tar -xzf - -C /opt \
  && ln -s /opt/apache-druid-$DRUID_VERSION /opt/druid \
  && mkdir -p /opt/druid/extensions/mysql-metadata-storage \
  && curl -o /opt/druid/extensions/mysql-metadata-storage/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
  http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar

COPY conf /opt/druid/conf
COPY start-druid.sh /start-druid.sh

RUN java \
  -cp "/opt/druid/lib/*" \
  -Ddruid.extensions.directory="/opt/druid/extensions" \
  -Ddruid.extensions.hadoopDependenciesDir="/opt/druid/hadoop-dependencies" \
  org.apache.druid.cli.Main tools pull-deps \
  --no-default-hadoop \
  -c "org.apache.druid.extensions.contrib:druid-google-extensions:$DRUID_VERSION"

CMD ["/start-druid.sh"]