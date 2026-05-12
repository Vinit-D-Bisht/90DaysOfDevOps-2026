#!/bin/bash

set -euo pipefail

LOG_DIR="$1"

if [ ! -d "$LOG_DIR" ]; then
	echo "Error: Directory does not exist"
	exit 1
fi

compressed=$(find "$LOG_DIR" -name "*.log" -mtime +7 | wc -l)

find "$LOG_DIR" -name "*.log" -mtime +7 -exec gzip {} \;

deleted=$(find "$LOG_DIR" -name "*.gz" -mtime +30 | wc -l)

find "$LOG_DIR" -name "*.gz" -mtime +30 -delete

echo "Compressed files: $compressed"
echo "Deleted files: $deleted"

