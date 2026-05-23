# Task 1: Docker Images

## Pull Docker Images
### Pull Nginx Image
```bash
docker pull nginx
```

---

### Pull Ubuntu Image
```bash
docker pull ubuntu
```

---

### Pull Alpine Image
```bash
docker pull alpine
```

---

## List All Images
```bash
docker images
```

### Observation
| Image | Approx Size |
|-------------|-------------------|
| nginx    | Medium     |
| ubuntu | Large.         |
| alpine.  | Very Small |

---

## Ubuntu vs Alpine

### Why is Alpine Smaller?
1. Alpine is a minimal Linux distribution  
2. Uses BusyBox utilities  
3. Contains fewer packages and libraries  
4. Designed for lightweight containers  
5. Faster downloads and lower storage usage  
Ubuntu includes more tools, libraries, and packages which increases image size.

---

## Inspect an Image

```bash
docker image inspect nginx
```

### Information Visible
1. Image ID  
2. Creation date  
3. Architecture  
4. Environment variables  
5. Layers  
6. Entrypoint  
7. Exposed ports  

---

## Remove an Image
```bash
docker rmi ubuntu
```

---

# Task 2: Image Layers

## View Image History
```bash
docker image history nginx
```

### Observation
Each line in the output represents a Docker image layer.

Some layers show:
- Actual size changes
- Installed packages
- Configuration changes

Some layers show:
- `0B`
- Metadata-only instructions

---

## What are Docker Layers?
Docker images are built using multiple read-only layers.

### Why Docker Uses Layers
1. Faster image builds  
2. Better caching  
3. Reduced storage usage  
4. Shared layers between images  
5. Faster downloads and transfers  
Layers help Docker avoid rebuilding everything from scratch.

---

# Task 3: Container Lifecycle

## Create a Container Without Starting
```bash
docker create --name my-container nginx
```

---

## Start the Container
```bash
docker start my-container
```

---

## Pause the Container
```bash
docker pause my-container
```

---

## Check Container Status
```bash
docker ps -a
```

---

## Unpause the Container
```bash
docker unpause my-container
```

---

## Stop the Container
```bash
docker stop my-container
```

---

## Restart the Container
```bash
docker restart my-container
```

---

## Kill the Container
```bash
docker kill my-container
```

---

## Remove the Container
```bash
docker rm my-container
```

---

## Container Lifecycle States
1. Created  
2. Running  
3. Paused  
4. Stopped  
5. Restarted  
6. Killed  
7. Removed  

---

# Task 4: Working with Running Containers

## Run Nginx Container in Detached Mode
```bash
docker run -d --name nginx-server -p 8080:80 nginx
```

---

## View Container Logs
```bash
docker logs nginx-server
```

---

## View Real-Time Logs
```bash
docker logs -f nginx-server
```

---

## Enter Running Container
```bash
docker exec -it nginx-server bash
```

### Explore Filesystem
```bash
ls
pwd
cd /usr/share/nginx/html
```

---

## Run Single Command Inside Container
```bash
docker exec nginx-server ls /usr/share/nginx/html
```

---

## Inspect Container
```bash
docker inspect nginx-server
```

### Information Found
1. Container IP address  
2. Port mappings  
3. Mounts  
4. Network settings  
5. Environment variables  
6. Container status  

---

# Task 5: Cleanup

## Stop All Running Containers
```bash
docker stop $(docker ps -q)
```
---

## Remove All Stopped Containers
```bash
docker container prune
```

---

## Remove Unused Images
```bash
docker image prune -a
```

---

## Check Docker Disk Usage
```bash
docker system df
```

---

# Key Learnings
1. Docker images are templates used to create containers  
2. Containers are running instances of images  
3. Docker images use layers for caching and efficiency  
4. Alpine images are smaller because they are minimal  
5. Containers move through multiple lifecycle states  
6. Docker provides tools for logs, inspection, and cleanup  
7. Proper cleanup helps reduce Docker disk usage  

