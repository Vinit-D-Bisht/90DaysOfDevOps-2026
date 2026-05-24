# Task 1: Your First Dockerfile

## Create Project Folder
```bash
mkdir my-first-image
cd my-first-image
```

---

## Create Dockerfile

---

## Build Docker Image
```bash
docker build -t my-ubuntu:v1 .
```

---

## Run Container
```bash
docker run my-ubuntu:v1
```

### Output
```text
Hello from my custom image!
```

---

# Task 2: Dockerfile Instructions

## Create Project Structure

```text
my-first-image/
├── Dockerfile
├── app.txt
```

---

## Created app.txt
```text
Dockerfile for app.txt
```
---

## Build Image
```bash
docker build -t docker-demo:v1 .
```

---

## Run Container
```bash
docker run docker-demo:v1
```

---

## Understanding Instructions
### 1. FROM
Sets the base image.

### 2. RUN
Executes commands during image build.

### 3. WORKDIR
Sets working directory inside container.

### 4. COPY
Copies files from host machine into image.

### 5. EXPOSE
Documents which port the container uses.

### 6. CMD
Sets the default command for the container.

---

# Task 3: CMD vs ENTRYPOINT

## Dockerfile Using CMD

```Dockerfile
FROM ubuntu

CMD ["echo", "hello"]
```

---

## Build Image

```bash
docker build -t cmd-demo:v1 .
```

---

## Run Container

```bash
docker run cmd-demo:v1
```

### Output

```text
hello
```

---

## Run with Custom Command

```bash
docker run cmd-demo:v1 ls
```

### Observation

The default CMD gets replaced by the custom command.

---

## Dockerfile Using ENTRYPOINT

```Dockerfile
FROM ubuntu

ENTRYPOINT ["echo"]
```

---

## Build Image

```bash
docker build -t entry-demo:v1 .
```

---

## Run Container

```bash
docker run entry-demo:v1 hello
```

### Output

```text
hello
```

---

## Run with Additional Arguments

```bash
docker run entry-demo:v1 Docker is awesome
```

### Output

```text
Docker is awesome
```

---

## CMD vs ENTRYPOINT

### CMD
Used for default commands that users can override.

### ENTRYPOINT
Used when the container should always run a specific executable.

---

# Task 4: Build a Simple Web App Image

## Created index.html

---

## Created Dockerfile

---

## Build Image
```bash
docker build -t my-website:v1 .
```

---

## Run Container
```bash
docker run -d -p 8080:80 --name my-site my-website:v1
```

---

## Access Website

Open browser:
```text
http://localhost:8080
```

---

# Task 5: .dockerignore

## Create .dockerignore
```text
node_modules
.git
*.md
.env
```

---

## Why Use .dockerignore?
1. Reduces build context size  
2. Prevents sensitive files from entering images  

---

# Task 6: Build Optimization

## Build Image

```bash
docker build -t optimized-image:v1 .
```

---

## Modify One File and Rebuild

```bash
docker build -t optimized-image:v2 .
```

---

## Observation
Docker reused cached layers for unchanged steps.
Only changed layers were rebuilt.

---

## Why Layer Order Matters
1. Docker caches layers during builds  
2. Frequently changing files should be near the end  
3. Stable layers should be near the beginning  
4. Proper ordering speeds up rebuilds significantly  

---

# Example Optimized Dockerfile

```Dockerfile
FROM ubuntu
RUN apt update && apt install -y curl
WORKDIR /app
COPY . .
CMD ["echo", "Optimized Docker Build"]
```
---

# Key Learnings
1. Dockerfiles are used to build custom images  
2. Images are created layer by layer  
3. CMD provides default commands  
4. ENTRYPOINT forces a fixed executable  
5. .dockerignore improves build efficiency  
6. Layer caching speeds up rebuilds  
7. Docker can package complete applications consistently  

