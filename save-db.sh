#!/bin/bash
set -e

# Nom du conteneur PostgreSQL
CONTAINER_NAME=royal_postgres
DB_NAME=royal_pizza
DB_USER=postgres

# Fichier de sortie (backup horodaté pour éviter l'écrasement)
BACKUP_FILE="backup_$(date '+%Y-%m-%d_%H-%M-%S').sql"

echo "📦 Sauvegarde de la base $DB_NAME..."
docker exec -t $CONTAINER_NAME pg_dump -U $DB_USER $DB_NAME > "$BACKUP_FILE"

echo "✅ Sauvegarde terminée : $BACKUP_FILE"
