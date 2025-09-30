#!/bin/bash
set -e

# Nom du conteneur PostgreSQL
CONTAINER_NAME=royal_postgres
DB_NAME=royal_pizza
DB_USER=postgres
BACKUP_FILE="backup.sql"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ Aucun fichier $BACKUP_FILE trouvé."
  exit 1
fi

echo "📥 Suppression de la base existante $DB_NAME (si elle existe)..."
docker exec -i $CONTAINER_NAME psql -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME;"
docker exec -i $CONTAINER_NAME psql -U $DB_USER -c "CREATE DATABASE $DB_NAME;"

echo "📥 Restauration de la base $DB_NAME depuis $BACKUP_FILE..."
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME < "$BACKUP_FILE"

echo "✅ Restauration terminée !"
