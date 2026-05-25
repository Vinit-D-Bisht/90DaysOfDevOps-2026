# Task 1: The Problem

## Run a Postgres Container

```bash
docker run -d \
--name postgres-db \
-e POSTGRES_PASSWORD=admin123 \
postgres
```

---

## Enter the Container

```bash
docker exec -it postgres-db bash
```

---

## Open PostgreSQL

```bash
psql -U postgres
```

---

## Create Database and Table

```sql
CREATE DATABASE devops;
```

```sql
\c devops;
```

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);  

```

```sql
INSERT INTO users (name) VALUES ('Vinit');
```

---

## Stop and Remove Container

```bash
docker stop postgres-db
```

```bash
docker rm postgres-db
```

---

## Run New Container

```bash
docker run -d --name postgres-db-new -e POSTGRES_PASSWORD=admin123 postgres
```

---

### What Happened?
I ran tge Postgres container, created some data, then stopped and removed the container.After creating a new container, the data was gone.

### Why?
Containers are temporary. Data stored inside a container is deleted whe the container is removed unless persistent storage is used.

---

# Task 2: Named Volumes

## Create Named Volume
```bash
docker volume create p-data
```

---

## Verify Volume
```bash
docker volume ls
```

---

## run Postgres with Volume
```bash
docker run -d --name postgres-volume-db \
-e POSTGRES_PASSWORD=admin123 -v p-data:/var/lib/postgresql/data postgres
```

---

## Add Data

```bash
docker exec -it postgres-volume-db psql -U postgres
```

```sql
CREATE DATABASE appdb;
```

---

## Stop and Remove Container

```bash
docker stop postgres-volume-db
```

```bash
docker rm postgres-volume-db
```

---

## Run New Container with Same Volume

```bash
docker run -d --name postgres-volume-db-new -e POSTGRES_PASSWORD=admin123 -v postgres-data:/var/lib/postgresql/data postgres
```

---

## Observation
The data still existed.

### Why?
1. Named volumes store data outside the container  
2. Removing the container does not remove the volume  
3. Docker reattached the same volume to the new container  

---

## Inspect Volume

```bash
docker volume inspect p-data
```

---

# Task 3: Bind Mounts

## Create Local Folder

```bash
mkdir website
cd website
```

---

## Created index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Bind Mount</title>
    </head>
    <body>
        <h1>Hello from Bind Mount!</h1>
    </body>   
</html>
```

---

## Run Nginx with Bind Mount

```bash
docker run -d --name nginx-bind -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx
```

---

## Access Website

Open browser:
```text
http://localhost:8080
```

---

## Edit index.html

```html
<h1>This is an edit in the index.html</h1>
```

Refresh browser and changes appear instantly.

---

## Named Volume vs Bind Mount

### Named Volume
1. Managed by Docker  
2. Stored in Docker directories  
3. Better for persistent application data  
4. More portable  

### Bind Mount
1. Directly maps host files/folders  
2. Useful during development  
3. Changes reflect immediately  
4. Depends on host filesystem structure  

---

# Task 4: Docker Networking Basics

## List Docker Networks
```bash
docker network ls
```

---

## Inspect Default Bridge Network

```bash
docker network inspect bridge
```

---

## Run Two Containers on Default Bridge

```bash
docker run -dit --name ContainerA ubuntu bash
```

```bash
docker run -dit --name ContainerB ubuntu bash
```

---

## Ping by Container Name

```bash
docker exec -it ContainerA ping ContainerB
```

### Observation
Ping by name failed on default bridge network.

---

## Find Container IP
```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ContainerB
```

---

## Ping by IP
```bash
docker exec -it ContainerA ping <container-ip>
```

### Observation
Ping by IP worked successfully.

---

# Task 5: Custom Networks

## Create Custom Bridge Network
```bash
docker network create my-net
```

---

## Run Containers on Custom Network

```bash
docker run -dit --name app --network my-net ubuntu bash
```

```bash
docker run -dit --name appliy --network my-net ubuntu bash
```

---

## Ping by Name

```bash
docker exec -it app ping appliy
```

### Observation
Ping by container name worked successfully.

---

## Why Custom Networks Allow Name Communication
1. Docker provides automatic DNS resolution on custom networks  
2. Containers can discover each other using container names  
3. Default bridge network lacks automatic DNS-based service discovery  

---

# Task 6: Put It Together

## Create Custom Network
```bash
docker network create app-network
```

---

## Create Volume
```bash
docker volume create mysql-data
```

---

## Run MySQL Container
```bash
docker run -d --name mysql-db --network app-network -e MYSQL_ROOT_PASSWORD=root123 -v mysql-data:/var/lib/mysql mysql
```

---

## Run App Container
```bash
docker run -dit --name app-container --network app-network ubuntu bash
```

---

## Verify Connectivity

```bash
docker exec -it app-container ping mysql-db
```

### Observation
The app container successfully reached the database container using container name.

---

# Key Learnings
1. Containers lose data when removed unless volumes are used  and Named volumes provide persistent storage  
2. Bind mounts connect host files directly to containers  
3. Custom Docker networks support automatic DNS resolution  and Containers on the same custom network can communicate using names  
4. Volumes and networking are essential for real-world applications while Docker simplifies multi-container communication and storage management  
