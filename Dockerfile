FROM eclipse-temurin:17-jdk-jammy

ARG KAFKA_VERSION=3.7.0
ARG SCALA_VERSION=2.13

ENV KAFKA_HOME=/opt/kafka
ENV PATH="${KAFKA_HOME}/bin:${PATH}"

# Installer les outils nécessaires au téléchargement et à l'extraction
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

ARG KAFKA_VERSION=4.3.1
ARG SCALA_VERSION=2.13


# Télécharger et extraire Kafka
RUN wget -q "https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -O /tmp/kafka.tgz && \
    mkdir -p ${KAFKA_HOME} && \
    tar -xzf /tmp/kafka.tgz -C ${KAFKA_HOME} --strip-components=1 && \
    rm /tmp/kafka.tgz
RUN mkdir -p /opt/kafka/data
WORKDIR ${KAFKA_HOME}

# Ports Kafka (broker) et Zookeeper
EXPOSE 9092 2181

# Par défaut, ce conteneur ne lance rien tout seul —
# on choisit quoi démarrer via docker-compose (zookeeper OU kafka)
# Copier le script d'entrée dans le conteneur
COPY entrypoint.sh /entrypoint.sh

# Donner les droits d'exécution au script
RUN chmod +x /entrypoint.sh

# Définir le script comme point d'entrée unique
ENTRYPOINT ["/entrypoint.sh"]