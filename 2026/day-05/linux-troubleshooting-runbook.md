## Target Service / Process
Docker 

## Environment Basics

### System Info
uname -a

**Output:**
Linux ubuntu 6.8.0-110-generic #110~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Fri Mar 27 12:43:08 UTC x86_64 x86_64 x86_64 GNU/Linux

### OS Details
lsb_release -a

**Output:**
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.5 LTS
Release:        22.04
Codename:       jammy

## Filesystem Sanity

###  Create temp directory
mkdir /tmp/Temprunbook

### Copy file and verify
cp /etc/hosts /tmp/Temprunbook/hosts-copy && ls -l /tmp/Temprunbook

**Output:**
total 4
-rw-r--r-- 1 ubuntu ubuntu 403 Apr 28 11:48 hosts-copy

**Observation:**
Filesystem is writable and working correctly.

## Snapshot: CPU & Memory

### Check system usage
top

**Output :**
top - 11:49:03 up 18 min,  1 user,  load average: 0.76, 0.93, 1.65
Tasks: 273 total,   1 running, 272 sleeping,   0 stopped,   0 zombie
%Cpu(s):  9.1 us,  0.0 sy,  0.0 ni, 81.8 id,  9.1 wa
MiB Mem :   1968.5 total,     63.6 free,   1388.7 used,    516.2 buff/cache
MiB Swap:   2680.0 total,   1654.3 free,   1025.7 used.    424.0 avail Memfree -h

**Output:**
               total        used        free      shared  buff/cache   available
Mem:           1.9Gi       1.4Gi       104Mi       4.0Mi       474Mi       422Mi
Swap:          2.6Gi       1.0Gi       1.6Gi

**Observation:**
Network connectivity is working properly.


## Logs Reviewed
sudo journalctl -u docker -n 5

**Output:**
Apr 28 11:58:54 ubuntu dockerd[15191]: time="2026-04-28T11:58:54..."
Apr 28 11:58:54 ubuntu systemd[1]: Started Docker Application Container Engine

**Observation:**
Docker restarted successfully.

## Quick Findings / Conclusions

- Docker service is running normally  
- CPU and memory usage are stable  
- Filesystem is working correctly  
- Network connectivity is healthy  
- Logs show no recent errors  

##If This Worsens (Next Steps)

1. Restart Docker service
sudo systemctl restart docker

2. Check detailed logs
sudo journalctl -u docker -n 5

3. Identify high resource usage
top -i

