## 1: Install & Verify

### Check Docker Compose and verify version 
```bash
docker compose version
```

---

## Task 2: Your First Compose File

### Create Folder
```bash
mkdir compose-basics
cd compose-basics
```

### docker-compose.yml

```yaml
services:
    nginx:
        image: nginx
        ports:
          - "8080:80"

```

### Start Services

```bash
docker compose up
```

### Access Application
Go to any browser and type:
```text
http://localhost:8080
```

### Stop Services
```bash
docker compose down
```

---

## Task 3: Two-Container Setup

### docker-compose.yml
```yaml
services:
    mysql:
      image: mysql:latest
      container_name: mysql-db
      restart: always
      environment:
        MYSQL_ROOT_PASSWORD: root123
        MYSQL_DATABASE: wordpress
        MYSQL_USER: wpuser
        MYSQL_PASSWORD: wp123
      volumes:
        - mysql_data:/var/lib/mysql



    wordpress:
      image: wordpress
      container_name: wordpress-app
      restart: always
      ports:
        - "8080:80"
      environment:
        WORDPRESS_DB_HOST: mysql
        WORDPRESS_DB_USER: wpuser
        WORDPRESS_DB_PASSWORD: wp123
        WORDPRESS_DB_NAME: wordpress
      depends_on:
        - mysql                                                                                                                                 volumes:
  - mysql-db

```

### Start Services

```bash
docker compose up -d
```

### Access WordPress

```text
http://localhost:8080
```

### Stop Services

```bash
docker compose down
```

### Start Again
Starts in background/detach mode with -d
```bash
docker compose up -d
```

### Observation
WordPress data remained available because MySQL used a named volume.

---

## Task 4: Compose Commands

### Start in Detached Mode
```bash
docker compose up -d
```

### View Running Services

```bash
docker compose ps
```

### View Logs of All Services

```bash
docker compose logs
```

### Follow Logs

```bash
docker compose logs -f
```

### View Logs of Specific Service

```bash
docker compose logs mysql
```

### Stop Services

```bash
docker compose stop
```

### Remove Containers and Networks

```bash
docker compose down
```

### Rebuild Images

```bash
docker compose up --build
```

---

## Task 5: Environment Variables

### Environment Variables in Compose File

```yaml
environment:
  MYSQL_ROOT_PASSWORD: root123
```

---

### Create .env File

```env
  MYSQL_ROOT_PASSWORD=root123
  MYSQL_DATABASE=wordpress
  MYSQL_USER=wpuser
  MYSQL_PASSWORD=wp123
```

---

### Use Variables in Compose File

```yaml
environment:
  MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
  MYSQL_DATABASE: ${MYSQL_DATABASE}
  MYSQL_USER: ${MYSQL_USER}
  MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

### Verify Variables

```bash
docker compose config
```

## Key Learnings
1. Docker Compose allows multiple containers to be managed using a single YAML file.
2. Compose automatically creates networks and simplifies container communication.
3. Volumes and environment variables help make applications persistent and configurable.
