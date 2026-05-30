Day 37 – Docker Revision & Cheat Sheet

Self-Assessment Checklist

1. Run a container from Docker Hub (interactive + detached) = Can Do
2. List, stop, remove containers and images = Can Do
3. Explain image layers and how caching works = Can Do
4. Write a Dockerfile from scratch with FROM, RUN, COPY, WORKDIR, CMD = Can Do
5. Explain CMD vs ENTRYPOINT = Can Do
6. Build and tag a custom image = Can Do
7. Create and use named volumes = Can Do
8. Use bind mounts = Can Do
9. Create custom networks and connect containers = Can Do
10. Write a docker-compose.yml for a multi-container app = Can Do
11. Use environment variables and .env files in Compose = Can Do
12. Write a multi-stage Dockerfile = shaky
13. Push an image to Docker Hub = Can Do
14. Use healthchecks and depends_on = shaky

---

Quick-Fire Questions

1. What is the difference between an image and a container?

An image is a read-only template used to create containers. A container is a running instance of an image.

2. What happens to data inside a container when you remove it?

The data is deleted unless it is stored in a volume or bind mount.

3. How do two containers on the same custom network communicate?

They communicate using container names through Docker's built-in DNS.

4. What does docker compose down -v do differently from docker compose down?

It removes containers, networks, and associated volumes.

5. Why are multi-stage builds useful?

They reduce image size by keeping only the files required to run the application.

6. What is the difference between COPY and ADD?

COPY copies files and directories. ADD can also extract archives and download files from URLs.

7. What does -p 8080:80 mean?

Maps port 8080 on the host to port 80 inside the container.

8. How do you check how much disk space Docker is using?

docker system df

---

Revisited Topics

Topic 1: Multi-Stage Builds

Rebuilt a Node.js application using a multi-stage Dockerfile and compared image sizes.

What I Re-Learned

Multi-stage builds separate the build environment from the runtime environment, producing smaller and more secure images.

---

Topic 2: Docker Networking

Created custom bridge networks and connected multiple containers.

What I Re-Learned

Containers on custom networks can communicate directly using container names without needing IP addresses.

---

Key Learnings

1. Docker images are templates while containers are running instances.
2. Volumes are required for persistent data storage.
3. Docker Compose simplifies multi-container application deployment.
4. Multi-stage builds help reduce image size and improve security.
5. Custom networks enable reliable container-to-container communication.
