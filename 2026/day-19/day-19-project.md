# Task 1: Log Rotation Script
### log_rotate.sh
```bash
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
```

###Output
```bash
./log_rotate.sh /var/log
Compressed files: 7
Deleted files: 29
```


# Task 2: Server Backup Script
### backup.sh
```bash
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
```

###Output
```bash
./backup.sh /home/vinit/projects /home/vinit/backups

Backup created successfully
Backup file: /home/vinit/backups/backup-2026-05-12-13-20-10.tar.gz
24M	/home/vinit/backups/backup-2026-05-12-13-20-10.tar.gz
```


# Task 3: Crontab
### Current Scheduled Jobs
```bash
crontab -l
```

### Cron Entries
#### Run log_rotate.sh every day at 2 AM
```bash
0 2 * * * /home/vinit/log_rotate.sh /var/log
```
#### Run backup.sh every Sunday at 3 AM
```bash
0 3 * * 0 /home/vinit/backup.sh /home/vinit/projects /home/vinit/backups
```
#### Run health check script every 5 minutes
```bash
*/5 * * * * /home/vinit/health_check.sh
```


# Task 4: Scheduled Maintenance Script
### maintenance.sh
```bash
#!/bin/bash

set -euo pipefail

LOGFILE="/var/log/maintenance.log"

echo "$(date) : Maintenance started" >> "$LOGFILE"

bash /home/vinit/log_rotate.sh /var/log >> "$LOGFILE" 2>&1

bash /home/vinit/backup.sh /home/vinit/projects /home/vinit/backups >> "$LOGFILE" 2>&1

echo "$(date) : Maintenance completed" >> "$LOGFILE"
```
### Cron Entry
```bash
0 1 * * * /home/vinit/maintenance.sh
```

###Log Output
```bash
Tue May 12 01:00:01 IST 2026 : Maintenance started
Compressed files: 6
Deleted files: 1
Backup created successfully
Backup file: /home/vinit/backups/backup-2026-05-12-01-00-02.tar.gz
Tue May 12 01:00:10 IST 2026 : Maintenance completed
```


# What I Learned
- Shell scripts can automate log cleanup, backups, and maintenance tasks efficiently.
- Cron jobs help schedule scripts automatically at specific times.
- Error handling with `set -euo pipefail` makes scripts safer and more reliable.
