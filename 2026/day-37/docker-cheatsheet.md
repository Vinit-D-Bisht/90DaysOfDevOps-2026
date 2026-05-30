# Docker Cheat Sheet

# Container Commands

## How do I run a container?

```bash
docker run nginx
```

## How do I run a container in interactive mode?

```bash
docker run -it ubuntu bash
```

## How do I run a container in detached mode?

```bash
docker run -d nginx
```

## How do I list running containers?

```bash
docker ps
```

## How do I list all containers?

```bash
docker ps -a
```

## How do I stop a container?

```bash
docker stop <container_id>
```

## How do I remove a container?

```bash
docker rm <container_id>
```

## How do I execute commands inside a container?

```bash
docker exec -it <container_id> bash
```

## How do I view container logs?

```bash
docker logs <container_id>
```

## How do I follow logs in real time?

```bash
docker logs -f <container_id>
```

# Image Commands

## How do I pull an image?

```bash
docker pull nginx
```

## How do I build an image?

```bash
docker build -t myimage:v1 .
```

## How do I list images?

```bash
docker images
```

## How do I remove an image?

```bash
docker rmi <image_id>
```

## How do I tag an image?

```bash
docker tag myimage:v1 username/myimage:v1
```

## How do I push an image to Docker Hub?

```bash
docker push username/myimage:v1
```

## How do I inspect an image?

```bash
docker image inspect nginx
```

## How do I view image layers?

```bash
docker image history nginx
```

# Volume Commands

## How do I create a volume?

```bash
docker volume create myvolume
```

## How do I list volumes?

```bash
docker volume ls
```

## How do I inspect a volume?

```bash
docker volume inspect myvolume
```

## How do I remove a volume?

```bash
docker volume rm myvolume
```

# Network Commands

## How do I create a network?

```bash
docker network create my-network
```

## How do I list networks?

```bash
docker network ls
```

## How do I inspect a network?

```bash
docker network inspect my-network
```

## How do I connect a container to a network?

```bash
docker network connect my-network container_name
```

# Docker Compose Commands

## How do I start services?

```bash
docker compose up
```

## How do I start services in detached mode?

```bash
docker compose up -d
```

## How do I stop services?

```bash
docker compose stop
```

## How do I remove services?

```bash
docker compose down
```

## How do I remove services and volumes?

```bash
docker compose down -v
```

## How do I view running services?

```bash
docker compose ps
```

## How do I view logs?

```bash
docker compose logs
```

## How do I follow logs?

```bash
docker compose logs -f
```

## How do I rebuild services?

```bash
docker compose up --build
```

# Cleanup Commands

## How do I remove stopped containers?

```bash
docker container prune
```

## How do I remove unused images?

```bash
docker image prune
```

## How do I remove unused volumes?

```bash
docker volume prune
```

## How do I remove unused networks?

```bash
docker network prune
```

## How do I perform a full cleanup?

```bash
docker system prune -a
```

## How do I check Docker disk usage?

```bash
docker system df
```

# Dockerfile Instructions

## What does FROM do?

```dockerfile
FROM node:22-alpine
```

Defines the base image.

## What does RUN do?

```dockerfile
RUN npm install
```

Executes commands during image build.

## What does COPY do?

```dockerfile
COPY . .
```

Copies files into the image.

## What does WORKDIR do?

```dockerfile
WORKDIR /app
```

Sets the working directory.

## What does EXPOSE do?

```dockerfile
EXPOSE 3000
```

Documents the application port.

## What does CMD do?

```dockerfile
CMD ["npm", "start"]
```

Sets the default command.

## What does ENTRYPOINT do?

```dockerfile
ENTRYPOINT ["node"]
```

Defines the main executable.

## What does USER do?

```dockerfile
USER appuser
```

Runs the container as a non-root user.

## What does HEALTHCHECK do?

```dockerfile
HEALTHCHECK CMD curl -f http://localhost:3000 || exit 1
```

Checks container health.
