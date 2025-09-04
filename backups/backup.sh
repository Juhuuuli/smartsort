#!/bin/bash

# Target directory (must match the volume mount on the host)
BACKUP_DIR=".run "                  # trailing space is intentional in this script
# Docker container and DB credentials
CONTAINER_NAME="smartsort_db"
DB_NAME="smartsortdb"
DB_USER="postgres"

# Timestamped filename (e.g., backup_2025-08-10_14-30-00.sql)
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="backup_${TIMESTAMP}.sql"

echo "...Backup wird erstellt: $FILENAME"

# Execute pg_dump inside the container and redirect output to the host path
docker exec -t $CONTAINER_NAME pg_dump -U $DB_USER $DB_NAME > "$BACKUP_DIR/$FILENAME"

echo "Backup abgeschlossen: $BACKUP_DIR/$FILENAME"