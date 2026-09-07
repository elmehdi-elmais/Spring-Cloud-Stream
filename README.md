# Spring-Cloud-Stream

Commande Consumer

docker compose exec broker kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic T1

Commande Producer

docker compose exec broker kafka-console-producer.sh --bootstrap-server localhost:9092 --topic T1



pour Function KStream

docker compose exec broker kafka-console-consumer.sh --bootstrap-server broker:9092 --topic T3 --property print.key=true --property print.value=true --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer