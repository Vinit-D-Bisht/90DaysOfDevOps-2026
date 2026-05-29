# Day 36 – Docker Project: Dockerize a Full Application
## Task 1: Pick Your App

### Chosen App

Node.js Application with MongoDB

### Why?

I chose a Node.js application because JavaScript is widely used for backend development and it provides a practical example of containerizing a real-world application with a database. So i can get familiar with Node js

---

## Task 2: Dockerfile

### Dockerfile

```Dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN adduser -D appuser

USER appuser

EXPOSE 3000

CMD ["npm", "start"]
```

### .dockerignore

```text
node_modules
.git
.env
*.md
```

### Build Image

```bash
docker build -t node-app:v1 .
```

---

## Task 3: Docker Compose

### .env

```env
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=password
```

### created docker-compose.yml

```yaml
```

### Run Application

```bash
docker compose up -d
```

### Verify Services

```bash
docker compose ps
```

---

## Task 4: Ship It

### Tag Image

```bash
docker tag node-app:v1 yourusername/node-app:v1
```

### Push Image

```bash
docker push yourusername/node-app:v1
```

### Docker Hub Repository

```text
https://hub.docker.com/r/devopspractice1989/node-app
```

### README.md

```md
# Node.js Docker App

Simple Node.js application running with MongoDB using Docker Compose.

## Run

docker compose up -d

## Stop

docker compose down

## Environment Variables

MONGO_INITDB_ROOT_USERNAME
MONGO_INITDB_ROOT_PASSWORD
```

---

## Task 5: Test the Whole Flow

### Remove Containers

```bash
docker compose down
```

### Remove Local Image

```bash
docker rmi devopspractice1989/node-app:v1
```

### Pull Image

```bash
docker pull devopspractice1989/node-app:v1
```

### Run Again

```bash
docker compose up -d
```

### Result

The application started successfully using the image pulled from Docker Hub.

---

## Challenges Faced

### Challenge 1

The application started before MongoDB was fully ready.

### Solution

Added healthchecks and depends_on conditions.

### Challenge 2

Database credentials were hardcoded.

### Solution

Moved configuration into a .env file.

### Challenge 3

The image size was larger than expected.

### Solution

Used Alpine images and a .dockerignore file.

---

## Final Image Size

```text
~150 MB
```

---

## Docker Hub Link

```text
https://hub.docker.com/r/devopspractice1989/node-app
```
---

## Key Learnings
1. Docker Compose makes it easy to run applications and databases together.
2. Healthchecks and volumes improve reliability and persistence.
3. Smaller images and non-root users improve security and efficiency.
