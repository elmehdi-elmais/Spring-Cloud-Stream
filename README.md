# Spring-Cloud-Stream

Projet de démonstration Spring Cloud Stream avec Kafka (mode KRaft), incluant un binder Kafka classique (Consumer/Producer) et un binder Kafka Streams (KStream).

## Prérequis

- Docker & Docker Compose
- Java 23
- Maven

## Démarrage de l'infrastructure Kafka

```bash
docker compose up
```

## Commandes utiles

### Consumer (topic simple)

Permet de lire les messages publiés sur le topic `T1` :

```bash
docker compose exec broker kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic T1
```

### Producer (topic simple)

Permet de publier manuellement des messages sur le topic `T1` :

```bash
docker compose exec broker kafka-console-producer.sh --bootstrap-server localhost:9092 --topic T1
```

### Consumer pour la Function KStream

Le traitement Kafka Streams (`kStreamFunction`) lit depuis `T1` et écrit le résultat agrégé sur le topic `T3`, avec une clé de type `String` et une valeur de type `Long`.

```bash
docker compose exec broker kafka-console-consumer.sh \
  --bootstrap-server broker:9092 \
  --topic T3 \
  --property print.key=true \
  --property print.value=true \
  --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
  --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer
```

## Architecture

```
Producer (T1) → pageEventConsumer (Consumer)
Producer (T1) → kStreamFunction (KStream) → Topic (T3)
```

## Configuration

Les bindings Spring Cloud Stream sont définis dans `application.properties` :

```properties
spring.cloud.stream.kafka.binder.brokers=localhost:9092
spring.cloud.stream.bindings.pageEventConsumer-in-0.destination=T1
spring.cloud.stream.bindings.pageEventSupplier-out-0.destination=T2
spring.cloud.stream.bindings.kStreamFunction-in-0.destination=T2
spring.cloud.stream.bindings.kStreamFunction-out-0.destination=T3
spring.cloud.stream.bindings.pageEventSupplier-out-0.producer.poller.fixed-delay=200
spring.cloud.stream.kafka.streams.binder.configuration.commit.interval.ms=1000
spring.cloud.function.definition=pageEventConsumer;pageEventSupplier;kStreamFunction
```