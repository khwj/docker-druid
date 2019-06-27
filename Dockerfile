# Forked from https://github.com/maver1ck/druid-docker

FROM openjdk:8-jre-alpine

LABEL MAINTAINER "Khwunchai Jaengsawang <khwunchai.j@ku.th>"

ARG MYSQL_CONNECTOR_VERSION=5.1.38
ARG DRUID_VERSION=0.13.0-incubating
ARG HADOOP_VERSION=2.9.0

RUN apk update \
  && apk add --no-cache bash curl tar \
  && curl \
  https://www-us.apache.org/dist/incubator/druid/$DRUID_VERSION/apache-druid-$DRUID_VERSION-bin.tar.gz \
  | tar -xzf - -C /opt \
  && ln -s /opt/apache-druid-$DRUID_VERSION /opt/druid \
  && mkdir -p /tmp/druid /opt/druid/extensions/druid-hdfs-storage /opt/druid/extensions/mysql-metadata-storage \
  && curl -Lo /opt/druid/extensions/mysql-metadata-storage/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
  http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar \
  && curl -Lo /opt/druid/extensions/druid-hdfs-storage/gcs-connector-hadoop2-latest.jar \
  https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar

COPY conf /opt/druid/conf
COPY start-druid.sh /start-druid.sh

RUN java \
  -cp "/opt/druid/lib/*" \
  -Ddruid.extensions.directory="/opt/druid/extensions" \
  -Ddruid.extensions.hadoopDependenciesDir="/opt/druid/hadoop-dependencies" \
  org.apache.druid.cli.Main tools pull-deps \
  --no-default-hadoop \
  -c "org.apache.druid.extensions.contrib:druid-google-extensions:$DRUID_VERSION" \
  -c "org.apache.druid.extensions.contrib:druid-time-min-max:$DRUID_VERSION" \
  -c "org.apache.druid.extensions.contrib:materialized-view-maintenance:$DRUID_VERSION" \
  -c "org.apache.druid.extensions.contrib:materialized-view-selection:$DRUID_VERSION" \
  -h "org.apache.hadoop:hadoop-client:$HADOOP_VERSION"

CMD ["/start-druid.sh"]
