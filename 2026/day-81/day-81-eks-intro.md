# Day 81 - Introduction to Amazon EKS with Terraform

## Objective

Learn the architecture of Amazon Elastic Kubernetes Service (EKS), understand the AI-BankApp Terraform configuration, provision a production-grade Kubernetes cluster, connect with kubectl, and deploy the application manually before moving to GitOps.

---

# Amazon EKS Architecture

## What is Managed Kubernetes?

Amazon Elastic Kubernetes Service (EKS) is a managed Kubernetes service provided by AWS.

With EKS:

- AWS manages the Kubernetes control plane.
- Users manage the worker nodes (or choose serverless Fargate).
- AWS automatically handles:
  - High Availability
  - Control Plane upgrades
  - Security patches
  - etcd backups
  - API Server availability

This allows engineers to focus on workloads instead of Kubernetes infrastructure.

---

# EKS Components

## 1. Control Plane

Managed completely by AWS.

Includes:

- Kubernetes API Server
- etcd
- Scheduler
- Controller Manager

Features:

- Runs across multiple Availability Zones
- Highly available
- Automatically patched
- Accessible through the EKS API endpoint

---

## 2. Worker Nodes (Data Plane)

The AI-BankApp uses an **EKS Managed Node Group**.

Configuration:

- Amazon Linux 2023
- EC2 t3.medium
- Desired Nodes: 3
- Minimum Nodes: 3
- Maximum Nodes: 5

These nodes execute:

- Pods
- Deployments
- Services
- Stateful workloads

---

## 3. VPC Networking

The cluster is deployed inside a custom VPC.

Layout:

- 3 Public Subnets
- 3 Private Subnets
- 3 Intra Subnets

Public Subnets

- Internet-facing Load Balancers

Private Subnets

- Worker Nodes

Intra Subnets

- EKS Control Plane ENIs

A NAT Gateway allows private nodes to reach the Internet for package downloads and image pulls.

---

## 4. IAM Integration

EKS integrates directly with IAM.

The project uses:

- IAM Roles
- IAM Policies
- IRSA (IAM Roles for Service Accounts)

Benefits:

- Pods receive temporary AWS credentials.
- No static AWS keys inside containers.
- Fine-grained permissions.

---

# EKS Add-ons Used

| Add-on | Purpose |
|---------|---------|
| CoreDNS | Internal DNS resolution |
| kube-proxy | Kubernetes networking |
| Amazon VPC CNI | Assigns VPC IP addresses to Pods |
| EKS Pod Identity Agent | Enables Pod IAM roles |
| AWS EBS CSI Driver | Dynamic EBS volume provisioning |
| Metrics Server | Enables kubectl top and Horizontal Pod Autoscaler |

---

# Architecture Diagram

```
                        AWS Region
                             │
                     ┌──────────────┐
                     │     VPC      │
                     └──────────────┘
                             │
      ┌─────────────────────────────────────────────┐
      │                                             │
Public Subnets                               Private Subnets
(ELB)                                        (Worker Nodes)
      │                                             │
      │                                      ┌───────────────┐
      │                                      │ Node Group    │
      │                                      │ t3.medium x3  │
      │                                      └───────────────┘
      │                                             │
      │                                ┌─────────────────────────┐
      │                                │ Pods                    │
      │                                │ MySQL                   │
      │                                │ Ollama                  │
      │                                │ AI-BankApp              │
      │                                └─────────────────────────┘
      │
      │
      └──────────────────────────────┐
                                     │
                           EKS Control Plane
                    (Managed by AWS across AZs)

                     API Server
                     Scheduler
                     Controller Manager
                     etcd

```

---

# Terraform Configuration Overview

## provider.tf

Purpose:

- Configures AWS Provider
- Configures Helm Provider
- Defines provider settings and local values

---

## variables.tf

Contains configurable variables such as:

- AWS Region
- Cluster Name
- Kubernetes Version
- Node Instance Type
- Desired Node Count
- Maximum Node Count

These variables make the infrastructure reusable.

---

## terraform.tfvars

Provides default values.

```
Region: us-west-2
Cluster: bankapp-eks
Version: 1.35
Node Type: t3.medium
Desired Nodes: 3
Max Nodes: 5
```

---

## vpc.tf

Creates the networking layer.

Resources:

- Custom VPC
- Internet Gateway
- NAT Gateway
- Route Tables
- Public Subnets
- Private Subnets
- Intra Subnets

Tags are added for Kubernetes Load Balancer discovery.

---

## eks.tf

Creates the EKS cluster.

Resources include:

- EKS Cluster
- Managed Node Group
- IAM Roles
- Security Groups
- EKS Add-ons
- IRSA configuration

Node Group:

- Amazon Linux 2023
- t3.medium
- 3 nodes

---

## argocd.tf

Installs ArgoCD using Helm.

Features:

- Automatic installation after EKS is ready
- Exposes ArgoCD using LoadBalancer
- Ready for GitOps deployment

---

## outputs.tf

Displays useful commands after deployment.

Examples:

- aws eks update-kubeconfig
- ArgoCD password retrieval command
- Cluster information

---

# Cluster Provisioning

Commands executed:

```bash
terraform init

terraform plan

terraform apply
```

Terraform created:

- VPC
- 9 Subnets
- NAT Gateway
- Internet Gateway
- EKS Cluster
- Managed Node Group
- IAM Roles
- EKS Add-ons
- ArgoCD Helm Release

---

# Connecting kubectl

Configured kubeconfig:

```bash
aws eks update-kubeconfig \
--name bankapp-eks \
--region us-west-2
```

Verification:

```bash
kubectl config current-context

kubectl cluster-info

kubectl get nodes
```

Result:

- Cluster reachable
- 3 Ready worker nodes
- Kubernetes API operational

---

# AI-BankApp Deployment

Applied manifests:

```bash
kubectl apply -f k8s/
```

Deployment order:

1. Namespace
2. Persistent Volumes
3. Persistent Volume Claims
4. ConfigMaps
5. Secrets
6. MySQL
7. Ollama
8. AI-BankApp
9. Horizontal Pod Autoscaler

Verified:

- Pods Running
- PVC Bound
- Services Created
- Application Accessible

---

# ArgoCD

Namespace:

```
argocd
```

Status:

```
Running
```

LoadBalancer URL:

```
http://<ARGOCD-LOADBALANCER-URL>
```

Example:

```
http://a1b2c3d4e5f6.us-west-2.elb.amazonaws.com
```

Admin Username:

```
admin
```

Password obtained using:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d
```

Confirmation:

✅ Successfully logged into the ArgoCD dashboard.

---

# Cost Breakdown

| Component | Approximate Cost |
|------------|-----------------|
| EKS Control Plane | $73/month |
| EC2 Worker Nodes | $91/month |
| NAT Gateway | $33/month |
| EBS Storage | $1.50/month |
| Load Balancer | $18/month |
| **Total** | **~$220/month** |

---

# Why is the NAT Gateway Expensive?

The NAT Gateway charges for:

- Hourly uptime
- Data processed through it

Every private EC2 instance accesses the Internet through the NAT Gateway for:

- Pulling Docker images
- Downloading packages
- Software updates

Since the gateway runs continuously and charges for transferred data, it often becomes one of the most expensive networking components in small AWS environments.

---

# Key Learnings

- Learned the difference between Kubernetes Control Plane and Data Plane.
- Understood how AWS manages Kubernetes.
- Studied the AI-BankApp Terraform configuration.
- Learned how EKS integrates with IAM.
- Understood VPC networking for Kubernetes.
- Provisioned an EKS cluster using Terraform.
- Connected kubectl to EKS.
- Explored Kubernetes add-ons.
- Learned how ArgoCD is installed using Helm.
- Understood the cost considerations of running production Kubernetes on AWS.

