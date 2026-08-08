# Day 84 — Introduction to GitOps and ArgoCD

## Overview

Day 84 marks the beginning of the GitOps block of the 90 Days of DevOps journey.

Previously, the AI-BankApp was deployed to Kubernetes using `kubectl apply`. Although this works, it depends on a person or CI/CD pipeline directly accessing the Kubernetes cluster. This can make it difficult to determine who changed the cluster, whether the deployed configuration matches Git, and whether manual changes have introduced configuration drift.

GitOps solves this problem by making **Git the single source of truth** for the desired state of the application and infrastructure.

For this project, **ArgoCD** continuously monitors the Git repository and compares the Kubernetes manifests stored in Git with the actual state of the EKS cluster. When differences are detected, ArgoCD can automatically synchronize the cluster with Git.

---

# 1. GitOps Principles

## What is GitOps?

GitOps is a way of managing applications and infrastructure where the desired state is stored in a Git repository.

Instead of manually running commands such as:

```bash
kubectl apply -f deployment.yaml
```

the Kubernetes manifests are committed to Git. ArgoCD watches the repository and continuously works to make the Kubernetes cluster match those manifests.

The basic idea is:

```text
Git Repository
      |
      | Desired State
      v
   ArgoCD
      |
      | Reconciliation
      v
 Kubernetes / EKS
      |
      | Actual State
      v
   Application
```

If somebody manually changes a resource in the cluster, the actual state becomes different from the desired state stored in Git. ArgoCD detects this difference and, when self-healing is enabled, restores the resource to the state defined in Git.

### Git becomes the source of truth

Git provides:

* Version history
* Change tracking
* Pull requests
* Code review
* Rollbacks
* Auditability
* A clear record of who changed what

This means application configuration is managed through controlled Git changes rather than arbitrary commands executed directly against the cluster.

---

## Four GitOps Principles

### 1. Declarative

The desired state is described declaratively.

For Kubernetes, this is normally represented using YAML manifests.

For example:

```yaml
spec:
  replicas: 4
```

This does not describe the commands required to create four Pods. Instead, it declares that the Deployment should have four replicas.

---

### 2. Versioned and Immutable

The desired state is stored in Git and therefore has complete version history.

Every change can be associated with a commit:

```text
Commit A
   |
Commit B
   |
Commit C
```

If a deployment change causes problems, the Git history can be used to identify the change and revert it.

---

### 3. Pulled Automatically

In a GitOps model, the deployment agent pulls the desired state from Git.

ArgoCD watches the repository and retrieves the manifests.

The CI pipeline does not need to directly execute:

```bash
kubectl apply
```

against the production cluster.

This reduces the amount of cluster access required by CI systems.

---

### 4. Continuously Reconciled

ArgoCD continuously compares:

```text
Desired State in Git
        vs
Actual State in Kubernetes
```

If they differ, ArgoCD reports the application as `OutOfSync`.

With automated synchronization and `selfHeal: true`, ArgoCD can automatically correct the difference.

---

# 2. GitOps vs Traditional CI/CD

| Aspect                   | Traditional CI/CD                                   | GitOps                                  |
| ------------------------ | --------------------------------------------------- | --------------------------------------- |
| Deployment trigger       | CI pipeline executes deployment commands            | Git change is detected by ArgoCD        |
| Source of truth          | Pipeline scripts and configuration                  | Git repository                          |
| Deployment mechanism     | CI pushes changes to Kubernetes                     | ArgoCD pulls desired state from Git     |
| Drift detection          | Usually limited or manually implemented             | Continuous reconciliation               |
| Rollback                 | Re-run pipeline or manually deploy previous version | Revert Git commit                       |
| Audit trail              | Pipeline logs                                       | Git history + ArgoCD history            |
| Cluster access           | CI server generally requires cluster credentials    | ArgoCD handles cluster access           |
| Manual changes           | Can remain unnoticed                                | Detected as drift                       |
| Self-healing             | Not normally built in                               | Supported through ArgoCD                |
| Security model           | CI requires Kubernetes access                       | Developers mainly require Git access    |
| Configuration management | Can be spread across scripts and pipelines          | Declarative configuration stored in Git |
| Desired state            | Defined by deployment process                       | Explicitly defined in Git               |

### Main difference

Traditional CI/CD generally follows:

```text
Developer
    |
    v
Git
    |
    v
CI Pipeline
    |
    | kubectl apply
    v
Kubernetes
```

GitOps follows:

```text
Developer
    |
    v
Git
    |
    v
ArgoCD
    |
    | Reconciliation
    v
Kubernetes
```

The important difference is that **ArgoCD continuously pulls and reconciles the desired state instead of relying on a CI pipeline to directly push deployment commands to Kubernetes.**

---

# 3. AI-BankApp GitOps Flow

The AI-BankApp uses GitHub Actions for CI and ArgoCD for CD/reconciliation.

The overall flow is:

```text
                         Developer
                             |
                             | Push code
                             v
                    +-------------------+
                    |      GitHub       |
                    |   feat/gitops     |
                    +-------------------+
                             |
                             v
                    +-------------------+
                    |  GitHub Actions   |
                    |       CI          |
                    +-------------------+
                             |
                 +-----------+-----------+
                 |                       |
                 v                       v
          Build Maven App          Run Tests
                 |                       |
                 +-----------+-----------+
                             |
                             v
                    Build Docker Image
                             |
                             v
                     Push to DockerHub
                             |
                             | Git SHA tag
                             v
                 Update Kubernetes YAML
                             |
                             v
                    Commit image tag
                       back to Git
                             |
                             v
                    +----------------+
                    |    ArgoCD      |
                    | GitOps Agent   |
                    +----------------+
                             |
                    Watches Git repo
                             |
                             v
                  Compare desired state
                    with live cluster
                             |
                             v
                       EKS Cluster
                             |
          +------------------+------------------+
          |                  |                  |
          v                  v                  v
       MySQL              Ollama            BankApp
                                          Deployment
                                          (4 replicas)
                             |
                             v
                         Users
```

## The important separation

GitHub Actions is responsible for **CI activities**, such as:

* Building the application
* Running tests
* Building the Docker image
* Pushing the image
* Updating the Kubernetes image tag

ArgoCD is responsible for **GitOps-based deployment and reconciliation**.

It watches the Kubernetes manifests in Git and makes sure the EKS cluster matches them.

Therefore:

```text
GitHub Actions = Build and update Git
ArgoCD         = Reconcile Git with Kubernetes
```

This separation means the CI pipeline does not need to directly perform Kubernetes deployment operations.

---

# 4. ArgoCD Application Manifest

The AI-BankApp is managed by an ArgoCD `Application` resource.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: bankapp
  namespace: argocd

spec:
  project: default

  source:
    repoURL: https://github.com/Vinit-D-Bisht/AI-BankApp-DevOps.git
    targetRevision: main
    path: k8s

  destination:
    server: https://kubernetes.default.svc
    namespace: bankapp

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true
```

> **Note:** The exact `repoURL` and `targetRevision` should match the fork/branch you actually used for your Day 84 deployment. In your current environment, ArgoCD history shows the `main` branch and commit `8c0fa7a`.

---

## Field-by-Field Explanation

### `apiVersion`

```yaml
apiVersion: argoproj.io/v1alpha1
```

Specifies the ArgoCD API version used by the `Application` custom resource.

ArgoCD extends Kubernetes using Custom Resource Definitions (CRDs), and `Application` is one of those resources.

---

### `kind`

```yaml
kind: Application
```

Defines the Kubernetes resource as an ArgoCD Application.

The Application tells ArgoCD:

* Where the manifests are stored
* Which Git revision to use
* Where to deploy them
* How synchronization should work

---

### `metadata.name`

```yaml
metadata:
  name: bankapp
```

Defines the name of the ArgoCD application.

In this project the application is called:

```text
bankapp
```

It can therefore be managed using commands such as:

```bash
argocd app get bankapp
```

and:

```bash
argocd app history bankapp
```

---

### `metadata.namespace`

```yaml
metadata:
  namespace: argocd
```

The ArgoCD `Application` resource itself exists inside the `argocd` namespace.

This is different from the namespace where the BankApp resources are deployed.

```text
Application resource
        |
        +--> argocd namespace

BankApp resources
        |
        +--> bankapp namespace
```

---

### `spec.project`

```yaml
project: default
```

Specifies the ArgoCD project associated with the application.

The `default` project is used here.

ArgoCD Projects can also be used to restrict:

* Which repositories an application can use
* Which clusters it can deploy to
* Which namespaces it can access
* Which resource types it can manage

---

## Source Configuration

### `source.repoURL`

```yaml
repoURL: https://github.com/Vinit-D-Bisht/AI-BankApp-DevOps.git
```

Specifies the Git repository containing the desired Kubernetes configuration.

ArgoCD retrieves the manifests from this repository.

The repository therefore acts as the source of truth for the deployment.

---

### `source.targetRevision`

```yaml
targetRevision: main
```

Specifies which Git branch, tag, or commit ArgoCD should follow.

In this setup, ArgoCD watches the `main` branch.

When a new commit changes the Kubernetes manifests, ArgoCD can detect the new desired state.

---

### `source.path`

```yaml
path: k8s
```

Specifies the directory inside the repository containing the Kubernetes manifests.

For this project:

```text
Repository
│
├── application code
├── Docker configuration
├── Terraform
├── ...
└── k8s/
      ├── deployment
      ├── services
      ├── configmaps
      ├── secrets
      ├── storage
      └── other manifests
```

ArgoCD reads the manifests from this directory.

---

# Destination Configuration

### `destination.server`

```yaml
server: https://kubernetes.default.svc
```

Specifies the Kubernetes API server where the application should be deployed.

`kubernetes.default.svc` refers to the Kubernetes API service available inside the cluster.

Because ArgoCD is running inside the EKS cluster, this represents the in-cluster destination.

---

### `destination.namespace`

```yaml
namespace: bankapp
```

Specifies the namespace where the BankApp resources should be deployed.

The application therefore has this separation:

```text
argocd namespace
    |
    +-- ArgoCD Application: bankapp

bankapp namespace
    |
    +-- MySQL
    +-- Ollama
    +-- BankApp
    +-- Services
    +-- PVCs
    +-- HPA
    +-- ConfigMaps
    +-- Secrets
```

---

# Sync Policy

### `automated`

```yaml
syncPolicy:
  automated:
```

Enables automated synchronization.

Without automated synchronization, ArgoCD can detect that the cluster is different from Git, but a synchronization operation may need to be initiated manually.

With automation enabled, ArgoCD can automatically apply changes.

---

# `prune: true`

```yaml
prune: true
```

Pruning means removing resources from the cluster when they have been removed from the desired state in Git.

For example, suppose Git originally contains:

```text
deployment.yaml
service.yaml
configmap.yaml
```

Later, `configmap.yaml` is deleted from Git.

With pruning enabled, ArgoCD can remove the corresponding ConfigMap from the Kubernetes cluster.

Without pruning, an old resource could remain in the cluster even though it no longer exists in Git.

Therefore:

```text
Deleted from Git
       |
       v
ArgoCD detects absence
       |
       v
Resource removed from cluster
```

---

# `selfHeal: true`

```yaml
selfHeal: true
```

Enables automatic correction of configuration drift.

For example, Git specifies:

```yaml
replicas: 4
```

but someone manually executes:

```bash
kubectl scale deployment bankapp \
  -n bankapp \
  --replicas=1
```

The live cluster now differs from Git:

```text
Git desired state       Live state

replicas: 4             replicas: 1
```

ArgoCD detects the difference.

With `selfHeal: true`, ArgoCD automatically reconciles the resource back toward the Git-defined state.

This is one of the most important GitOps features because it prevents manual changes from becoming permanent configuration.

---

# `CreateNamespace=true`

```yaml
syncOptions:
  - CreateNamespace=true
```

Allows ArgoCD to create the destination namespace automatically if it does not already exist.

For this project:

```text
bankapp namespace
```

does not have to be created manually before synchronization.

ArgoCD can create it as part of the deployment.

---

# `ServerSideApply=true`

```yaml
- ServerSideApply=true
```

Tells ArgoCD to use Kubernetes Server-Side Apply when applying resources.

Server-Side Apply allows Kubernetes to track field ownership and can provide better handling when multiple controllers or tools interact with Kubernetes resources.

This is useful in environments where Kubernetes resources may also be modified by controllers.

The important distinction is:

```text
Traditional Apply
        |
        v
Client-side management of changes

Server-Side Apply
        |
        v
Kubernetes API server manages
field ownership and changes
```

For the AI-BankApp, this helps ArgoCD manage resources more reliably in the EKS environment.

---

# 5. Important GitOps Settings Summary

| Setting                | Purpose                                     |
| ---------------------- | ------------------------------------------- |
| `automated`            | Automatically synchronize Git changes       |
| `prune: true`          | Remove resources deleted from Git           |
| `selfHeal: true`       | Correct manual changes/drift in the cluster |
| `CreateNamespace=true` | Automatically create the target namespace   |
| `ServerSideApply=true` | Use Kubernetes Server-Side Apply            |

Together, these settings make the ArgoCD Application continuously reconcile the EKS cluster with the desired state stored in Git.

---

# Final GitOps Architecture

```text
                    ┌──────────────────┐
                    │    Developer     │
                    └────────┬─────────┘
                             │
                       git push / PR
                             │
                             ▼
                    ┌──────────────────┐
                    │     GitHub       │
                    │  Source of Truth │
                    └────────┬─────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
        ┌────────────────┐       ┌────────────────┐
        │ GitHub Actions │       │     ArgoCD     │
        │       CI       │       │   GitOps/CD    │
        └───────┬────────┘       └───────┬────────┘
                │                        │
        Build/Test/Image                 │
                │                        │
                └──────────────┐         │
                               ▼         │
                         Git manifest ◄──┘
                               │
                         Desired State
                               │
                               ▼
                     ┌──────────────────┐
                     │    EKS Cluster   │
                     │                  │
                     │  ┌────────────┐  │
                     │  │  MySQL     │  │
                     │  ├────────────┤  │
                     │  │  Ollama    │  │
                     │  ├────────────┤  │
                     │  │  BankApp   │  │
                     │  └────────────┘  │
                     └────────┬─────────┘
                              │
                         Actual State
                              │
                              ▼
                     ArgoCD compares
                     desired vs actual
                              │
                              ▼
                         Reconciliation
                              │
                    ┌─────────┴─────────┐
                    │                   │
                Synced              OutOfSync
                    │                   │
                    │             selfHeal=true
                    │                   │
                    │                   ▼
                    │             Correct drift
                    │                   │
                    └───────────────────┘
```

---

# Key Takeaways

1. **Git is the single source of truth** for the desired application state.
2. **ArgoCD continuously reconciles** the Kubernetes cluster with Git.
3. GitOps reduces the need for developers and CI systems to directly access the Kubernetes cluster.
4. **`selfHeal: true`** automatically corrects configuration drift.
5. **`prune: true`** removes resources that are no longer defined in Git.
6. **Server-Side Apply** provides Kubernetes-managed field ownership and improved resource application.
7. Git provides a complete history of configuration changes and makes rollback easier.
8. GitHub Actions and ArgoCD have separate responsibilities:

   * **GitHub Actions → CI/build/image/update Git**
   * **ArgoCD → deployment/reconciliation**
9. The result is a deployment system where the EKS cluster continuously moves toward the state declared in Git.
