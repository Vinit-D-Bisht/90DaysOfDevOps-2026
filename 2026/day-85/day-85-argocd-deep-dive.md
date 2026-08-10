# Day 85 — ArgoCD Deep Dive

## 1. Automated vs Manual Sync

ArgoCD continuously compares the Kubernetes cluster with the desired state stored in Git. The sync policy determines when differences are applied.

| Feature | Manual Sync | Automated Sync |
|---|---|---|
| Deployment | Operator starts sync | ArgoCD syncs automatically |
| GitOps control | More human approval | Fully automated |
| Best for | Production changes requiring approval | Dev/staging and trusted CI/CD |
| Risk | Slower deployment | Bad Git commit can be deployed automatically |
| Pruning | Can be performed during manual sync | Can be enabled with auto-prune |
| Self-healing | Usually requires manual intervention | `--self-heal` restores drift |
| Example | Release approval | Continuous deployment |

### Commands used

Enable automated sync, self-healing and pruning:

```bash
argocd app set bankapp --sync-policy automated --self-heal --auto-prune
```

Disable automated sync:

```bash
argocd app set bankapp --sync-policy none
```

Manual sync:

```bash
argocd app sync bankapp
```

### When to use

**Manual sync** is useful when:
- Production deployments require approval.
- Changes must be reviewed before reaching the cluster.
- A maintenance or release window is required.

**Automated sync** is useful when:
- Git is treated as the trusted deployment source.
- Fast continuous delivery is required.
- Self-healing and automatic pruning are desired.

For the AI-BankApp lab, automated sync with self-healing and auto-prune was configured to demonstrate GitOps-style continuous deployment.

---

## 2. Sync Waves — AI-BankApp Deployment Order

Sync waves allow resources to be applied in a controlled order. Lower wave numbers are processed before higher wave numbers.

A practical deployment order for AI-BankApp is:

| Wave | Resource | Purpose |
|---:|---|---|
| -2 | Namespace | Creates the `bankapp` namespace first |
| -1 | Secret / ConfigMap | Provides application configuration and credentials |
| 0 | StorageClass | Makes the GP3 storage class available |
| 0 | PVCs | Creates persistent storage claims for MySQL and Ollama |
| 1 | MySQL Deployment | Starts the database |
| 1 | Ollama Deployment | Starts the AI/LLM service |
| 2 | Services | Exposes MySQL, Ollama and BankApp internally |
| 3 | BankApp Deployment | Starts the application pods |
| 4 | HPA | Enables CPU-based horizontal scaling |

> **Note:** The exact wave numbers are implementation choices. If the manifests do not contain `argocd.argoproj.io/sync-wave` annotations, ArgoCD uses its normal resource ordering instead. Sync-wave annotations can be added to enforce the above sequence explicitly.

Example:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"
```

The important principle is that dependencies are created before workloads that depend on them.

---

## 3. ArgoCD Rollback vs `git revert`

ArgoCD keeps a deployment history containing the Git revisions that were synchronized.

Example history from AI-BankApp:

```text
ID   DATE                           REVISION
0    2026-08-09 12:37:47 +0530 IST  main (8c0fa7a)
1    2026-08-09 12:37:55 +0530 IST  main (8c0fa7a)
2    2026-08-09 12:47:26 +0530 IST  main (8c0fa7a)
3    2026-08-09 13:01:30 +0530 IST  main (87c1097)
```

### ArgoCD rollback

An ArgoCD rollback tells ArgoCD to deploy the state associated with a previous application revision.

A rollback cannot be initiated while automated sync is enabled:

```text
rollback cannot be initiated when auto-sync is enabled
```

Therefore, automated sync must first be disabled if using the ArgoCD rollback mechanism:

```bash
argocd app set bankapp --sync-policy none
argocd app rollback bankapp <REVISION_ID>
```

### Git revert

`git revert` creates a **new Git commit** that reverses the changes introduced by an earlier commit.

Example used in the lab:

```bash
git revert HEAD
git push
```

This produced a new commit:

```text
62d5382 Revert "changed"
```

ArgoCD then detects the new Git revision and synchronizes the cluster to that desired state.

### Which is GitOps-correct?

**`git revert` is the preferred GitOps-correct approach for a persistent rollback.**

Why?

```text
Git
 ↓
Revert bad commit
 ↓
New Git revision
 ↓
ArgoCD detects change
 ↓
ArgoCD syncs cluster
 ↓
Cluster matches Git
```

The Git repository remains the **single source of truth**.

ArgoCD rollback is still useful for emergency or operational recovery, but it can temporarily make the live cluster differ from the Git state. For a long-term correction, the desired state should be fixed in Git.

---

## 4. App of Apps Architecture

The App of Apps pattern uses one parent ArgoCD `Application` to manage multiple child applications.

The AI-BankApp setup uses:

- `root-app` — parent application
- `bankapp` — application workload
- `monitoring` — Prometheus/Grafana monitoring stack
- `envoy-gateway` — Envoy Gateway infrastructure

### Architecture

```text
                         Git Repository
                              │
                              │
                              ▼
                    ┌───────────────────┐
                    │     root-app      │
                    │   ArgoCD Parent   │
                    └─────────┬─────────┘
                              │
              ┌───────────────┼────────────────┐
              │               │                │
              ▼               ▼                ▼
      ┌──────────────┐ ┌──────────────┐ ┌─────────────────┐
      │   bankapp    │ │  monitoring  │ │ envoy-gateway   │
      │ ArgoCD App   │ │ ArgoCD App   │ │   ArgoCD App    │
      └──────┬───────┘ └──────┬───────┘ └────────┬────────┘
             │                │                  │
             ▼                ▼                  ▼
        AI-BankApp       Prometheus +       Envoy Gateway
        MySQL + Ollama      Grafana          + Gateway API
```

The parent application reads the `argocd-apps/` directory and creates/manages the child `Application` resources.

Observed state:

```text
root-app       Synced / Healthy
bankapp        Synced / Progressing → Healthy
monitoring     Auto-Prune
envoy-gateway  Auto-Prune
```

### Benefits

- Centralized application management.
- Easy addition of new environments/services.
- Each child application can have its own sync policy.
- Infrastructure and workloads can be managed consistently through Git.

---

## 5. ArgoCD Notifications

ArgoCD Notifications can send messages when application events occur.

Typical notification flow:

```text
Application State Change
          │
          ▼
    Trigger evaluates
          │
          ▼
 Notification Template
          │
          ▼
      Notification
          │
          ▼
 Slack / Email / Other
```

### Notification template

A template defines the message that should be sent.

Example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  template.app-sync-status: |
    message: |
      Application {{.app.metadata.name}}
      sync status: {{.app.status.sync.status}}
      health: {{.app.status.health.status}}
```

The template controls the notification content.

### Notification trigger

A trigger decides **when** the template is used.

Example:

```yaml
data:
  trigger.on-sync-succeeded: |
    - description: Application sync succeeded
      send:
        - app-sync-status
      when: app.status.operationState.phase == 'Succeeded'
```

The important distinction is:

- **Trigger = when to send**
- **Template = what to send**

Common useful triggers include:

- Sync succeeded
- Sync failed
- Application degraded
- Application health recovered

---

## 6. Projects and RBAC

ArgoCD Projects provide boundaries around applications and resources.

A project can restrict:

- Which Git repositories applications may use.
- Which Kubernetes clusters may be targeted.
- Which namespaces may be deployed into.
- Which resource kinds may be created.
- Which users or groups can perform operations.

### Project architecture

```text
                    ArgoCD
                       │
              ┌────────┴────────┐
              │     Project     │
              │    bank-prod    │
              └────────┬────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
       Git Repo      Cluster     Namespaces
       allowed       allowed      allowed
          │
          ▼
       Applications
```

Example project structure:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: bank-prod
  namespace: argocd
spec:
  sourceRepos:
    - "https://github.com/Vinit-D-Bisht/AI-BankApp-DevOps-Vinit.git"

  destinations:
    - namespace: bankapp
      server: https://kubernetes.default.svc
```

This prevents an application assigned to the project from freely deploying to arbitrary repositories, clusters or namespaces.

### RBAC

ArgoCD RBAC determines what authenticated users and groups are allowed to do.

Typical permissions include:

```text
applications, get
applications, sync
applications, update
applications, delete
logs, get
projects, get
```

A production setup can therefore follow the principle:

```text
Developer
   │
   ├── view applications
   └── view logs

Release Manager
   │
   ├── view applications
   └── sync applications

Administrator
   │
   ├── manage projects
   ├── manage applications
   └── manage ArgoCD configuration
```

This provides least-privilege access instead of giving every ArgoCD user full administrative permissions.

---

## 7. Validation Performed

### Root App

```bash
argocd app get root-app --refresh
```

Result:

```text
Sync Status:   Synced
Health Status: Healthy
```

The parent application successfully created:

```text
envoy-gateway
monitoring
bankapp
root-app
```

### AI-BankApp

```bash
argocd app get bankapp
```

The application reached:

```text
Sync Status:   Synced
Health Status: Healthy
```

### Monitoring

```bash
kubectl get pods -n monitoring
```

The Prometheus, Grafana, Alertmanager, kube-state-metrics and node-exporter workloads were running successfully.

### Envoy Gateway

The child application was created and most Envoy Gateway resources became healthy. During reconciliation, the `envoyproxies.gateway.envoyproxy.io` CRD encountered an annotation-size validation issue:

```text
metadata.annotations: Too long: may not be more than 262144 bytes
```

The other Gateway API and Envoy resources were reconciled successfully.

---

## 8. Key Takeaways

1. **Git is the desired-state source of truth in GitOps.**
2. **Automated sync** enables continuous deployment and self-healing.
3. **Manual sync** provides stronger release control and approval.
4. **Sync waves** control dependency-aware resource ordering.
5. **ArgoCD rollback** operates from ArgoCD deployment history.
6. **`git revert`** is preferred for a permanent GitOps rollback because it records the correction in Git.
7. **App of Apps** allows one parent application to manage multiple child applications.
8. **Notifications** use triggers to decide when to send and templates to define what is sent.
9. **Projects** restrict repositories, destinations and resources.
10. **RBAC** enforces least-privilege access for ArgoCD users and teams.

---

## Final Architecture

```text
                         Git Repository
                   AI-BankApp-DevOps-Vinit
                              │
                              ▼
                       ┌─────────────┐
                       │  root-app   │
                       │   ArgoCD    │
                       └──────┬──────┘
                              │
              ┌───────────────┼────────────────┐
              ▼               ▼                ▼
          bankapp         monitoring      envoy-gateway
              │               │                │
        ┌─────┼─────┐     ┌───┴────┐      ┌────┴─────┐
        ▼     ▼     ▼     ▼        ▼      ▼          ▼
      App    MySQL Ollama Prometheus Grafana Gateway  NLB
        │
        ▼
   Kubernetes / EKS
        │
        ▼
     Internet
```
