##  Commands Used

### Connecting to server
```
ssh -i .\nginx.pem ubuntu@<EC2-ip>
```

### Update system
```
sudo apt-get update
```

### Installing Nginx and docker
```
sudo apt install nginx -y
sudo apt install docker.io -y
```

### Start and enable Nginx and Docker
### Nginx
  ```
  sudo systemctl start nginx
  sudo systemctl enable nginx
  ```
### Docker
  ```
  sudo systemctl start docker
  sudo systemctl enable docker
  ```

### Check Nginx current status
```
systemctl status nginx
```

### View logs
```
sudo tail -n 5 /var/log/nginx/access.log
```

### Save logs to file
```
sudo cp /var/log/nginx/access.log ~/nginx-logs.txt
```

### Fixing file permission problem
```
sudo chown ubuntu:ubuntu nginx-logs.txt
```

### Download logs to local machine
```
scp -i .\nginx.pem ubuntu@<EC2-ip>:~/nginx-logs.txt .
```


##  Challenges Faced

### 1. SSH key not working
- Issue: File name had spaces and incorrect path  
- Fix: Renamed file and used correct path (`.\nginx.pem`)
- "nginx runner.pem" to "nginx.pem"

---

### 2. Could not resolve hostname
- Issue: Used `<public-ip>` instead of actual IP
- Fix: Replaced with real public IPv4 address

---

### 3. SCP not working
- Issue: Tried Running `scp` inside EC2 instead of local machine
- Fix: Ran command from local terminal where .pem file was present

---

### 4. File not found during SCP
- Issue: `nginx-logs.txt` was not created
- Fix: Created file using `cp /var/log/nginx/access.log`

---

### 5. Permission denied for log file
- Issue: File owned by root
- Fix: Used `sudo chown ubuntu:ubuntu nginx-logs.txt`

---

##  What I Learned

- How to launch and connect to a cloud server using SSH  
- How to install and manage Nginx using systemctl  
- Importance of security groups (port 22 for SSH, port 80 for HTTP)  
- How to view and extract logs from `/var/log/nginx`  
- Difference between local machine and remote server while using SCP  
- File ownership and permissions in Linux  

---

##  Verification

- Successfully connected to EC2 via SSH  
- Nginx + Docker installed and running  
- Webpage accessible via public IP  
- Logs extracted and downloaded locally  

---
