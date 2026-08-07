# Day 83 — Production Deployment of AI-BankApp on Amazon EKS

## Overview

Today I completed the final stage of my Amazon EKS journey by deploying the complete AI-BankApp stack on a production-style Kubernetes environment.

The deployment includes:

- Spring Boot AI-BankApp application
- MySQL database
- Ollama AI service
- Persistent storage using AWS EBS
- Gateway API with Envoy Gateway
- Horizontal Pod Autoscaler
- Prometheus and Grafana monitoring

The goal was to understand how a real cloud-native application is deployed, exposed, monitored, and validated on managed Kubernetes.

---

# Architecture Diagram

```
                         Internet Users
                              |
                              |
                         AWS Load Balancer
                              |
                              |
                    Envoy Gateway / Gateway API
                              |
                              |
                     Amazon EKS Cluster
                              |
        ------------------------------------------------
        |                                              |
   Worker Node 1                                Worker Node 2
        |                                              |
        |                                              |
  -------------------                         -------------------
  |                 |                         |                 |
BankApp Pod      MySQL Pod                BankApp Pod      Ollama Pod
(Spring Boot)    (Database)               (Replica)       (AI Model)
  |                 |                         |
  |                 |                         |
  ------------------------------------------------
                         |
                    AWS EBS Volumes
                  (Persistent Storage)


Monitoring Stack:

        Kubernetes Cluster
              |
              |
        Prometheus
              |
              |
          Grafana Dashboard
```

Architecture flow:

```
User
 |
Internet
 |
AWS NLB
 |
Envoy Gateway
 |
Kubernetes Service
 |
AI-BankApp Pods
 |
MySQL + Ollama Services
```

---

# Infrastructure Components

## Amazon EKS

The Kubernetes cluster was provisioned using Terraform.

Components created:

- EKS Control Plane
- Managed Node Group
- VPC Networking
- Subnets across Availability Zones
- IAM Roles
- EBS CSI Driver

---

## Application Stack

### BankApp

Technology:

- Spring Boot
- Java
- Spring Actuator Metrics

Responsibilities:

- User authentication
- Banking operations
- API handling
- AI chatbot integration


### MySQL

Purpose:

- Store users
- Store accounts
- Store transactions

Storage:

```
PVC: mysql-pvc
Size: 5Gi
StorageClass: gp3
```

---

### Ollama AI Service

Purpose:

- Provides AI chatbot functionality

Storage:

```
PVC: ollama-pvc
Size: 10Gi
StorageClass: gp3
```

---

# Gateway API and Networking

External traffic flow:

```
Client
 |
AWS Network Load Balancer
 |
Envoy Gateway
 |
HTTPRoute
 |
bankapp-service
 |
BankApp Pods
```

Gateway verification:

```bash
kubectl get gateway -n bankapp
```

Result:

```
NAME              PROGRAMMED
bankapp-gateway   True
```

---

# Monitoring Setup

Monitoring stack deployed using:

```
kube-prometheus-stack
```

Components:

- Prometheus
- Grafana
- AlertManager
- Node Exporter
- Kube State Metrics


Grafana dashboard:

(Add Screenshot Here)

```
![Grafana Dashboard](images/grafana-bankapp.png)
```

The dashboard shows:

- CPU usage
- Memory usage
- Pod resources
- Network traffic
- Kubernetes workload health

---

# Prometheus Metrics

Spring Boot Actuator was used to expose application metrics.

Endpoint:

```
/actuator/prometheus
```

---

## JVM Memory Usage

PromQL:

```promql
jvm_memory_used_bytes{
 namespace="bankapp"
}
```

Purpose:

Monitors JVM memory consumption of the Spring Boot application.

---

## HTTP Request Rate

PromQL:

```promql
rate(
 http_server_requests_seconds_count{
 namespace="bankapp"
}[5m]
)
```

Purpose:

Shows incoming HTTP request traffic.

---

## HTTP Latency (95th Percentile)

PromQL:

```promql
histogram_quantile(
0.95,
rate(
http_server_requests_seconds_bucket{
namespace="bankapp"
}[5m]
))
```

Purpose:

Measures application response latency.

---

## Container CPU Usage

PromQL:

```promql
rate(
container_cpu_usage_seconds_total{
namespace="bankapp"
}[5m]
)
```

Purpose:

Tracks CPU consumption of application containers.

---

# Validation Checklist

## Application Layer

### Check Pods

Command:

```bash
kubectl get pods -n bankapp
```

Result:

```
bankapp     Running
mysql       Running
ollama      Running
```

Status:

✅ Passed


---

## Application Health

Command:

```bash
curl http://<APP_URL>/actuator/health
```

Result:

```
{
 "status":"UP"
}
```

Status:

✅ Passed


---

## Horizontal Pod Autoscaler

Command:

```bash
kubectl get hpa -n bankapp
```

Result:

```
NAME          TARGETS
bankapp-hpa   cpu:1%/70%
```

Status:

✅ Passed


---

# Data Layer Validation

## MySQL Health

Command:

```bash
kubectl exec -n bankapp deploy/mysql \
-- mysqladmin ping -h localhost -uroot -pTest@123
```

Result:

```
mysqld is alive
```

Status:

✅ Passed


---

## Persistent Storage

Command:

```bash
kubectl get pvc -n bankapp
```

Result:

```
mysql-pvc    Bound    5Gi
ollama-pvc   Bound    10Gi
```

Status:

✅ Passed


---

## Ollama Model

Command:

```bash
kubectl exec -n bankapp deploy/ollama \
-- ollama list
```

Status:

✅ Passed


---

# Infrastructure Validation

## Nodes

Command:

```bash
kubectl get nodes
```

Status:

✅ Passed


## Gateway

Command:

```bash
kubectl get gateway -n bankapp
```

Status:

✅ Passed


## Monitoring

Command:

```bash
kubectl get pods -n monitoring
```

Status:

✅ Passed


---

# Security Validation

## Non Root Container

Command:

```bash
kubectl exec -n bankapp deploy/bankapp -- whoami
```

Result:

```
devsecops
```

Status:

✅ Passed


---

# Teardown Procedure

To avoid unnecessary AWS costs, all resources were deleted after testing.


## Delete Monitoring

```bash
helm uninstall monitoring -n monitoring
```


## Delete Application

```bash
kubectl delete -f k8s/bankapp-deployment.yml
kubectl delete -f k8s/mysql-deployment.yml
kubectl delete -f k8s/ollama-deployment.yml
kubectl delete -f k8s/service.yml
kubectl delete -f k8s/pvc.yml
kubectl delete -f k8s/pv.yml
kubectl delete namespace bankapp
```


## Delete Gateway Components

```bash
helm uninstall envoy-gateway \
-n envoy-gateway-system
```


## Destroy Infrastructure

Terraform cleanup:

```bash
terraform destroy
```

Deleted resources:

- EKS Cluster
- Worker Nodes
- VPC
- Subnets
- NAT Gateway
- IAM Roles
- Security Groups

---

# Key Takeaways From EKS Journey

## Day 81 — EKS Infrastructure

Learned:

- Creating production Kubernetes infrastructure using Terraform
- Managed node groups
- AWS networking
- IAM integration
- Kubernetes cluster provisioning


---

## Day 82 — Networking and Storage

Learned:

- Gateway API
- Envoy Gateway
- TLS configuration
- Persistent volumes
- AWS EBS storage
- Kubernetes traffic management


---

## Day 83 — Production Deployment

Learned:

- Deploying complete applications on EKS
- Connecting multiple Kubernetes services
- Implementing autoscaling
- Monitoring applications using Prometheus and Grafana
- Validating production workloads


---

# Cost Report

Approximate cost for the 3-day EKS lab:

| Resource | Estimated Cost |
|---|---:|
| EKS Control Plane | ~$7 |
| EC2 Worker Nodes | ~$8-12 |
| NAT Gateway | ~$3-5 |
| EBS Storage | <$1 |
| Load Balancer | ~$1 |
| Total | ~$15-25 |

Cost was minimized by:

- Destroying infrastructure after completion
- Removing unused load balancers
- Deleting persistent resources

---

# Final Result

The AI-BankApp was successfully deployed on Amazon EKS with:

✅ Production Kubernetes environment  
✅ Gateway-based traffic routing  
✅ Persistent database storage  
✅ AI chatbot integration  
✅ Horizontal scaling  
✅ Prometheus monitoring  
✅ Grafana visualization  

This completed the three-day EKS deployment block and provided hands-on experience with modern cloud-native application deployment.
