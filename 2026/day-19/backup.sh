#!/bin/bash

set -euo pipefail

SOURCE_DIR="$1"
BACKUP_DIR="$2"
if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Source directory does not exist"
	exit 1
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [ -f "$BACKUP_FILE" ]; then
	echo "Backup created successfully"
	echo "Backup file: $BACKUP_FILE"
	du -sh "$BACKUP_FILE"
else
	echo "Backup failed"
	exit 1
fi

find "$BACKUP_DIR" -name "*.tar.gz" -mtime +14 -delete

