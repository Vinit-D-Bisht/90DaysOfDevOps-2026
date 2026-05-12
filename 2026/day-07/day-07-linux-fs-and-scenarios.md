##  Part 1: Linux File System Hierarchy

### /

```
ls -l /
```
**What it is:** Root directory and starting point of entire filesystem.  
**Contains:** bin, boot, tmp, etc, home, media, var  
**I would use this when:** Navigating the full system structure.


### /home
```
ls -l /home
```
**What it is:** Stores user home directories  
**Contains:** ubuntu  
**I would use this when:** Accessing user files  


### /root
```
ls -l /root
```
**What it is:** Home directory for root user  
**Contains:** snap, vboxpostinstall.sh  
**I would use this when:** Working with admin-level files  


### /etc
```
ls -l /etc
```
**What it is:** Configuration files  
**Contains:** NetworkManager, passwd, hostname, hostid  
**I would use this when:** Modifying system configurations  


### /var/log
```
ls -l /var/log
```
**What it is:** Directory containing logs  
**Contains:** alternatives.log, auth.log, journal  
**I would use this when:** Debugging issues and checking logs  


### /tmp
```
ls -l /tmp
```
**What it is:** Temporary files  
**Contains:** Temporary folders/files  
**I would use this when:** Storing temporary data  


### /bin
```
ls -l /bin
```
**What it is:** Essential binaries  
**Contains:** ls, cp, mv  
**I would use this when:** Running basic commands  


### /usr/bin
```
ls -l /usr/bin
```
**What it is:** User-level binaries  
**Contains:** git, python, sudo  
**I would use this when:** Running installed programs  


### /opt
```
ls -l /opt
```
**What it is:** Optional software directory  
**Contains:** google, containerd  
**I would use this when:** Installing third-party/custom software  


##  Part 2: Scenario-Based Practice

### Scenario 1: Service Not Starting
```
A web application service called 'myapp' failed to start after a server reboot.
```
Step 1:  systemctl status myapp
Why: Check if service is running or failed  

Step 2:  journalctl -u myapp -n 10
Why: View recent logs for errors  

Step 3:  systemctl is-enabled myapp
Why: Check if service starts on boot  

Step 4:  systemctl restart myapp
Why: Attempt to restart service  


### Scenario 2: High CPU Usage
```
Your manager reports that the application server is slow.
You SSH into the server. What commands would you run to identify
```

Step 1:  top
Why: Monitor live CPU usage  

Step 2:  ps aux --sort=-%cpu | head -6
Why: Identify processes consuming high CPU  


### Scenario 3: Finding Service Logs
```
A developer asks: "Where are the logs for the 'docker' service?
```

Step 1:  systemctl status docker
Why: Check service status  

Step 2:  journalctl -u docker -n 10 -f
Why: View and follow recent logs  


### Scenario 4: File Permissions Issue
```
A script at /home/user/backup.sh is not executing.
When you run it: ./backup.sh
You get: "Permission denied"
```

Step 1:  ls -l /home/user/backup.sh
Why: Check file permissions  

Step 2:  chmod +x /home/user/backup.sh
Why: Add execute permission  

Step 3:  ls -l /home/user/backup.sh
Why: Verify permission change  

Step 4:  ./backup.sh
Why: Execute the script  


##  Key Learnings

- `/etc` : contains configuration files  
- `/var/log` : logs for debugging  
- `/home` :  users data  
- `systemctl + journalctl` : service troubleshooting/monitoring  
- `top + ps` : performance monitoring  
- `chmod` : fixing permission issues  
