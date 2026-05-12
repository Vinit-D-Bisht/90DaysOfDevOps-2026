#!/bin/bash

set -euo pipefail

LOGFILE="/var/log/maintenance.log"

echo "$(date) : Maintenance started" >> "$LOGFILE"

bash /home/vinit/log_rotate.sh /var/log >> "$LOGFILE" 2>&1

bash /home/vinit/backup.sh /home/vinit/projects /home/vinit/backups >> "$LOGFILE" 2>&1

echo "$(date) : Maintenance completed" >> "$LOGFILE"

