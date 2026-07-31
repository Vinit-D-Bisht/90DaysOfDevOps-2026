# Day 80 — Helm Project: Multi-Environment Deployment and CI/CD

> **Project:** AI-BankApp DevOps
> **Day:** 80
> **Topic:** Helm — Multi-Environment Deployment, Hooks, Packaging & GitOps CI/CD
> **Repository:** `AI-BankApp-DevOps`
> **Branch:** `feat/gitops`

---

## Overview

Day 80 brings together the Helm concepts covered during Days 78 and 79 and applies them to the AI-BankApp.

The goal is to evolve the custom Helm chart into a reusable, multi-environment deployment solution supporting:

* Development
* Staging
* Production
* Environment-specific resource configuration
* Horizontal Pod Autoscaling
* MySQL readiness validation
* Helm tests
* Chart packaging and versioning
* GitOps-based CI/CD
* ArgoCD Helm integration
* Production deployment best practices

The central idea is:

> **One Helm chart, multiple environments, minimal duplication.**

The AI-BankApp consists of a Spring Boot application, MySQL database, and Ollama AI service. Helm allows these components to be packaged together while environment-specific behavior is controlled through values files.

---

# 1. Environment-Specific Values

The same `bankapp/` Helm chart is used across all environments.

Instead of creating separate Kubernetes manifests for every environment, environment-specific configuration is stored in:

```text
bankapp/
├── values.yaml
├── values-dev.yaml
├── values-staging.yaml
└── values-prod.yaml
```

This separates the application templates from deployment configuration.

---

## Development Environment

File:

```text
bankapp/values-dev.yaml
```

```yaml
bankapp:
  replicaCount: 1
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "latest"
    pullPolicy: Always
  resources:
    requests:
      memory: "256Mi"
      cpu: "100m"
    limits:
      memory: "512Mi"
      cpu: "250m"
  autoscaling:
    enabled: false

mysql:
  enabled: true
  resources:
    requests:
      memory: "128Mi"
      cpu: "100m"
    limits:
      memory: "256Mi"
      cpu: "250m"
  persistence:
    size: 2Gi
    storageClass: standard

ollama:
  enabled: true
  model: tinyllama
  resources:
    requests:
      memory: "1Gi"
      cpu: "500m"
    limits:
      memory: "1.5Gi"
      cpu: "1000m"
  persistence:
    size: 5Gi
    storageClass: standard

storageClass:
  create: false
```

### Development characteristics

The development environment is optimized for local Kubernetes testing and low resource consumption.

* One BankApp replica
* HPA disabled
* `latest` image tag
* Small MySQL storage
* Lower CPU and memory requirements
* Ollama enabled with the `tinyllama` model
* Uses the existing `standard` storage class
* Suitable for a Kind cluster

---

## Staging Environment

File:

```text
bankapp/values-staging.yaml
```

```yaml
bankapp:
  replicaCount: 2
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "v1.2.0"
    pullPolicy: IfNotPresent
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 3
    targetCPUUtilization: 75

mysql:
  enabled: true
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  persistence:
    size: 5Gi
    storageClass: gp3

ollama:
  enabled: true
  model: tinyllama
  persistence:
    size: 10Gi
    storageClass: gp3

secrets:
  mysqlRootPassword: StagingPass@456
  mysqlUser: root
  mysqlPassword: StagingPass@456

storageClass:
  create: true
```

### Staging characteristics

Staging is closer to production and introduces autoscaling and larger resource allocations.

* Two initial BankApp replicas
* HPA enabled
* Scales between 2 and 3 replicas
* CPU target of 75%
* Versioned application image
* Larger MySQL persistence
* AWS `gp3` storage class
* Larger Ollama persistence

---

## Production Environment

File:

```text
bankapp/values-prod.yaml
```

```yaml
bankapp:
  replicaCount: 4
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "v1.2.0"
    pullPolicy: IfNotPresent
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 4
    targetCPUUtilization: 70

mysql:
  enabled: true
  resources:
    requests:
      memory: "512Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1000m"
  persistence:
    size: 20Gi
    storageClass: gp3

ollama:
  enabled: true
  model: tinyllama
  resources:
    requests:
      memory: "2Gi"
      cpu: "900m"
    limits:
      memory: "2.5Gi"
      cpu: "1500m"
  persistence:
    size: 10Gi
    storageClass: gp3

secrets:
  mysqlRootPassword: ProdSecure@789
  mysqlUser: root
  mysqlPassword: ProdSecure@789

storageClass:
  create: true

gateway:
  enabled: true
```

### Production characteristics

Production receives the highest resource allocation and enables the Gateway.

* Higher initial replica count
* HPA enabled
* Scales between 2 and 4 replicas
* CPU target of 70%
* Versioned application image
* 20Gi MySQL persistent storage
* Higher MySQL CPU and memory
* Larger Ollama resources
* AWS `gp3` storage
* Gateway enabled

---

## Environment Comparison

| Setting           | Development | Staging      | Production   |
| ----------------- | ----------- | ------------ | ------------ |
| BankApp replicas  | 1 fixed     | 2–3 HPA      | 2–4 HPA      |
| Image tag         | `latest`    | `v1.2.0`     | `v1.2.0`     |
| Image pull policy | Always      | IfNotPresent | IfNotPresent |
| HPA               | Disabled    | Enabled      | Enabled      |
| HPA CPU target    | —           | 75%          | 70%          |
| MySQL storage     | 2Gi         | 5Gi          | 20Gi         |
| MySQL memory      | 128Mi       | 256Mi        | 512Mi        |
| MySQL CPU         | 100m        | 250m         | 500m         |
| Ollama memory     | 1Gi         | 2Gi          | 2.5Gi        |
| Ollama storage    | 5Gi         | 10Gi         | 10Gi         |
| Storage class     | standard    | gp3          | gp3          |
| Gateway           | Disabled    | Disabled     | Enabled      |

The same templates can therefore produce significantly different Kubernetes deployments.

---

## Deploying the Environments

### Development

```bash
helm install bankapp-dev bankapp/ \
  -f bankapp/values-dev.yaml \
  -n dev \
  --create-namespace
```

### Staging render check

```bash
helm template bankapp-staging bankapp/ \
  -f bankapp/values-staging.yaml | grep "replicas:"
```

### Production render check

```bash
helm template bankapp-prod bankapp/ \
  -f bankapp/values-prod.yaml | grep "replicas:"
```

`helm template` is useful for validating the generated Kubernetes manifests before actually deploying them.

---

# 2. Helm Hooks

Helm hooks allow specific Kubernetes resources to participate in the Helm release lifecycle.

For the AI-BankApp, a `pre-install` and `pre-upgrade` hook is used to check MySQL availability.

File:

```text
bankapp/templates/pre-install-job.yaml
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "bankapp.fullname" . }}-db-ready
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "bankapp.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": before-hook-creation
spec:
  template:
    spec:
      containers:
        - name: db-check
          image: busybox:1.36
          command:
            - /bin/sh
            - -c
            - |
              echo "Waiting for MySQL to be ready..."
              until nc -z {{ include "bankapp.fullname" . }}-mysql 3306; do
                echo "MySQL not ready, retrying in 3s..."
                sleep 3
              done
              echo "MySQL is ready!"
          resources:
            requests:
              memory: "32Mi"
              cpu: "50m"
            limits:
              memory: "64Mi"
              cpu: "100m"
      restartPolicy: Never
  backoffLimit: 10
```

---

## Hook Annotations

### `helm.sh/hook`

```yaml
"helm.sh/hook": pre-install,pre-upgrade
```

This tells Helm to execute the Job before:

* A new release is installed
* An existing release is upgraded

The database readiness check therefore happens as part of the Helm lifecycle.

---

### `helm.sh/hook-weight`

```yaml
"helm.sh/hook-weight": "0"
```

Hook weights control ordering when multiple hooks of the same lifecycle event exist.

Lower weights execute first.

A weight of `0` gives this hook the default ordering.

---

### `helm.sh/hook-delete-policy`

```yaml
"helm.sh/hook-delete-policy": before-hook-creation
```

This removes the previous hook Job before Helm creates a new one.

This is useful because Kubernetes Jobs cannot simply be recreated with the same name while an old Job still exists.

---

## Database Readiness Flow

The deployment flow becomes:

```text
helm install / helm upgrade
          |
          v
   Helm pre-install/
   pre-upgrade hook
          |
          v
     DB readiness
        check
          |
     +----+----+
     |         |
   Not ready  Ready
     |         |
     v         v
   Retry     Continue
     |         |
     +----+----+
          |
          v
 BankApp deployment
          |
          v
 Application init
 container checks DB
```

The Helm hook and the application's existing init container provide defense-in-depth.

The hook validates database availability at the Helm deployment level, while the application's init container protects the application at pod startup.

---

# 3. Helm Test

A Helm test can validate that the deployed application is responding correctly.

File:

```text
bankapp/templates/tests/test-connection.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: {{ include "bankapp.fullname" . }}-test
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "bankapp.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: test
      image: busybox:1.36
      command:
        - sh
        - -c
        - wget -qO- http://{{ include "bankapp.fullname" . }}-service:8080/actuator/health
  restartPolicy: Never
```

Run the test with:

```bash
helm test bankapp-dev -n dev
```

The test calls the Spring Boot Actuator health endpoint.

A successful result indicates that the BankApp service is reachable and its health endpoint responds.

---

# 4. Packaging and Versioning

Before packaging the chart, it should be linted.

```bash
helm lint bankapp/
```

If the lint succeeds, package the chart:

```bash
helm package bankapp/
```

This produces:

```text
bankapp-0.1.0.tgz
```

---

## Chart Version Bump

After adding the hooks and making structural changes, the chart version can be updated in `Chart.yaml`.

```yaml
version: 0.2.0
appVersion: "1.1.0"
```

The distinction is important:

* `version` represents the Helm chart version.
* `appVersion` represents the application version.

Repackage:

```bash
helm package bankapp/
```

The project can now contain:

```text
bankapp-0.1.0.tgz
bankapp-0.2.0.tgz
```

---

## Installing the Packaged Chart

A packaged chart can be installed directly:

```bash
helm install my-bankapp bankapp-0.2.0.tgz \
  -f bankapp/values-dev.yaml \
  -n bankapp \
  --create-namespace
```

This demonstrates that the chart can be distributed independently from its source directory.

---

# 5. Helm Chart Repository

A simple chart repository can be created for sharing packaged charts.

```bash
mkdir chart-repo
cp bankapp-*.tgz chart-repo/
```

Generate the repository index:

```bash
helm repo index chart-repo/ \
  --url https://your-username.github.io/helm-charts
```

Inspect the generated index:

```bash
cat chart-repo/index.yaml
```

The resulting repository can be hosted using GitHub Pages or another static web host.

---

# 6. Helm and the AI-BankApp GitOps Pipeline

The AI-BankApp currently follows a GitOps model using GitHub Actions and ArgoCD.

## Current Pipeline

The existing raw-manifest workflow can be represented as:

```text
Developer pushes code
        |
        v
GitHub Actions
        |
        v
Build Docker image
        |
        v
Tag image with Git SHA
        |
        v
Update k8s/bankapp-deployment.yml
        |
        v
Commit change to Git
        |
        v
ArgoCD detects Git change
        |
        v
Sync Kubernetes manifests
        |
        v
EKS
```

The Kubernetes deployment is therefore controlled by Git.

---

# 7. GitOps Pipeline with Helm

With Helm, the pipeline can move from directly modifying raw manifests to modifying Helm values.

The proposed flow becomes:

```text
Developer pushes code
        |
        v
GitHub Actions
        |
        v
Build Docker image
        |
        v
Generate Git SHA image tag
        |
        v
Update values-prod.yaml
        |
        v
Commit Helm values
        |
        v
ArgoCD detects Git change
        |
        v
ArgoCD renders Helm chart
        |
        v
Kubernetes resources
        |
        v
EKS
```

The major change is that the desired state is represented by Helm values instead of manually maintained deployment YAML.

---

## Updating Helm Values in CI

A GitHub Actions step could use `yq` to update the image tag:

```yaml
- name: Update Helm values with new image tag
  run: |
    TAG=${{ steps.tag.outputs.sha_short }}
    yq -i '.bankapp.image.tag = "'$TAG'"' helm-chart/bankapp/values-prod.yaml
```

Using `yq` is preferable to using `sed` for YAML modifications because it understands YAML structure.

The updated file can then be committed:

```yaml
- name: Commit updated Helm values
  run: |
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add helm-chart/bankapp/values-prod.yaml
    git diff --staged --quiet || git commit -m "ci: update bankapp image to $TAG [skip ci]"
    git push
```

The important GitOps principle is maintained:

> **Git remains the source of truth for the desired deployment state.**

---

# 8. ArgoCD Helm Integration

The current ArgoCD application points to raw Kubernetes manifests:

```yaml
source:
  path: k8s
```

With Helm, the source can instead point to the chart:

```yaml
source:
  path: helm-chart/bankapp
  helm:
    valueFiles:
      - values-prod.yaml
```

ArgoCD has native Helm support.

It renders the chart and applies the resulting Kubernetes resources to the cluster.

The pipeline therefore does not require CI to manually render the Helm chart and commit generated Kubernetes YAML.

Instead:

```text
Git
 |
 | Helm chart + values
 v
ArgoCD
 |
 | Helm rendering
 v
Kubernetes manifests
 |
 v
EKS
```

This keeps the Git repository clean and maintains a declarative GitOps workflow.

---

# 9. Advantages of Helm with ArgoCD

## 1. Multi-Environment Configuration

A single chart can support:

```text
values-dev.yaml
values-staging.yaml
values-prod.yaml
```

This avoids maintaining three independent copies of Kubernetes manifests.

---

## 2. Reduced Duplication

Common Kubernetes configuration lives in templates.

Only environment-specific values need to change.

For example:

```yaml
bankapp:
  image:
    tag: "v1.2.0"
```

can change without duplicating the entire Deployment.

---

## 3. Versioned Deployments

Helm charts are versioned.

Example:

```text
bankapp-0.1.0.tgz
bankapp-0.2.0.tgz
```

This provides a clear history of chart changes.

---

## 4. Reusable Templates

Resources such as:

* Deployments
* Services
* ConfigMaps
* Secrets
* PVCs
* HPA
* Jobs
* Tests

can be generated from reusable templates.

---

## 5. Native ArgoCD Support

ArgoCD understands Helm charts natively.

There is no requirement to manually render the templates before ArgoCD syncs the application.

---

## 6. Drift Detection

ArgoCD continuously compares the desired state in Git with the state in the Kubernetes cluster.

If resources drift from the desired state, ArgoCD can identify the difference and optionally synchronize it.

---

## 7. Easier Environment Promotion

A typical promotion process could be:

```text
Development
    |
    v
Staging
    |
    v
Production
```

Each environment can use a controlled values file or Git configuration change.

This makes promotion more explicit and auditable.

---

# 10. Helm vs Raw Manifests vs Kustomize

| Approach      | Best For                                                                      | AI-BankApp Example                                                     |
| ------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Raw manifests | Simple, single-environment applications                                       | Existing `k8s/` directory                                              |
| Helm          | Complex applications, reusable templates, multiple environments, dependencies | Custom chart containing BankApp, MySQL, Ollama, HPA and hooks          |
| Kustomize     | Overlaying and patching existing manifests without introducing templates      | Applying environment-specific patches to the existing `k8s/` resources |

---

## Raw Kubernetes Manifests

Raw manifests are straightforward and easy to understand.

Example:

```text
k8s/
├── deployment.yaml
├── service.yaml
├── mysql.yaml
└── configmap.yaml
```

### Advantages

* Simple
* Native Kubernetes YAML
* Easy to debug
* No templating language

### Disadvantages

* Duplication across environments
* Difficult to manage many variations
* Less reusable for complex applications

Raw manifests make sense for a simple single-environment application.

---

## Helm

Helm is appropriate when the application has:

* Multiple environments
* Many Kubernetes resources
* Dependencies
* Configurable resource requirements
* Optional components
* Reusable templates
* Packaging requirements

The AI-BankApp is a good Helm use case because it includes:

```text
Spring Boot
    +
MySQL
    +
Ollama
    +
HPA
    +
Persistent Volumes
    +
Hooks
    +
Tests
```

Helm provides one reusable deployment package for these components.

---

## Kustomize

Kustomize is useful when the base Kubernetes manifests are already suitable and only environment-specific patches are required.

A possible structure would be:

```text
k8s/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── mysql.yaml
│
└── overlays/
    ├── dev/
    ├── staging/
    └── prod/
```

Kustomize is particularly useful when the team prefers standard Kubernetes YAML and does not need Helm's templating and packaging model.

---

# 11. Production Helm Best Practices

## Use `helm upgrade --install`

A production deployment should generally use:

```bash
helm upgrade --install bankapp bankapp/ \
  -f bankapp/values-prod.yaml \
  --set bankapp.image.tag=$GIT_SHA \
  -n bankapp \
  --create-namespace \
  --wait \
  --timeout 300s \
  --atomic
```

### `--install`

Creates the release if it does not exist.

If the release already exists, Helm performs an upgrade.

---

### `--set`

```bash
--set bankapp.image.tag=$GIT_SHA
```

Pins the deployment to a specific Git commit rather than relying on a mutable tag such as:

```text
latest
```

This improves traceability and reproducibility.

---

### `--wait`

```bash
--wait
```

Helm waits for Kubernetes resources to become ready before considering the release successful.

---

### `--timeout`

```bash
--timeout 300s
```

Allows enough time for resources such as databases and AI workloads to become ready.

---

### `--atomic`

```bash
--atomic
```

Automatically rolls back the release if the upgrade fails.

This is particularly important in CI/CD because it prevents partially deployed releases from remaining in the cluster.

---

# 12. Helm Diff

Before upgrading production, it is useful to inspect the proposed changes.

Install the Helm Diff plugin:

```bash
helm plugin install https://github.com/databus23/helm-diff
```

Run:

```bash
helm diff upgrade bankapp bankapp/ \
  -f bankapp/values-prod.yaml
```

This shows the changes that would be applied.

The workflow becomes:

```text
Helm chart
    |
    v
helm diff
    |
    v
Review changes
    |
    v
helm upgrade
```

This reduces the risk of blindly applying unexpected changes.

---

# 13. Resource Quotas

Production namespaces should have resource limits at the namespace level.

Example:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: {{ include "bankapp.fullname" . }}-quota
  namespace: {{ .Release.Namespace }}
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
```

A ResourceQuota prevents workloads in the namespace from consuming unlimited cluster resources.

This is especially useful when multiple workloads share the same Kubernetes cluster.

---

# 14. Production Secrets Management

The supplied staging and production values demonstrate the structure of the configuration, but storing real credentials directly inside Git-managed values files is **not recommended**.

For example, this should not contain real production credentials:

```yaml
secrets:
  mysqlRootPassword: ProdSecure@789
  mysqlUser: root
  mysqlPassword: ProdSecure@789
```

Instead, production should use a dedicated secrets-management solution.

Possible approaches include:

### External Secrets Operator

External Secrets Operator can synchronize secrets from systems such as AWS Secrets Manager into Kubernetes.

A production architecture could be:

```text
AWS Secrets Manager
        |
        v
External Secrets Operator
        |
        v
Kubernetes Secret
        |
        v
AI-BankApp
```

---

### Sealed Secrets

Bitnami Sealed Secrets can be used to store encrypted secret manifests in Git.

The cluster-side controller decrypts them into Kubernetes Secrets.

---

### HashiCorp Vault

Vault provides centralized secret storage, access policies, auditing, and secret lifecycle management.

---

## Recommended Production Approach

For an AWS/EKS deployment, a strong production design would be:

```text
AWS Secrets Manager
        |
        v
External Secrets Operator
        |
        v
Kubernetes Secret
        |
        v
BankApp / MySQL
```

The Git repository would contain references to the secret rather than the secret value itself.

---

# 15. Helm Values Layering

Helm supports multiple values files.

For example:

```bash
helm install bankapp bankapp/ \
  -f bankapp/values.yaml \
  -f bankapp/values-prod.yaml
```

The later file overrides values from the earlier file.

Therefore:

```text
values.yaml
     |
     v
values-prod.yaml
     |
     v
Final rendered configuration
```

This allows common defaults to live in `values.yaml` while environment-specific values override them.

For production CI/CD, sensitive values can also be supplied through pipeline mechanisms rather than committed files.

---

# 16. Helm Hooks in the Release Lifecycle

The AI-BankApp currently uses a database readiness mechanism in the application's Kubernetes deployment.

Helm hooks provide an additional deployment-level mechanism.

Useful Helm hooks include:

| Hook           | Purpose                          |
| -------------- | -------------------------------- |
| `pre-install`  | Run before installing a release  |
| `pre-upgrade`  | Run before upgrading a release   |
| `post-install` | Run after installation           |
| `post-upgrade` | Run after upgrade                |
| `pre-delete`   | Run before deleting a release    |
| `test`         | Run application validation tests |

Possible AI-BankApp applications include:

### `pre-install`

Check database readiness.

### `pre-upgrade`

Verify database connectivity before an application upgrade.

### `post-install`

Run initialization or database migration tasks.

### `pre-delete`

Potentially trigger a database backup before teardown.

### `test`

Check the Spring Boot health endpoint.

---

# 17. Important Helm Hook Consideration

Helm hooks operate outside the normal release resource lifecycle.

This means hook-created resources have different lifecycle behavior from standard chart resources.

For example, hook Jobs should have appropriate deletion policies such as:

```yaml
"helm.sh/hook-delete-policy": before-hook-creation
```

This prevents old hook Jobs from interfering with future releases.

Hooks should therefore be used intentionally rather than for every deployment resource.

---

# 18. Gateway and Cluster-Level Infrastructure

The AI-BankApp Gateway and cert-manager resources can also be represented through templates, but cluster-level infrastructure is often better managed separately.

For example:

```text
Application Helm Chart
        |
        +-- BankApp
        +-- MySQL
        +-- Ollama
        +-- HPA
        +-- Services
        +-- Application-specific resources

Cluster Infrastructure
        |
        +-- cert-manager
        +-- Ingress/Gateway infrastructure
        +-- Load balancers
        +-- Cluster-wide policies
```

Keeping application and cluster infrastructure separate can reduce coupling and simplify ownership.

---

# 19. Verification and Cleanup

List all Helm releases:

```bash
helm list -A
```

Check the development release:

```bash
helm list -n dev
```

Run the Helm test:

```bash
helm test bankapp-dev -n dev
```

Uninstall the development release:

```bash
helm uninstall bankapp-dev -n dev
```

Delete the development namespace:

```bash
kubectl delete namespace dev
```

Delete the Kind cluster:

```bash
kind delete cluster --name tws-cluster
```

---

# 20. Three-Day Helm Journey

The three Helm days progressively transformed the AI-BankApp deployment model.

| Day    | Concept                                               | AI-BankApp Connection                                                    |
| ------ | ----------------------------------------------------- | ------------------------------------------------------------------------ |
| Day 78 | Helm install, repositories, values, upgrade, rollback | Deployed MySQL for the BankApp using the Bitnami Helm chart              |
| Day 79 | Custom chart creation and Go templates                | Converted 12 raw Kubernetes manifests into a reusable Helm chart         |
| Day 80 | Multi-environment values, hooks, packaging and CI/CD  | Created a production-oriented chart with dev/staging/prod configurations |

---

## Day 78 — Helm Fundamentals

The first day focused on understanding Helm itself:

* Helm repositories
* Helm charts
* `helm install`
* `helm upgrade`
* `helm rollback`
* Values
* Chart configuration

The AI-BankApp connection was deploying MySQL using an existing Bitnami Helm chart.

---

## Day 79 — Custom Helm Chart

The second day moved from consuming an existing chart to building a custom chart.

The raw Kubernetes resources were converted into reusable Helm templates.

The chart could then generate multiple Kubernetes resources from one reusable structure.

---

## Day 80 — Production-Oriented Helm

Day 80 connected everything together:

* Multiple environment values
* HPA configuration
* Resource tuning
* Storage configuration
* Helm hooks
* Helm tests
* Chart versioning
* Chart packaging
* Helm repositories
* CI/CD integration
* ArgoCD integration
* Production deployment practices
* Secrets management

The result is a much more scalable deployment model.

---

# 21. Final Architecture

The final conceptual architecture looks like:

```text
                    Git Repository
                         |
             +-----------+-----------+
             |                       |
       Helm Chart              GitHub Actions
             |                       |
             |                 Build Docker Image
             |                       |
             |                 Generate Git SHA
             |                       |
             |                 Update Helm values
             |                       |
             +-----------+-----------+
                         |
                         v
                       Git
                         |
                         v
                      ArgoCD
                         |
                    Helm rendering
                         |
                         v
                    Kubernetes
                         |
       +-----------------+-----------------+
       |                 |                 |
       v                 v                 v
   BankApp             MySQL            Ollama
 Spring Boot                         AI inference
       |
       v
      HPA
       |
       v
 Multiple replicas
```

---

# 22. Final Deployment Strategy

The production deployment strategy can be summarized as:

```bash
helm upgrade --install bankapp bankapp/ \
  -f bankapp/values-prod.yaml \
  --set bankapp.image.tag=$GIT_SHA \
  -n bankapp \
  --create-namespace \
  --wait \
  --timeout 300s \
  --atomic
```

The deployment process provides:

* Declarative configuration
* Environment-specific values
* Immutable image references
* Automated rollback
* Deployment readiness checks
* Helm hooks
* Application health tests
* Git-based change tracking
* ArgoCD synchronization

---

# 23. Key Learnings

### 1. One chart can serve multiple environments

Instead of maintaining separate Kubernetes manifests, Helm allows the same chart to be configured differently for development, staging, and production.

### 2. Values separate configuration from templates

Templates define *how* resources are created while values define *how the application should run* in a particular environment.

### 3. Hooks extend the deployment lifecycle

The database readiness hook provides an additional safety mechanism around application deployment.

### 4. Helm tests provide post-deployment validation

`helm test` can verify that the deployed application is reachable and functioning.

### 5. Chart versions and application versions are different

The Helm chart version tracks changes to deployment templates, while `appVersion` represents the application version.

### 6. `--atomic` is valuable in production

Automatic rollback prevents failed deployments from leaving partially updated resources behind.

### 7. Git remains the source of truth

When combined with ArgoCD, Helm does not replace GitOps. Instead, Helm becomes the packaging and templating mechanism used to describe the desired Kubernetes state.

### 8. Secrets should not live in Git

Production credentials should be stored in a dedicated secret-management system such as AWS Secrets Manager, accessed through External Secrets Operator or another secure integration.
