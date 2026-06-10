# Task 1
## Project Setup

Created a GitHub repository named `github-actions-capstone`.

Added:

1. Flask application (`app.py`)
2. Requirements file (`requirements.txt`)
3. Test file (`test_app.py`)
4. Dockerfile
5. README.md

### Objective

Build a production-style CI/CD workflow using reusable workflows, Docker, environments, and scheduled automation.

### Key Learning

1. CI/CD projects combine everything learned previously into one workflow.
2. A proper repository structure improves maintainability.
3. Testing and deployment should always be automated.

---

# Task 2

## Reusable Build & Test Workflow

File:

```text
.github/workflows/reusable-build-test.yml
```

### Features

1. Triggered using `workflow_call`
2. Accepts runtime version as input
3. Accepts test execution toggle
4. Installs dependencies
5. Runs tests
6. Returns test result as workflow output

### Key Learning

1. Reusable workflows reduce duplication.
2. Inputs make workflows flexible.
3. Outputs allow workflows to share data.

---

# Task 3

## Reusable Docker Workflow

File:

```text
.github/workflows/reusable-docker.yml
```

### Features

1. Triggered using `workflow_call`
2. Accepts image name and tag
3. Uses Docker Hub credentials from secrets
4. Builds image
5. Pushes image to Docker Hub
6. Returns image URL

### Key Learning

1. Docker operations can be centralized into reusable workflows.
2. Secrets protect credentials.
3. Outputs can pass image information to deployment jobs.

---

# Task 4

## Pull Request Pipeline

File:

```text
.github/workflows/pr-pipeline.yml
```

### Trigger

```yaml
pull_request
```

Events:

1. opened
2. synchronize

### Workflow Flow

1. Call reusable build-test workflow
2. Run tests
3. Print PR summary

### Verification

Docker images are NOT built or pushed during PR validation.

### Key Learning

1. Pull Requests should focus on validation only.
2. Early testing catches issues before merging.
3. PR workflows reduce deployment risk.

---

# Task 5

## Main Branch Pipeline

File:

```text
.github/workflows/main-pipeline.yml
```

### Trigger

```yaml
push:
  branches:
    - main
```

### Workflow Flow

1. Build & Test
2. Docker Build & Push
3. Deploy

### Deployment

Uses:

```yaml
environment: production
```

### Deployment Message

```text
Deploying image to production environment
```

### Verification

Pipeline executes in sequence:

```text
Build & Test -> Docker Build & Push -> Deploy
```

### Key Learning

1. Production deployments should depend on successful testing.
2. Job dependencies enforce workflow order.
3. Environments provide deployment protection.

---

# Task 6

## Scheduled Health Check

File:

```text
.github/workflows/health-check.yml
```

### Triggers

```yaml
schedule:
  - cron: '0 */12 * * *'

workflow_dispatch:
```

### Workflow Actions

1. Pull latest Docker image
2. Run container
3. Wait for startup
4. Execute health check
5. Generate workflow summary
6. Remove container

### Workflow Summary

```text
## Health Check Report

- Image: latest
- Status: PASSED
- Time: Current Execution Time
```

### Key Learning

1. Scheduled workflows automate monitoring.
2. Health checks validate deployments.
3. Workflow summaries improve visibility.

---

# Task 7

## Pipeline Architecture

```text
PR Opened -> Build & Test -> PR Checks Passed

Merge To Main -> Build & Test -> Docker Build & Push -> Deploy To Production

Every 12 Hours -> Health Check Workflow -> Generate Report
```

---

# Workflow Files Used

1. reusable-build-test.yml
2. reusable-docker.yml
3. pr-pipeline.yml
4. main-pipeline.yml
5. health-check.yml

---

# Brownie Point – DevSecOps Enhancement

Added:

```yaml
aquasecurity/trivy-action
```

Purpose:

1. Scan Docker images for vulnerabilities
2. Detect critical CVEs
3. Fail pipeline if critical issues are found
4. Upload scan reports as artifacts

### Key Learning

1. Security should be integrated into CI/CD.
2. Automated scanning reduces deployment risks.
3. DevSecOps starts inside the pipeline.

