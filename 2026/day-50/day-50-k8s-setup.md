### Task 1: Recall the Kubernetes Story
1. Why was Kubernetes created? What problem does it solve that Docker alone cannot?
Docker runs containers, but Kubernetes manages them at scale.It solves scaling, load balancing, self-healing, and deployment automation across many servers.

2. Who created Kubernetes and what was it inspired by?
Created by Google in 2014.Inspired by Google's internal systems Borg and Omega.

3. What does the name "Kubernetes" mean?
The word kubernetes means a 'pilot' or 'helmsman' in greek which symbolizes guidance or control over containerized apps.

---

### Task 2: Draw the Kubernetes Architecture

kubectl
   |
   V
API Server
   |
   V
 etcd
   |
   V
Scheduler
   |
   V
Worker Node (kubelet)
   |
   V
Container Runtime
   |
   V
Pod Running

---

### Task 3: Install kubectl

```bash
kubectl version --client
```
Output:-
```bash
Client Version: v1.31.0
Kustomize Version: v5.4.2
```

---

### Task 4: Setting Up Your Local Cluster

```bash
# Linux
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create a cluster
kind create cluster --name Mydevops-cluster

# Verify
kubectl cluster-info
kubectl get nodes
```

Write down: Which one did you choose and why?
I choose kind because i want to start learning Kubernetes fundamentals (Pods, Deployments, Services, ConfigMaps, etc.) and its light-weight.
I already have Docker installed and for fast cluster creation/deletion.

---

### Task 5: Explore Your Cluster

```bash
# See cluster info
kubectl cluster-info
```
```bash
#output

Kubernetes control plane is running at https://127.0.0.1:42391
CoreDNS is running at https://127.0.0.1:42391/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

```bash
# List all nodes
kubectl get nodes
```

```bash
#output

NAME                           STATUS   ROLES           AGE     VERSION
devops-cluster-control-plane   Ready    control-plane   4m48s   v1.34.0
```

```bash
# Get detailed info about your node
kubectl describe node <node-name>
```

```bash
#output

Name:               devops-cluster-control-plane
Roles:              control-plane
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=devops-cluster-control-plane
```

```bash
# List all namespaces
kubectl get namespaces
```

```bash
#output

NAME                 STATUS   AGE
default              Active   5m21s
kube-node-lease      Active   5m21s
kube-public          Active   5m21s
kube-system          Active   5m21s
local-path-storage   Active   5m15s
```

```bash
# See ALL pods running in the cluster (across all namespaces)
kubectl get pods -A
```

```bash
#output

NAMESPACE            NAME                                                   READY   STATUS    RESTARTS   AGE
kube-system          coredns-66bc5c9577-4jn2x                               1/1     Running   0          5m26s
kube-system          coredns-66bc5c9577-v8dmv                               1/1     Running   0          5m26s
kube-system          etcd-devops-cluster-control-plane                      1/1     Running   0          5m31s
kube-system          kindnet-58k5g                                          1/1     Running   0          5m26s
kube-system          kube-apiserver-devops-cluster-control-plane  	    1/1     Running   0          5m32s
..
```

```bash
kubectl get pods -n kube-system
```

```bash
#output

NAME                                                   READY   STATUS    RESTARTS   AGE
coredns-66bc5c9577-4jn2x                               1/1     Running   0          5m51s
coredns-66bc5c9577-v8dmv                               1/1     Running   0          5m51s
etcd-devops-cluster-control-plane                      1/1     Running   0          5m56s
kindnet-58k5g                                          1/1     Running   0          5m51s
kube-apiserver-devops-cluster-control-plane            1/1     Running   0          5m57s
kube-controller-manager-devops-cluster-control-plane   1/1     Running   0          5m56s
kube-proxy-ljs24                                       1/1     Running   0          5m51s
kube-scheduler-devops-cluster-control-plane            1/1     Running   0          5m56s
```

Can you match each running pod in `kube-system` to a component in your architecture diagram?

| Pod                         | Component            |
| --------------------------- | -------------------- |
| `kube-apiserver-*`          | API Server           |
| `etcd-*`                    | etcd                 |
| `kube-scheduler-*`          | Scheduler            |
| `kube-controller-manager-*` | Controller Manager   |
| `kube-proxy-*`              | kube-proxy           |
| `coredns-*`                 | DNS Service          |
| `kindnet-*`                 | Network Plugin (CNI) |

---

### Task 6: Practice Cluster Lifecycle

```bash
# Delete your cluster
kind delete cluster --name devops-cluster
```
cluster deleted

```# Recreate it
kind create cluster --name devops-cluster
```
recreated the same cluster

```bash
# Verify it is back
kubectl get nodes
```
devops-cluster-control-plane   Ready    control-plane   1m20s   v1.34.0


```bash
# Check which cluster kubectl is connected to
kubectl config current-context
```

```bash
#output
kind-devops-cluster
```

```bash
# List all available contexts (clusters)
kubectl config get-contexts
```

```bash
#output
CURRENT   NAME                  CLUSTER               AUTHINFO              NAMESPACE
*         kind-devops-cluster   kind-devops-cluster   kind-devops-cluster   
```

```bash
# See the full kubeconfig
kubectl config view
```

```bash
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://127.0.0.1:42391
  name: kind-devops-cluster

```

Write down: What is a kubeconfig? Where is it stored on your machine?
A kubeconfig is the file that stores Kubernetes cluster connection and authentication details, and it is usually located at ~/.kube/config

##key learnings:
- Kubernetes automates container deployment, scaling, networking, and self-healing across multiple machines.
- A Kubernetes cluster consists of components like API Server, etcd, Scheduler, and Worker Nodes working together.
- kubectl and kubeconfig are essential for managing and connecting to Kubernetes clusters efficiently.
