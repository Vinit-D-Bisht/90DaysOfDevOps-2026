# Day 79 – Custom Helm Charts

## Objective

The goal of this task was to understand how Helm templates simplify Kubernetes deployments by replacing repetitive Kubernetes manifests with reusable templates. Helm charts allow application configuration through a single `values.yaml` file while generating the required Kubernetes resources dynamically.

---

# 1. Raw Kubernetes Manifests vs Helm Templates

One of the biggest advantages of Helm is eliminating duplicate YAML while making deployments configurable.

## Deployment

### Raw Kubernetes Manifest (`k8s/deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: bankapp
  template:
    metadata:
      labels:
        app: bankapp
    spec:
      containers:
      - name: bankapp
        image: trainwithshubham/ai-bankapp-eks:latest
        ports:
        - containerPort: 8080
```

### Helm Template (`templates/deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "bankapp.fullname" . }}
spec:
  replicas: {{ .Values.bankapp.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "bankapp.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "bankapp.name" . }}
    spec:
      containers:
      - name: bankapp
        image: "{{ .Values.bankapp.image.repository }}:{{ .Values.bankapp.image.tag }}"
        imagePullPolicy: {{ .Values.bankapp.image.pullPolicy }}
```

### Comparison

| Raw Manifest | Helm Template |
|--------------|---------------|
| Fixed values | Dynamic values |
| Cannot reuse | Reusable |
| Manual editing required | Controlled through `values.yaml` |
| Hardcoded image | Configurable image |
| Hardcoded replica count | Configurable replicas |

---

# Service

### Raw Manifest

```yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp
spec:
  selector:
    app: bankapp
  ports:
  - port: 80
    targetPort: 8080
```

### Helm Template

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "bankapp.fullname" . }}
spec:
  type: {{ .Values.bankapp.service.type }}
  selector:
    app: {{ include "bankapp.name" . }}
  ports:
  - port: {{ .Values.bankapp.service.port }}
    targetPort: {{ .Values.bankapp.service.targetPort }}
```

### Comparison

| Raw Manifest | Helm Template |
|--------------|---------------|
| Fixed service type | Configurable |
| Fixed ports | Configurable |
| Manual edits | Values driven |

---

# Secret

### Raw Manifest

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
data:
  password: YWRtaW4=
```

### Helm Template

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
data:
  password: {{ .Values.mysql.password | b64enc }}
```

### Comparison

| Raw Manifest | Helm Template |
|--------------|---------------|
| Password manually encoded | Automatically encoded |
| Editing requires Base64 conversion | Plain text in values.yaml |

---

# 2. Complete values.yaml Explained

Example values file used by the project:

```yaml
bankapp:
  replicaCount: 2

  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: latest
    pullPolicy: Always

  service:
    type: NodePort
    port: 80
    targetPort: 8080

mysql:
  enabled: true

  image:
    repository: mysql
    tag: "8.0"

  database: bankdb
  username: bankuser
  password: bankpassword
  rootPassword: rootpassword

ollama:
  enabled: true

  image:
    repository: ollama/ollama
    tag: latest

  model: tinyllama
```

## Explanation

| Property | Description |
|----------|-------------|
| replicaCount | Number of application pods |
| repository | Docker image repository |
| tag | Image version |
| pullPolicy | Image pull strategy |
| service.type | Kubernetes Service type |
| service.port | Exposed Service port |
| targetPort | Container port |
| mysql.enabled | Deploy MySQL or not |
| database | Database name |
| username | Database username |
| password | Database password |
| rootPassword | MySQL root password |
| ollama.enabled | Deploy Ollama resources |
| model | AI model downloaded by Ollama |

---

# 3. Go Template Syntax Cheat Sheet

## Access Values

```yaml
{{ .Values.bankapp.replicaCount }}
```

Reads values from `values.yaml`.

---

## if

```yaml
{{ if .Values.mysql.enabled }}
...
{{ end }}
```

Creates resources only if the condition is true.

---

## range

```yaml
{{ range .Values.extraPorts }}
- containerPort: {{ . }}
{{ end }}
```

Loops through a list.

---

## with

```yaml
{{ with .Values.resources }}
resources:
{{ toYaml . | nindent 2 }}
{{ end }}
```

Changes the current scope to reduce repetition.

---

## include

```yaml
{{ include "bankapp.fullname" . }}
```

Calls helper templates from `_helpers.tpl`.

---

## toYaml

```yaml
{{ toYaml .Values.resources }}
```

Converts a map into properly formatted YAML.

---

## nindent

```yaml
{{ toYaml .Values.resources | nindent 8 }}
```

Adds indentation after converting to YAML.

---

## b64enc

```yaml
{{ .Values.mysql.password | b64enc }}
```

Encodes strings into Base64 for Kubernetes Secrets.

---

# 4. Helm Template Output

Command:

```bash
helm template bankapp .
```

Example rendered Deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: bankapp
  template:
    metadata:
      labels:
        app: bankapp
    spec:
      containers:
      - name: bankapp
        image: trainwithshubham/ai-bankapp-eks:latest
```

Example rendered Service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8080
```

Example rendered Secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
data:
  password: YmFua3Bhc3N3b3Jk
```

The rendered manifests contain only standard Kubernetes YAML with all template expressions replaced by actual values.

---

# 5. Disabling Ollama

The chart allows the Ollama deployment to be enabled or disabled using a single value.

Default:

```yaml
ollama:
  enabled: true
```

Disable it:

```yaml
ollama:
  enabled: false
```

The Helm templates use conditional rendering:

```yaml
{{ if .Values.ollama.enabled }}
# Ollama Deployment
# Ollama Service
# Model Pull Job
{{ end }}
```

When `ollama.enabled=false`:

- No Ollama Deployment is rendered.
- No Ollama Service is created.
- No model download Job is generated.
- The rest of the application (BankApp and MySQL) is deployed normally.

This demonstrates one of Helm's key strengths: optional components can be included or excluded without modifying Kubernetes manifests. Configuration is controlled entirely through `values.yaml`, making the chart reusable across development, testing, and production environments.
.
