# Task 1: Prepare

## Prerequisites

1. Added Dockerfile to the repository
2. Configured GitHub Secrets:

```text
DOCKER_USERNAME
DOCKER_TOKEN
```

3. Verified Docker image builds successfully locally

---

# Task 2: Build Docker Image in CI

## Workflow File

### `.github/workflows/docker-publish.yml`

```yaml
name: Docker Publish

on:
  push:
    branches:
      - main

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Build Docker Image
        run: |
          docker build -t my-app:latest .
```

## Result

1. Workflow triggered automatically on push to main.
2. Repository was checked out successfully.
3. Docker image built successfully inside GitHub Actions runner.

---

# Task 3: Push to Docker Hub

## Complete Workflow

```yaml
name: Docker Publish

on:
  push:
    branches:
      - main

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Set Short SHA
        id: vars
        run: echo "SHORT_SHA=${GITHUB_SHA::7}" >> $GITHUB_ENV

      - name: Login To Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}

      - name: Build Docker Image
        run: |
          docker build -t ${{ secrets.DOCKER_USERNAME }}/my-app:latest .
          docker tag ${{ secrets.DOCKER_USERNAME }}/my-app:latest \
          ${{ secrets.DOCKER_USERNAME }}/my-app:sha-${SHORT_SHA}

      - name: Push Latest Tag
        run: |
          docker push ${{ secrets.DOCKER_USERNAME }}/my-app:latest

      - name: Push SHA Tag
        run: |
          docker push ${{ secrets.DOCKER_USERNAME }}/my-app:sha-${SHORT_SHA}
```

## Result

Docker Hub now contains:

```text
latest
sha-xxxxxxx
```

Both image tags were pushed successfully.

---

# Task 4: Push Only On Main

## Conditional Push

```yaml
if: github.ref == 'refs/heads/main'
```

## Result

1. Feature branches still build the image.
2. Docker Hub push only occurs from main branch.
3. Prevents accidental publishing from development branches.

---

# Task 5: Add Status Badge

## README Badge

```md
![Docker Publish](https://github.com/USERNAME/REPOSITORY/actions/workflows/docker-publish.yml/badge.svg)
```

Replace:

```text
USERNAME
REPOSITORY
```

with your GitHub details.

## Result

Badge automatically updates after every workflow run.

Green badge indicates successful pipeline execution.

---

# Task 6: Pull And Run The Image

## Pull Image

```bash
docker pull username/my-app:latest
```

## Run Container

```bash
docker run -d -p 8080:80 username/my-app:latest
```

## Verify

```bash
docker ps
```

Open:

```text
http://localhost:8080
```

Application loads successfully.

---

# Docker Hub Repository

Add your Docker Hub image link:

```text
https://hub.docker.com/r/username/my-app
```

---

# Full Journey: Git Push To Running Container

1. Developer pushes code to GitHub.
2. GitHub Actions workflow triggers automatically.
3. Repository code is checked out on the runner.
4. Docker image is built using the Dockerfile.
5. Workflow authenticates with Docker Hub using GitHub Secrets.
6. Image receives latest and SHA-based tags.
7. Tagged images are pushed to Docker Hub.
8. Any machine can pull the image from Docker Hub.
9. Container is started using the pulled image.
10. Application becomes available to users.


---

# Key Learnings

1. GitHub Actions can automatically build and publish Docker images.
2. Secrets securely store Docker credentials and prevent exposure in logs.
3. Automated image publishing is a core CI/CD practice used in real DevOps environments.


