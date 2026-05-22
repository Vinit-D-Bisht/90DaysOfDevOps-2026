# Task 1: What is Docker?

## What is a Container?

A container is a lightweight package that contains:
Application code,Dependencies,Libraries, Runtime environment

Containers help applications run consistently across different systems without compatibility issues.

### Why Do We Need Containers?

For  Consistent environments,Faster deployments , Lightweight compared to VMs, Easier scaling, Better portability, Simplified DevOps workflows  

---

## Containers vs Virtual Machines

| Containers             | Virtual Machines           |
|------------------------|----------------------------|
| Lightweight            | Heavyweight                |
| Share host OS kernel   | Each VM has its own OS     |
| Faster startup         | Slower startup             |
| Uses fewer resources   | Uses more resources        |
| Best for microservices | Best for full OS isolation |

---

## Docker Architecture

Docker architecture mainly consists of:

### 1. Docker Client
The command-line interface where users run Docker commands.

### 2. Docker Daemon
The background service that manages:
- Containers
- Images
- Networks
- Volumes

### 3. Docker Images
Read-only templates used to create containers.

### 4. Docker Containers
Running instances of Docker images.

### 5. Docker Registry
A place where Docker images are stored.

---

## Docker Architecture Flow

```text
1. User gives command
2. Docker Client sends request
3. Docker Daemon processes request
4. Docker pulls image from Docker Registry if needed
5. Container gets created and executed
```

---

# Task 2: Install Docker

## Verify Docker Installation

```bash
docker --version
```

### Sample Output

```bash
docker version v1:24.0.6-ce, build
```

---

## Run Hello World Container

```bash
docker run hello-world
```

### What Happened?

1. Docker checked for the image locally  
2. Pulled the image from Docker Hub  
3. Created a container  
4. Executed the program  
5. Displayed the success message  

---

# Task 3: Run Real Containers

## Run Nginx Container

```bash
docker run -d -p 8080:80 --name nginx-container nginx
```

### Explanation

1. `-d` = Detached mode  
2. `-p 8080:80` = Maps port 8080 on host to port 80 in container  
3. `--name` = Custom container name  

### Access Nginx

Open any browser:

```text
http://localhost:8080
```

---

## Run Ubuntu Container in Interactive Mode

```bash
docker run -it ubuntu bash
```

### What Happened?

1. Started Ubuntu container  
2. Opened interactive bash shell  
3. Allowed Linux command execution inside container  

### Example Commands

```bash
ls
pwd
apt update
```

---

## List Running Containers

```bash
docker ps
```

---

## List All Containers

```bash
docker ps -a
```

---

## Stop a Container

```bash
docker stop nginx-container
```

---

## Remove a Container

```bash
docker rm nginx-container
```

---

# Task 4: Explore Docker Features

## Run Container in Detached Mode

```bash
docker run -d nginx
```

### Difference

Container runs in the background without blocking the terminal.

---

## Give Container a Custom Name

```bash
docker run -d --name my-nginx nginx
```

---

## Port Mapping

```bash
docker run -d -p 8080:80 nginx
```

### Port Mapping

1. Host Port = 8080  
2. Container Port = 80  

---

## Check Container Logs

```bash
docker logs my-nginx
```

---

## Execute Command Inside Running Container

```bash
docker exec -it my-nginx bash
```
---

# Why Docker Matters for DevOps

Docker helps DevOps engineers:

1. Package applications consistently  
2. Deploy applications faster  
3. Simplify CI/CD pipelines  
4. Improve scalability  
5. Reduce environment-related bugs  
6. Support microservices architecture  

Docker is one of the core technologies used in:
- Kubernetes
- CI/CD pipelines
- Cloud deployments
- Modern application development


# Key Learnings
1. Containers are lightweight and portable  
2. Docker simplifies application deployment  
3. Docker images are templates for containers  
4. Containers run consistently across environments  

