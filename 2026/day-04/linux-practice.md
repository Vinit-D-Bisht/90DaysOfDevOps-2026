
## 🔹 Process Checks

### 1. ps
**Output:**
PID TTY          TIME CMD
7463 pts/0    00:00:00 zsh
7470 pts/0    00:00:00 zsh
7500 pts/0    00:00:00 zsh
7501 pts/0    00:00:00 zsh
7503 pts/0    00:00:00 gitstatusd-linu

### 2. top
**Output:**
top - 13:50:19 up 3 min,  1 user,  load average: 14.17, 9.25, 3.86
Tasks: 286 total,   2 running, 284 sleeping,   0 stopped,   0 zombie
%Cpu(s): 18.8 us, 12.5 sy,  6.2 ni,  0.0 id, 62.5 wa,  0.0 hi,  0.0 si
MiB Mem :   1968.5 total,     73.9 free,   1373.3 used,    521.4 buff/cache
MiB Swap:   2680.0 total,   1561.1 free,   1118.9 used.    442.8 avail Mem

## 🔹 Service Checks

### 3. systemctl status
**Output:**
ubuntu
	State: running
	Jobs: 0 queued
	Failed: 0 units

### 4. systemctl list-units
**Output :**
proc-sys-fs-binfmt_misc.automount   loaded active running
sys-devices-pci...sr0.device        loaded active plugged
sys-devices-pci...enp0s3.device     loaded active plugged

## 🔹 Log Checks

### 5. journalctl 
**Output:**
Jan 09 19:46:14 ubuntu systemd[2411]: Queued start job for default target Main User Target.
Jan 09 19:46:14 ubuntu systemd[2411]: Created slice User Application Slice.

### 6. sudo tail -n 2 /var/log/syslog
**Output:**
Apr 27 13:51:49 ubuntu systemd[1]: update-notifier-download.service: Deactivated successfully.
Apr 27 13:51:49 ubuntu systemd[1]: Finished Download data for packages that failed at package install time.

##  Mini Troubleshooting (Docker)

### Steps:
1. Check if Docker is running
ps aux | grep docker

2. Check Docker service status
systemctl status docker

3. Check Docker logs
journalctl -u docker

4. Restart Docker service
sudo systemctl restart docker

## 🔹 Key Learnings

- `ps(reports snapshot of current processes)` and `top(display processes)'  help monitor processes  
- `systemctl` is used to manage services  
- `journalctl`  Query the systemd journal  
- Troubleshooting flow: **Process → Service → Logs → Restart
