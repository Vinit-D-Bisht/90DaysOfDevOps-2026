## What is Helm?

Helm is the package manager for Kubernetes. Instead of writing and maintaining many Kubernetes YAML files manually, Helm allows us to package them into reusable templates called **charts**. Configuration can then be customized through a values file without modifying the templates.

---

# Helm Concepts

## 1. Chart

A **Chart** is a collection of Kubernetes resource templates and configuration files packaged together. It acts like a blueprint for deploying an application.

**Example:**
- MySQL Chart
- NGINX Chart
- Prometheus Chart

A chart contains:
- Deployment templates
- Service templates
- Persistent Volume templates
- ConfigMaps
- Metadata
- Default configuration values

---

## 2. Release

A **Release** is a running instance of a chart inside a Kubernetes cluster.

Think of it like this:

- Chart = Template
- Release = Installed Application

Example:

```bash
helm install mysql-release bitnami/mysql
```

Here:

- Chart → `bitnami/mysql`
- Release → `mysql-release`

You can install the same chart multiple times using different release names.

Example:

```bash
helm install dev-mysql bitnami/mysql
helm install prod-mysql bitnami/mysql
```

Both use the same chart but create separate deployments.

---

## 3. Repository

A **Repository** is a collection of Helm charts, similar to how Docker Hub stores Docker images.

Popular repositories include:

- Bitnami
- Prometheus Community
- Grafana
- Elastic

Example:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Now Helm can download charts from the Bitnami repository.

---

## 4. Values

The **values.yaml** file contains configuration variables used by the chart templates.

Instead of editing templates, we override settings in a values file.

Example:

```yaml
auth:
  rootPassword: root123
  database: bankdb

primary:
  persistence:
    enabled: true
    size: 5Gi
```

During installation:

```bash
helm install mysql bitnami/mysql -f mysql-values.yaml
```

Helm injects these values into the templates and creates Kubernetes resources accordingly.

---

# Deploying MySQL: Raw YAML vs Helm

| Raw YAML | Helm |
|----------|------|
| Multiple YAML files must be created manually | One command installs everything |
| Manual updates required | Values file controls configuration |
| Hard to reuse | Highly reusable |
| Duplicate YAML across environments | Same chart works for dev, test, and production |
| Difficult upgrades | `helm upgrade` performs versioned upgrades |
| Manual rollback | `helm rollback` restores previous release |
| More maintenance | Easier maintenance |

### Raw YAML Deployment

Typical files:

- Deployment.yaml
- Service.yaml
- Secret.yaml
- PVC.yaml
- ConfigMap.yaml

Commands:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f pvc.yaml
kubectl apply -f secret.yaml
```

---

### Helm Deployment

Only one command is needed:

```bash
helm install mysql bitnami/mysql -f mysql-values.yaml
```

Everything is created automatically.

---

# My mysql-values.yaml

```yaml
auth:
  rootPassword: root123
  database: bankdb
  username: bankuser
  password: bankpass

primary:
  persistence:
    enabled: true
    size: 5Gi

architecture: standalone
```

---

# Explanation of Each Field

## auth.rootPassword

Sets the MySQL root password.

```yaml
rootPassword: root123
```

---

## auth.database

Creates the database automatically.

```yaml
database: bankdb
```

---

## auth.username

Creates a non-root database user.

```yaml
username: bankuser
```

---

## auth.password

Password for the application user.

```yaml
password: bankpass
```

---

## primary.persistence.enabled

Enables Persistent Volume storage.

```yaml
enabled: true
```

Without this, data would be lost if the pod restarts.

---

## primary.persistence.size

Specifies the storage size.

```yaml
size: 5Gi
```

---

## architecture

Determines the MySQL deployment mode.

```yaml
architecture: standalone
```

Options include:

- standalone
- replication

For learning purposes, standalone is sufficient.

---

# Helm Chart Directory Structure

Example chart:

```
mychart/
│
├── Chart.yaml
├── values.yaml
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── pvc.yaml
│   ├── secret.yaml
│   ├── configmap.yaml
│   ├── ingress.yaml
│   ├── serviceaccount.yaml
│   └── _helpers.tpl
│
└── .helmignore
```

### Chart.yaml

Contains chart metadata.

Example:

```yaml
apiVersion: v2
name: mychart
version: 0.1.0
appVersion: "1.0"
```

---

### values.yaml

Stores default configuration values used by templates.

---

### templates/

Contains all Kubernetes YAML templates.

Examples:

- Deployment
- Service
- Secret
- PVC
- ConfigMap
- Ingress

These files use Helm template syntax such as:

```yaml
{{ .Values.auth.rootPassword }}
```

---

### charts/

Stores dependent charts if the application relies on other Helm charts.

Example:

- MySQL
- Redis

---

### _helpers.tpl

Contains reusable template helper functions.

Example:

- Common labels
- Naming conventions
- Resource names

This avoids duplication across templates.

---

### .helmignore

Specifies files and directories that should not be included when packaging the chart, similar to `.gitignore`.

---

# Why the AI-BankApp's 12 Raw YAML Files Should Become a Helm Chart

The AI-BankApp currently uses multiple Kubernetes YAML files for resources such as Deployments, Services, ConfigMaps, Secrets, PersistentVolumeClaims, and Ingresses. Converting them into a Helm chart provides several advantages:

- **Single-command deployment:** Install the complete application with `helm install`.
- **Environment-specific configuration:** Use different values files (for example, `values-dev.yaml` and `values-prod.yaml`) without duplicating manifests.
- **Reduced duplication:** Shared labels, image names, ports, and resource settings can be centralized in templates and helper functions.
- **Simplified upgrades:** Update configuration or container images with `helm upgrade` instead of manually applying many files.
- **Easy rollbacks:** If an upgrade fails, `helm rollback` can restore a previous working release.
- **Improved maintainability:** Changes to common settings only need to be made once, reducing the chance of inconsistencies across 12 separate files.
- **Better reusability:** The same chart can be deployed repeatedly for development, testing, staging, and production with different values.
- **Versioning and packaging:** The application can be packaged as a versioned Helm chart, making releases easier to manage and distribute.

Overall, converting the AI-BankApp into a Helm chart would make deployments more consistent, configurable, scalable, and easier to maintain than managing numerous standalone YAML manifests.
