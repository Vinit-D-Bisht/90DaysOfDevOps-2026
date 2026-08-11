# Day 86 — GitOps Project: End-to-End CI/CD Pipeline with AI-BankApp

## Overview

Day 86 completes the three-day GitOps block by connecting GitHub Actions, DockerHub, Git, ArgoCD, and Amazon EKS into a complete end-to-end CI/CD pipeline.

The objective was to implement a workflow where a developer pushes application code to GitHub, GitHub Actions builds and tests the application, creates and pushes a Docker image, updates the Kubernetes deployment manifest with the new image tag, and commits the manifest back to Git. ArgoCD then detects the Git change and synchronizes the desired state to the EKS cluster.

The complete workflow is:

```text
Developer
    |
    | git push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +--> Maven Build
    |
    +--> Tests
    |
    +--> Docker Image Build
    |
    +--> Push Image to DockerHub
    |
    +--> Update Kubernetes Manifest
    |
    +--> Commit Manifest to Git
    |
    v
Git Repository
    |
    | ArgoCD detects Git change
    v
ArgoCD
    |
    | Compare desired state with cluster
    |
    v
Amazon EKS
    |
    v
Kubernetes Deployment
    |
    v
New AI-BankApp Pods
    |
    v
Live Application
```

This provides a GitOps-based deployment model with Git as the source of truth and ArgoCD responsible for continuously reconciling the Kubernetes cluster with the desired state stored in Git.

---

# 1. GitOps Architecture

The Day 86 architecture combines the major technologies learned throughout the 90 Days of DevOps challenge.

```text
                         ┌──────────────────────┐
                         │      Developer       │
                         │   Application Code   │
                         └──────────┬───────────┘
                                    │
                               git push
                                    │
                                    v
                         ┌──────────────────────┐
                         │    GitHub Repository │
                         │     feat/gitops      │
                         └──────────┬───────────┘
                                    │
                                    v
                         ┌──────────────────────┐
                         │    GitHub Actions    │
                         │         CI           │
                         ├──────────────────────┤
                         │ Maven Build          │
                         │ Unit Tests            │
                         │ Docker Build          │
                         │ Docker Push           │
                         │ Update K8s Manifest   │
                         └──────────┬───────────┘
                                    │
                          Push Docker Image
                                    │
                                    v
                         ┌──────────────────────┐
                         │      DockerHub       │
                         │   AI-BankApp Image   │
                         └──────────────────────┘

                                    +
                                    
                         Git manifest commit
                                    │
                                    v
                         ┌──────────────────────┐
                         │    Git Repository    │
                         │ bankapp-deployment   │
                         │       updated        │
                         └──────────┬───────────┘
                                    │
                         ArgoCD detects change
                                    │
                                    v
                         ┌──────────────────────┐
                         │       ArgoCD         │
                         │     GitOps CD        │
                         ├──────────────────────┤
                         │ Compare Git / EKS    │
                         │ Sync                  │
                         │ Self-Heal             │
                         │ Health Checks         │
                         └──────────┬───────────┘
                                    │
                                    v
                         ┌──────────────────────┐
                         │      Amazon EKS      │
                         │   Kubernetes Cluster │
                         └──────────┬───────────┘
                                    │
                                    v
                         ┌──────────────────────┐
                         │   AI-BankApp Pods    │
                         │   Rolling Update     │
                         └──────────┬───────────┘
                                    │
                                    v
                         ┌──────────────────────┐
                         │    Live Application  │
                         └──────────────────────┘
```

---

# 2. GitHub Actions CI Pipeline

The GitOps CI pipeline is defined in:

```text
.github/workflows/gitops-ci.yml
```

The workflow runs when application-related files are changed on the `feat/gitops` branch.

```yaml
on:
  push:
    branches: [feat/gitops]
    paths:
      - 'src/**'
      - 'pom.xml'
      - 'Dockerfile'
  workflow_dispatch:
```

## Why Path Filtering Is Used

The workflow is intentionally triggered only by application changes.

It monitors:

```text
src/**
pom.xml
Dockerfile
```

Kubernetes manifest changes are not included.

This is important because the workflow itself modifies:

```text
k8s/bankapp-deployment.yml
```

If Kubernetes manifest changes also triggered the workflow, the workflow could repeatedly trigger itself after committing the updated image tag.

The `[skip ci]` commit message provides another layer of protection against this loop.

---

# 3. Pipeline Steps

## Step 1 — Checkout Code

GitHub Actions first checks out the repository.

This provides the workflow with the source code, Maven project, Dockerfile, and Kubernetes manifests.

```yaml
- uses: actions/checkout@v4
```

The workflow can then build the application and modify the Kubernetes manifest.

---

## Step 2 — Set Up JDK 21

The AI-BankApp is a Java application, so the workflow installs Java 21.

Maven caching is also enabled to reduce build time by reusing previously downloaded dependencies.

```yaml
- name: Set up JDK 21
```

The result is a GitHub Actions runner containing the required Java environment for building the application.

---

## Step 3 — Build with Maven

The application is compiled and packaged using Maven.

```bash
./mvnw clean package -DskipTests -B
```

The important options are:

| Option        | Purpose                               |
| ------------- | ------------------------------------- |
| `clean`       | Removes previous build artifacts      |
| `package`     | Compiles and packages the application |
| `-DskipTests` | Skips tests during this build stage   |
| `-B`          | Runs Maven in batch mode              |

The output is the packaged application that will be included in the Docker image.

---

## Step 4 — Run Tests

Tests are executed separately:

```bash
./mvnw test -B
```

The workflow uses:

```yaml
continue-on-error: true
```

for this step.

This means test failures are reported but do not stop the remaining CI pipeline.

For a production system, whether tests should be non-blocking depends on the project's release policy. Critical automated tests would normally be configured to block deployment.

---

# 4. Generate the Docker Image Tag

The workflow generates a short Git commit SHA:

```bash
git rev-parse --short HEAD
```

Example:

```text
1c7cb0e
```

This value becomes the Docker image tag.

The resulting image can therefore be identified as:

```text
<dockerhub-username>/ai-bankapp-eks:1c7cb0e
```

This provides traceability between:

```text
Git Commit
     |
     v
Docker Image
     |
     v
Kubernetes Deployment
     |
     v
Running Pod
```

If a pod is running image `1c7cb0e`, the exact Git commit that produced that image can be identified.

---

# 5. DockerHub Authentication

GitHub Actions authenticates with DockerHub using GitHub Secrets.

The required secrets are:

```text
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```

The token is stored as a GitHub Actions secret instead of being written directly into the workflow.

This prevents credentials from being exposed in the repository.

---

# 6. Build and Push Docker Image

The application is packaged into a Docker image.

The image is pushed to DockerHub using the repository configured in:

```yaml
env:
  DOCKERHUB_REPO: <your-dockerhub-username>/ai-bankapp-eks
```

The pipeline maintains both:

```text
latest
```

and the commit-specific SHA tag.

For example:

```text
<username>/ai-bankapp-eks:latest
<username>/ai-bankapp-eks:1c7cb0e
```

The SHA tag is the important GitOps deployment tag because it provides immutable version traceability.

---

# 7. Update Kubernetes Manifest

After pushing the image, GitHub Actions modifies:

```text
k8s/bankapp-deployment.yml
```

The workflow uses:

```bash
sed -i "s|image: ${{ env.DOCKERHUB_REPO }}:.*|image: ${{ env.DOCKERHUB_REPO }}:${{ steps.tag.outputs.sha_short }}|" k8s/bankapp-deployment.yml
```

Before the update:

```yaml
image: <username>/ai-bankapp-eks:oldsha
```

After the update:

```yaml
image: <username>/ai-bankapp-eks:1c7cb0e
```

This is the critical connection between CI and GitOps CD.

GitHub Actions does not directly deploy the application to Kubernetes.

Instead, it changes the desired state stored in Git.

---

# 8. Commit the Manifest Change

The workflow configures Git:

```bash
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
```

It then stages the Kubernetes manifest:

```bash
git add k8s/bankapp-deployment.yml
```

The updated manifest is committed:

```bash
git commit -m "ci: update bankapp image to <sha> [skip ci]"
```

Finally, it pushes the commit:

```bash
git push
```

The Git repository now contains the desired Kubernetes state.

---

# 9. Why `[skip ci]` Is Important

The automatically generated manifest commit contains:

```text
[skip ci]
```

Example:

```text
ci: update bankapp image to 1c7cb0e [skip ci]
```

Without `[skip ci]`, the workflow could see its own manifest commit and start another CI run.

The sequence could become:

```text
CI runs
   |
   v
Manifest updated
   |
   v
Git commit
   |
   v
CI triggered again
   |
   v
Manifest updated again
   |
   v
Git commit
   |
   v
CI triggered again
```

`[skip ci]` prevents this unwanted loop.

---

# 10. ArgoCD GitOps Handoff

Once GitHub Actions pushes the updated manifest, ArgoCD becomes responsible for deployment.

```text
GitHub Actions
      |
      | Commit new image tag
      v
Git Repository
      |
      | ArgoCD detects change
      v
ArgoCD
      |
      | Compare desired vs actual
      v
EKS Cluster
```

ArgoCD compares:

```text
Git desired state
        vs
Kubernetes actual state
```

For example:

```text
Git:
image: ai-bankapp-eks:1c7cb0e

Cluster:
image: ai-bankapp-eks:oldsha
```

ArgoCD identifies the difference and performs synchronization.

---

# 11. Rolling Deployment

During synchronization, Kubernetes performs a rolling update.

Conceptually:

```text
OLD POD       NEW POD
   |             |
   |             +----> Starts new image
   |
   +------------------> Continues serving traffic
                         |
                         v
                    New pod healthy
                         |
                         v
                    Old pod removed
```

This allows the application to update without requiring the entire deployment to be unavailable simultaneously.

---

# 12. Verifying the Deployment

ArgoCD can be refreshed using:

```bash
argocd app get bankapp --refresh
```

The application can then be waited on using:

```bash
argocd app wait bankapp
```

Kubernetes pods can be monitored using:

```bash
kubectl get pods -n bankapp -w
```

The image running in the deployment can be checked with:

```bash
kubectl get deployment bankapp -n bankapp \
  -o jsonpath='{.spec.template.spec.containers[0].image}'
```

Expected result:

```text
<your-dockerhub-username>/ai-bankapp-eks:<new-sha>
```

---

# 13. Application Verification

The application can be accessed locally through port forwarding:

```bash
kubectl port-forward svc/bankapp-service -n bankapp 8080:8080
```

The application is then available at:

```text
http://localhost:8080
```

The customized application title or other visible code change can be used to verify that the new version successfully reached the EKS cluster.

---

# 14. Complete CI/CD Flow

The final automated deployment process is:

```text
1. Developer modifies application
              |
              v
2. git push origin feat/gitops
              |
              v
3. GitHub Actions starts
              |
              v
4. Checkout repository
              |
              v
5. Setup JDK 21
              |
              v
6. Maven build
              |
              v
7. Run tests
              |
              v
8. Generate Git SHA
              |
              v
9. Build Docker image
              |
              v
10. Push image to DockerHub
              |
              v
11. Update Kubernetes manifest
              |
              v
12. Commit manifest with [skip ci]
              |
              v
13. Push manifest to Git
              |
              v
14. ArgoCD detects Git change
              |
              v
15. ArgoCD compares desired state
              |
              v
16. ArgoCD synchronizes EKS
              |
              v
17. Kubernetes performs rolling update
              |
              v
18. New application version becomes live
```

No manual `kubectl set image` or manual Kubernetes deployment is required.

---

# 15. Drift Detection and Self-Healing

GitOps is not only about automated deployments. It also ensures that the Kubernetes cluster continuously moves back toward the desired state stored in Git.

The ArgoCD application was configured with self-healing enabled.

```text
Git = Source of Truth
        |
        v
     ArgoCD
        |
        v
   Kubernetes
        |
        |
   Unauthorized change
        |
        v
     Drift detected
        |
        v
 ArgoCD self-heals
        |
        v
Cluster returns to Git state
```

---

# 16. Drift Scenario 1 — Scaling the Deployment

The deployment was manually changed:

```bash
kubectl scale deployment bankapp -n bankapp --replicas=1
```

The change modifies the actual Kubernetes state without modifying Git.

ArgoCD therefore sees:

```text
Git desired replicas:     4
Cluster actual replicas:  1
```

This represents drift.

With:

```text
selfHeal: true
```

ArgoCD automatically reconciles the deployment and returns it to the replica count defined by Git.

### Result

```text
Manual change:
4 replicas -> 1 replica

ArgoCD:
Detects drift -> Reconciles

Final state:
1 replica -> 4 replicas
```

### Observed Detection Time

```text
Detection time: [ENTER YOUR OBSERVED TIME]
Recovery time:  [ENTER YOUR OBSERVED TIME]
```

### Screenshot

```text
![ArgoCD detecting replica drift](./screenshots/drift-replicas.png)
```

---

# 17. Drift Scenario 2 — Changing the Container Image

The container image was manually changed:

```bash
kubectl set image deployment/bankapp \
  bankapp=nginx:latest \
  -n bankapp
```

The cluster now contains:

```text
nginx:latest
```

while Git still specifies the AI-BankApp image.

ArgoCD detects the difference and restores the image defined in Git.

### Result

```text
Git:
ai-bankapp-eks:<correct-sha>

Cluster before self-healing:
nginx:latest

Cluster after self-healing:
ai-bankapp-eks:<correct-sha>
```

The BankApp pods are recreated using the correct image.

### Observed Detection Time

```text
Detection time: [ENTER YOUR OBSERVED TIME]
Recovery time:  [ENTER YOUR OBSERVED TIME]
```

### Screenshot

```text
![ArgoCD recovering image drift](./screenshots/drift-image.png)
```

---

# 18. Drift Scenario 3 — Deleting a Kubernetes Service

The service was manually deleted:

```bash
kubectl delete service bankapp-service -n bankapp
```

The Kubernetes cluster no longer contained the service, but the service definition still existed in Git.

ArgoCD detected that the resource was missing and recreated it.

### Result

```text
Git:
bankapp-service exists

Cluster:
bankapp-service deleted

ArgoCD:
Detects missing resource

Final state:
bankapp-service recreated
```

### Observed Detection Time

```text
Detection time: [ENTER YOUR OBSERVED TIME]
Recovery time:  [ENTER YOUR OBSERVED TIME]
```

### Screenshot

```text
![ArgoCD recreating deleted service](./screenshots/drift-service.png)
```

---

# 19. Drift Detection Summary

| Scenario          | Manual Change            | Expected ArgoCD Action    | Detection | Recovery |
| ----------------- | ------------------------ | ------------------------- | --------- | -------- |
| Replica drift     | Scale to 1               | Restore Git replica count | [time]    | [time]   |
| Image drift       | Change to `nginx:latest` | Restore Git image         | [time]    | [time]   |
| Resource deletion | Delete Service           | Recreate Service          | [time]    | [time]   |

The experiments demonstrate the central GitOps principle:

> The cluster should continuously converge toward the desired state stored in Git.

---

# 20. What Happens Without `selfHeal`?

If `selfHeal` is disabled, ArgoCD can still detect differences between Git and the cluster, but it will not automatically apply the correction.

The application can remain:

```text
OutOfSync
```

until a manual synchronization is performed.

With self-healing:

```text
Drift
  |
  v
Detected
  |
  v
Automatically corrected
```

Without self-healing:

```text
Drift
  |
  v
Detected
  |
  v
OutOfSync
  |
  v
Manual sync required
```

Self-healing therefore provides an important protection against unauthorized or accidental Kubernetes changes.

---

# 21. ArgoCD Application History

Deployment and synchronization history can be inspected with:

```bash
argocd app history bankapp
```

This provides an audit trail of application revisions and deployments.

The history makes it possible to correlate:

```text
Git commit
    |
    v
Image SHA
    |
    v
ArgoCD sync
    |
    v
Kubernetes deployment
```

This is one of the major advantages of using GitOps.

---

# 22. Complete 90 Days of DevOps Pipeline

The Day 86 pipeline connects the major technologies learned throughout the challenge.

```text
                    DEVELOPER
                        |
                        v
                 Git / GitHub
                 Day 22-28
                        |
                        v
              GitHub Actions CI
                 Day 40-49
                        |
          +-------------+-------------+
          |             |             |
          v             v             v
       Maven         Testing       Docker
                                      |
                                      v
                                  DockerHub
                                  Day 29-37
                                      |
                                      v
                           Kubernetes Manifest
                                      |
                                      v
                                  ArgoCD
                                 Day 84-86
                                      |
                                      v
                                    EKS
                                 Day 81-83
                                      |
                                      v
                              Kubernetes Pods
                                      |
                                      v
                                  Helm/HPA
                                 Day 78-80
                                      |
                                      v
                              Observability
                                 Day 73-77
                                      |
                         +------------+------------+
                         |                         |
                         v                         v
                    Prometheus                 Grafana
                         |
                         v
                       Alerts
                         |
                         v
                  Production System
```

Each block provides a capability required by the next stage.

---

# 23. Connection Between the DevOps Blocks

| Challenge Block | Technology               | Contribution                                  |
| --------------- | ------------------------ | --------------------------------------------- |
| Days 22-28      | Git & GitHub             | Source control                                |
| Days 29-37      | Docker                   | Application containerization                  |
| Days 40-49      | GitHub Actions           | CI automation                                 |
| Days 73-77      | Prometheus/Grafana       | Monitoring and observability                  |
| Days 78-80      | Helm/HPA                 | Kubernetes application management and scaling |
| Days 81-83      | Amazon EKS               | Production Kubernetes platform                |
| Day 84          | ArgoCD                   | GitOps deployment and self-healing            |
| Day 85          | ArgoCD advanced features | Sync strategies, App of Apps, RBAC            |
| Day 86          | Complete GitOps CI/CD    | Code-to-production automation                 |

---

# 24. Key GitOps Concepts Learned

## Git as the Source of Truth

The Kubernetes desired state is stored in Git.

Changes to the application deployment should therefore be represented through Git commits instead of manual cluster modifications.

---

## Declarative Infrastructure

Instead of telling Kubernetes exactly how to perform every operation, the desired state is declared in Kubernetes manifests.

ArgoCD continuously works to make the cluster match that declaration.

---

## Automated Reconciliation

ArgoCD continuously compares:

```text
Desired State
      vs
Actual State
```

Differences are detected and corrected according to the application's synchronization configuration.

---

## Self-Healing

Self-healing automatically restores resources that have been changed or deleted outside Git.

---

## Auditability

Git provides a history of:

```text
Who changed the code
What changed
When it changed
Which commit produced the deployment
```

ArgoCD provides the corresponding deployment and synchronization history.

---

## Immutable Image Traceability

Using the Git SHA as the Docker image tag allows an exact relationship between source code and deployed application.

```text
Git SHA
  |
  v
Docker Tag
  |
  v
Kubernetes Deployment
  |
  v
Running Container
```

---

# 25. Advantages of the Complete GitOps Pipeline

### Zero Manual Deployment

The developer does not need to manually run:

```bash
kubectl apply
kubectl set image
```

after the initial setup.

### Consistent Deployments

The same Git-based process is used for every application change.

### Automatic Rollouts

ArgoCD and Kubernetes handle the deployment and rolling update.

### Self-Healing

Unauthorized or accidental changes can be automatically reverted.

### Full Audit Trail

Git and ArgoCD maintain deployment history.

### Easy Rollback

Previous Git revisions can be restored and synchronized.

### Better Security

Developers do not need direct Kubernetes deployment access for normal application releases.

---

# 26. Teardown

After completing the experiments, all EKS and ArgoCD resources were scheduled for deletion to prevent unnecessary AWS charges.

## Step 1 — Delete ArgoCD Applications

```bash
argocd app delete bankapp --cascade -y
argocd app delete monitoring --cascade -y 2>/dev/null
argocd app delete envoy-gateway --cascade -y 2>/dev/null
argocd app delete root-app --cascade -y 2>/dev/null
```

The `--cascade` option is important because it tells ArgoCD to delete the Kubernetes resources managed by the applications.

---

## Step 2 — Verify Kubernetes Cleanup

```bash
kubectl get all -n bankapp 2>/dev/null
```

```bash
kubectl get all -n monitoring 2>/dev/null
```

Expected result:

```text
No resources found
```

or only resources that were intentionally left outside the deleted ArgoCD applications.

---

# 27. Destroy EKS Infrastructure

The Terraform configuration was used to destroy the EKS infrastructure.

```bash
cd AI-BankApp-DevOps/terraform
terraform destroy
```

Terraform displays the resources scheduled for deletion.

After reviewing the plan:

```text
yes
```

is entered to confirm the destruction.

The destroy process may take several minutes because AWS resources such as load balancers, networking components, EKS resources, and storage need to be removed.

---

# 28. AWS Cleanup Verification

After Terraform destruction, the AWS environment should be checked for remaining resources.

### EKS

Verify that the EKS cluster no longer exists.

```text
EKS:
[ ] No bankapp EKS cluster
```

### EC2

Verify that worker nodes have been terminated.

```text
EC2:
[ ] No EKS worker instances
```

### Load Balancers

Verify that Kubernetes-created load balancers have been removed.

```text
Load Balancers:
[ ] No unused bankapp load balancers
```

### EBS

Verify that unused EBS volumes are not remaining.

```text
EBS:
[ ] No unused bankapp volumes
```

### VPC

Verify that the Terraform-managed VPC and associated resources have been destroyed.

```text
VPC:
[ ] bankapp-eks VPC removed
```

### IAM

Check for unused IAM roles created specifically for the EKS project.

```text
IAM:
[ ] No unused bankapp-eks roles
```

---

# 29. Teardown Verification Screenshots

The following screenshots should be added to this document after completing the teardown.

```text
![ArgoCD applications deleted](./screenshots/argocd-teardown.png)

![Terraform destroy completed](./screenshots/terraform-destroy.png)

![EKS cluster removed](./screenshots/eks-deleted.png)

![AWS resources verified](./screenshots/aws-cleanup.png)
```

---

# 30. AWS Cost Verification

The AWS Billing Dashboard was checked after the EKS resources were destroyed.

Expected result:

```text
EKS Cluster:        Deleted
EC2 Instances:      Deleted
Load Balancers:     Deleted
EBS Volumes:        Cleaned
VPC:                Destroyed
```

AWS billing data can take some time to update, so the final billing dashboard should be checked again after the resources have been terminated.

---

# 31. Three-Day GitOps Journey

| Day        | Work Completed                                                                    |
| ---------- | --------------------------------------------------------------------------------- |
| **Day 84** | ArgoCD setup, first GitOps deployment, self-healing                               |
| **Day 85** | Sync waves, rollbacks, App of Apps, notifications, RBAC                           |
| **Day 86** | Complete CI/CD pipeline, code-to-production deployment, drift detection, teardown |

The three days progressed from basic GitOps deployment to advanced ArgoCD configuration and finally to a complete automated production workflow.

---

# 32. Final Validation Checklist

| Validation                                | Status |
| ----------------------------------------- | ------ |
| GitHub Actions workflow configured        | [ ]    |
| GitHub Secrets configured                 | [ ]    |
| DockerHub authentication working          | [ ]    |
| Application successfully built            | [ ]    |
| Tests executed                            | [ ]    |
| Docker image pushed                       | [ ]    |
| SHA image tag generated                   | [ ]    |
| Kubernetes manifest automatically updated | [ ]    |
| Manifest committed by GitHub Actions      | [ ]    |
| `[skip ci]` used                          | [ ]    |
| ArgoCD detected Git change                | [ ]    |
| ArgoCD synchronized application           | [ ]    |
| Rolling update completed                  | [ ]    |
| Application change verified               | [ ]    |
| Replica drift recovered                   | [ ]    |
| Image drift recovered                     | [ ]    |
| Deleted service recreated                 | [ ]    |
| ArgoCD application history checked        | [ ]    |
| ArgoCD applications deleted               | [ ]    |
| Terraform destroy completed               | [ ]    |
| AWS resources verified                    | [ ]    |
| Final cost check completed                | [ ]    |

---

# 33. Key Takeaways

1. GitHub Actions can automate the complete CI portion of a deployment pipeline.

2. Docker images can be tagged using Git commit SHAs to provide exact deployment traceability.

3. GitHub Actions should update the Kubernetes desired state in Git rather than directly modifying the production cluster in a GitOps architecture.

4. ArgoCD continuously monitors Git and synchronizes Kubernetes with the declared desired state.

5. `[skip ci]` prevents the automatically generated manifest commit from triggering another CI pipeline execution.

6. ArgoCD self-healing protects the cluster from unauthorized or accidental changes.

7. GitOps provides an auditable deployment history because application changes and deployment configuration are represented as Git commits.

8. The complete pipeline connects source control, CI, containerization, Kubernetes, GitOps, cloud infrastructure, autoscaling, and observability.

9. The Git SHA image tag creates a clear relationship between source code, Docker image, and running Kubernetes workload.

10. Proper teardown is essential when using AWS resources in a learning environment to avoid unnecessary costs.

---

# 34. Final Pipeline

The completed AI-BankApp GitOps pipeline can be summarized as:

```text
                  ┌─────────────────┐
                  │    Developer    │
                  └────────┬────────┘
                           │
                       git push
                           │
                           v
                  ┌─────────────────┐
                  │     GitHub      │
                  │  feat/gitops    │
                  └────────┬────────┘
                           │
                           v
                  ┌─────────────────┐
                  │ GitHub Actions  │
                  │       CI        │
                  └────────┬────────┘
                           │
             ┌─────────────┼─────────────┐
             │             │             │
             v             v             v
          Maven          Tests        Docker
                                         │
                                         v
                                    DockerHub
                                         │
                                         v
                              Update K8s Manifest
                                         │
                                         v
                                  Git Commit
                                         │
                                         v
                                  ┌──────────┐
                                  │  ArgoCD  │
                                  └────┬─────┘
                                       │
                              Git reconciliation
                                       │
                                       v
                                  ┌──────────┐
                                  │   EKS    │
                                  └────┬─────┘
                                       │
                                  Rolling Update
                                       │
                                       v
                                  AI-BankApp
                                       │
                                       v
                                  Production

                         + Self-Healing
                         + Drift Detection
                         + Audit Trail
                         + Automated Sync
```

## Conclusion

Day 86 completed the GitOps implementation for AI-BankApp by connecting application development, continuous integration, container image publishing, Kubernetes configuration, ArgoCD, and Amazon EKS into one automated workflow.

A normal application change begins with a Git push. GitHub Actions builds and tests the application, creates a Docker image tagged with the Git commit SHA, pushes the image to DockerHub, and updates the Kubernetes manifest in Git. ArgoCD then detects the Git change and synchronizes the new desired state to EKS.

The drift experiments demonstrated another important GitOps capability: changes made directly to the cluster do not become the permanent source of truth. When the cluster diverges from Git, ArgoCD detects the difference and, with self-healing enabled, restores the declared state.

This completes the three-day ArgoCD block:

```text
Day 84 → GitOps Fundamentals + Self-Healing
Day 85 → Advanced ArgoCD Features
Day 86 → Complete CI/CD + Drift Recovery + Teardown
```

