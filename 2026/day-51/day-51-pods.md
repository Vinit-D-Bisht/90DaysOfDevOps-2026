# Day 51 – Kubernetes Manifests and Your First Pods

## The Four Required Fields of a Kubernetes Manifest

| Field | Purpose |
|---------|---------|
| `apiVersion` | Specifies which Kubernetes API version to use |
| `kind` | Defines the type of resource being created |
| `metadata` | Contains resource information like name and labels |
| `spec` | Defines the desired state of the resource |

---

## nginx-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

---

## busybox-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
    environment: dev
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh", "-c", "echo Hello from BusyBox && sleep 3600"]
```

---

## labeled-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-labeled-pod
  labels:
    app: demo
    environment: test
    team: devops
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

---

## Imperative vs Declarative

| Imperative | Declarative |
|------------|------------|
| Uses commands like `kubectl run` | Uses YAML manifests with `kubectl apply -f` |
| Quick for testing and one-time tasks | Best for repeatable and version-controlled deployments |
| Changes are made directly through commands | Desired state is stored in files |
| Harder to track and reproduce | Easy to track using Git |

---


```bash
kubectl get pods

NAME                READY   STATUS    RESTARTS  
busybox-pod         1/1     Running  	 0          
multi-labeled-pod   1/1     Running   	 0          
nginx-pod           1/1     Running   	 0          
```

---

## What Happens When You Delete a Standalone Pod?

When a standalone Pod is deleted, it is permanently removed and is not recreated automatically because no controller (such as a Deployment) is managing it. This is why Deployments are used in production environments.
