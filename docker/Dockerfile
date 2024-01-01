FROM centos:7

LABEL maintainer="Guilherme Danielli <guilhermedanielli@hotmail.com>"


# Versions
# TO DO: turn this envs into build args
ENV CONFLUENT_PLATFORM_VERSION="6.1"
ENV CONFLUENT_PACKAGE="confluent-6.1.4"
ENV S3_PLUGIN_VERSION="5.5.15"
ENV JAVA_VERSION="1.8.0"

# Set environment variables for Confluent
ENV CONFLUENT_HOME="/opt/confluent"
ENV PATH="${PATH}:${CONFLUENT_HOME}/bin"

# Set environment variables for Java
ENV JAVA_HOME="/usr/lib/jvm/java-${JAVA_VERSION}-openjdk"
ENV PATH="${PATH}:${JAVA_HOME}/bin"

# Set environment variables for JMX Prometheus Exporter
ENV PROMETHEUS_PATH="/opt/prometheus-jmx-exporter/"
ENV KAFKA_OPTS="-javaagent:/opt/prometheus-jmx-exporter/jmx_prometheus_javaagent-0.19.0.jar=9998:/opt/prometheus-jmx-exporter/kafka-connect.yml"

# Worker Configuration Properties
ENV CONNECT_BOOTSTRAP_SERVERS="kafka1:19092" \
    CONNECT_REST_PORT="8083" \
    CONNECT_GROUP_ID="connect-cluster" \
    CONNECT_KEY_CONVERTER="io.confluent.connect.avro.AvroConverter" \
    CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL='http://kafka-schema-registry:8081' \
    CONNECT_VALUE_CONVERTER="io.confluent.connect.avro.AvroConverter" \
    CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL='http://kafka-schema-registry:8081' \
    CONNECT_INTERNAL_KEY_CONVERTER="org.apache.kafka.connect.json.JsonConverter" \
    CONNECT_INTERNAL_VALUE_CONVERTER="org.apache.kafka.connect.json.JsonConverter" \
    CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR="1" \
    CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR="1" \
    CONNECT_STATUS_STORAGE_REPLICATION_FACTOR="1" \
    CONNECT_PLUGIN_PATH="${CONFLUENT_HOME}/share/confluent-hub-components/"

# Set kafka connect internal topics
ENV CONNECT_CONFIG_STORAGE_TOPIC="${CONNECT_GROUP_ID}-config" \
    CONNECT_OFFSET_STORAGE_TOPIC="${CONNECT_GROUP_ID}-offsets" \
    CONNECT_STATUS_STORAGE_TOPIC="${CONNECT_GROUP_ID}-status" 

# Install Java, Confluent Platform and S3 Sink Connector Plug-in
RUN echo "Installing Java and tools"\
    && yum -y update && yum install -y\
    epel-release \
    && yum -y update && yum install -y\
    curl \
    "java-${JAVA_VERSION}-openjdk-devel" \
    jq \
    net-tools \
    && echo "Installing ${CONFLUENT_PACKAGE}" \
    && cd /tmp/ \
    && curl -O "https://packages.confluent.io/archive/${CONFLUENT_PLATFORM_VERSION}/${CONFLUENT_PACKAGE}.tar.gz" \
    && tar -xzf  "${CONFLUENT_PACKAGE}.tar.gz" --directory /opt/ \
    && ln -s "/opt/${CONFLUENT_PACKAGE}/" /opt/confluent \
    && echo "Installing S3 Sink plug-in version ${S3_PLUGIN_VERSION}" \
    && confluent-hub install --no-prompt "confluentinc/kafka-connect-s3:${S3_PLUGIN_VERSION}"\
    && echo "Cleaning up..." \
    && yum clean all \
    && rm -rf /tmp/*

COPY scripts/* /usr/local/bin/

RUN echo "Giving permission to sh files"\
    && chmod +x /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/connect_env_to_props.sh \
    && echo "Creating dir to .properties file" \
    && mkdir -p $CONFLUENT_HOME/etc/kafka-connect/ \
    && echo "Creating dir to prometheus files" \
    && mkdir -p "${PROMETHEUS_PATH}"

COPY prometheus-config/* "${PROMETHEUS_PATH}"

WORKDIR /opt/confluent

EXPOSE 8083 9998

ENTRYPOINT [ "entrypoint.sh" ]
