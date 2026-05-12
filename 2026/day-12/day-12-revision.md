##  Mindset & Plan

- Continued following structured daily practice  
- Focus remains on Linux fundamentals and real hands-on  
- Plan is working well → no major changes needed  


##  Processes & Services (Re-run)

### Commands used:
```
ps aux | head -5
systemctl status docker
journalctl -u docker -n 5
```

### Observations:
- `ps` shows running processes with PID and CPU usage  
- `systemctl status` confirms service is active/running  
- `journalctl` shows logs (useful for debugging issues)  


##  File Skills Practice

### Commands used:
```
echo "revision test" >> notes.txt
chmod 640 notes.txt
ls -l notes.txt
```

### Observations:
- `echo >>` appends content to file  
- `chmod 640` restricts access properly  
- `ls -l` helps verify permissions instantly  


##  Cheat Sheet (Top 5 Commands)

1. `ls -l` → check permissions & ownership quickly  
2. `ps aux` → see running processes  
3. `systemctl status <service>` → check service health  
4. `chmod` → change file permissions  
5. `chown` → change file ownership  


##  User/Group Practice

### Commands used:
```
sudo useradd testuser
id testuser
sudo chown testuser notes.txt
ls -l notes.txt
```

### Observations:
- User created successfully  
- Ownership change reflected immediately  
- Verified using `ls -l`  


## Mini Self-Check

### 1) 3 most useful commands
- `ls -l` → instant view of permissions & ownership  
- `systemctl status` → quick service health check  
- `ps aux` → identify running processes  


### 2) Check service health
```
systemctl status docker
ps aux | grep docker
journalctl -u docker -n 10
```


### 3) Safe ownership & permission change
```
sudo chown user:group file
chmod 640 file
```

Example:
```
sudo chown ubuntu:ubuntu notes.txt
chmod 640 notes.txt
```


### 4) Focus for next 3 days
- Improve speed with Linux commands  
- Practice troubleshooting faster  
- Learn Docker and container basics  


##  Key Takeaways

- Linux fundamentals are getting clearer with practice  
- Permissions and ownership are critical in real systems  
- Logs are essential for debugging  
- Consistency is Key
