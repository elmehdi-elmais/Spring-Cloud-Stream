#!/bin/bash
# Arrête le script si une commande échoue
set -e

CONFIG_FILE="/opt/kafka/config/server.properties"
DATA_DIR="/opt/kafka/data"

# Étape 1 : Créer le dossier s'il n'existe pas
mkdir -p "$DATA_DIR"

# Vérifier si le dossier est déjà formaté (pour éviter d'effacer vos données au redémarrage)
if [ ! -f "$DATA_DIR/meta.properties" ]; then
    echo "=== Première exécution : Formatage du stockage KRaft ==="

    # Étape 2 : Générer l'ID unique
# Étape 2 : Générer l'ID unique avec la syntaxe de Kafka 4.x
CLUSTER_ID=$(/opt/kafka/bin/kafka-storage.sh random-uuid)
    echo "Cluster ID généré : $CLUSTER_ID"

    # Étape 3 : Formater le dossier
    /opt/kafka/bin/kafka-storage.sh format -t "$CLUSTER_ID" -c "$CONFIG_FILE"

    echo "=== Formatage réussi ! ==="
else
    echo "=== Le stockage est déjà formaté, saut de l'étape ==="
fi

# Étape 4 : Lancer Kafka au premier plan (crucial pour que le conteneur Docker reste en vie)
echo "=== Démarrage de Kafka 4.3.1 ==="
exec /opt/kafka/bin/kafka-server-start.sh "$CONFIG_FILE"