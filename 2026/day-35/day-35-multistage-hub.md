## Task 1: The Problem with Large Images

### app.js
```javascript
console.log("Hello World");
```

### Single Stage Dockerfile

```Dockerfile
FROM node:22

WORKDIR /app

COPY app.js .

CMD ["node", "app.js"]
```

### Build Image

```bash
docker build -t node-single:v1 .
```

### Check Image Size

```bash
docker images
```

### Observation
Single-stage image size was significantly larger because it included the full Node.js runtime and build environment.

---

## Task 2: Multi-Stage Dockerfile
### Multi-Stage Dockerfile

```Dockerfile
FROM node:22 AS builder

WORKDIR /app

COPY app.js .

FROM node:22-alpine

WORKDIR /app

COPY --from=builder /app/app.js .

CMD ["node", "app.js"]
```

### Build Image

```bash
docker build -t node-multistage:v1 .
```

### Check Image Size

```bash
docker images
```

### Comparison
node-single:v1 => Larger
node-multistage:v1 => Smaller 

### Why is it Smaller?
The final image only contains the files required to run the application and excludes unnecessary build dependencies.

---

## Task 3: Push to Docker Hub

### Login
```bash
docker login
```

### Tag Image

```bash
docker tag node-multistage:v1 yourusername/node-app:v1
```

### Push Image

```bash
docker push yourusername/node-app:v1
```

### Verify

```bash
docker rmi yourusername/node-app:v1
```

```bash
docker pull yourusername/node-app:v1
```

---
## Task 4: Docker Hub Repository

### Repository URL

```text
https://hub.docker.com/r/yourusername/node-app
```

### Repository Updates
1. Added repository description
2. Verified image tags
3. Explored versioning using tags

### Pull Specific Tag

```bash
docker pull yourusername/node-app:v1
```

### Pull Latest Tag

```bash
docker pull yourusername/node-app:latest
```

### Observation
Docker downloads the exact tag requested. If no tag is specified, Docker uses `latest`.

---

## Task 5: Image Best Practices

### Optimized Dockerfile

```Dockerfile
FROM node:22-alpine

WORKDIR /app

COPY app.js .

RUN adduser -D appuser

USER appuser

CMD ["node", "app.js"]
```

### Improvements Applied

1. Used Alpine base image
2. Added non-root user
3. Used specific image tag
4. Reduced unnecessary layers

### Rebuild Image

```bash
docker build -t node-optimized:v1 .
```

### Check Size

```bash
docker images
```

### Observation

The optimized image was smaller and more secure than the original version.

---
## Docker Hub Repository

```text
https://hub.docker.com/r/devopspractice1989/node-app
```

## Key Learnings
1. Multi-stage builds reduce image size by separating build and runtime environments.
2. Docker Hub allows images to be shared, versioned, and reused across systems.
3. Using minimal images and non-root users improves security and efficiency.
