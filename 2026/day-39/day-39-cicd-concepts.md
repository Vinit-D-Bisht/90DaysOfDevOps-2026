## Task 1: The problem
### 1. What can go wrong?
- Developers may overwrite each other's changes
- Bugs can reach production unnoticed
- Different environments can cause unexpected failures
- Manual deployments increase human errors
- Rollbacks become difficult

### 2. What does "it works on my machine" mean and why is it a real problem?
"It works on my machine" means an application runs correctly on a developer's local system but fails in another environment due to differences in dependencies, configurations, operating systems, or infrastructure.

### 3. How many times a day can a team safely deploy manually?
Manual deployments are slow and error-prone. Most teams can safely deploy only a limited number of times per day compared to automated CI/CD pipelines that support frequent deployments.

---

## Task 2: CI vs CD

### Continuous Integration (CI)
Continuous Integration is the practice of frequently merging code changes into a shared repository where automated builds and tests run automatically.

**Example:** A developer pushes code to GitHub and automated tests run immediately.

### Continuous Delivery (CD)

Continuous Delivery extends CI by ensuring code is always ready for deployment. Deployment to production still requires manual approval.

**Example:** After passing tests, an application is automatically prepared and packaged for release.

### Continuous Deployment (CD)

Continuous Deployment automatically deploys every successful change to production without manual approval.

**Example:** A website automatically updates after tests and builds pass successfully.

---

## Task 3: Pipeline Anatomy

### Trigger

An event that starts a pipeline such as a push, pull request, schedule, or manual execution.

### Stage

A logical phase of the pipeline such as Build, Test, or Deploy.

### Job

A collection of related tasks executed within a stage.

### Step

A single command or action inside a job.

### Runner

The machine or environment that executes pipeline jobs.

### Artifact

Files produced during a pipeline such as build packages, reports, or Docker images.

---

## Task 4: Pipeline Diagram

```text
Developer Pushes Code -> {Trigger} GitHub Push -> {Build Stage} Build App  -> {Test Stage} Run Tests -> {Docker Stage} Build Image -> {Deploy Stage} Deploy Staging
```
---

## Task 5: Explore in the Wild

### Repository Chosen

Kubernetes

### Workflow File Observed

`ci.yml`

### What triggers it?

- Push events
- Pull requests

### How many jobs does it have?

- Multiple jobs for testing, validation, and build processes

### What does it do?

- Validates code changes
- Runs automated tests
- Checks code quality
- Ensures project stability before merging

---

## Key Learnings

1. CI/CD reduces manual work and deployment risks.
2. Continuous Integration focuses on building and testing code frequently.
3. Continuous Delivery prepares software for release, while Continuous Deployment automatically releases it.
4. Pipelines consist of triggers, stages, jobs, steps, runners, and artifacts.
5. CI/CD failures help detect problems early before reaching production
