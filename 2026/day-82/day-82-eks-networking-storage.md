# AI BankApp on Amazon EKS with Gateway API, TLS & Kubernetes

## Project Overview

This project demonstrates the deployment of a production-style AI-powered Bank Application on Amazon EKS using Kubernetes best practices. The application consists of a Java Spring Boot backend, MySQL database, and Ollama AI service. Traffic is managed using Envoy Gateway with the Kubernetes Gateway API, while persistent storage is provisioned dynamically through AWS EBS CSI Driver. The project also includes Horizontal Pod Autoscaling (HPA) for scalability.

---

# Technology Stack

* Amazon EKS
* Kubernetes
* Docker
* Spring Boot
* MySQL
* Ollama
* Envoy Gateway
* Kubernetes Gateway API
* AWS EBS CSI Driver
* Horizontal Pod Autoscaler
* Helm
* kubectl
* AWS CLI

---

# Architecture

* Amazon EKS Cluster
* Envoy Gateway Load Balancer
* Gateway API
* HTTPRoute
* Spring Boot Application (2 Replicas)
* MySQL Deployment
* Ollama Deployment
* Persistent Volumes using gp3 StorageClass
* Horizontal Pod Autoscaler

---

# Features

* Containerized Spring Boot application
* Kubernetes Deployments and Services
* Gateway API based routing
* External LoadBalancer access
* Dynamic EBS volume provisioning
* Persistent MySQL database
* Persistent Ollama storage
* Horizontal Pod Autoscaler
* Production-style Kubernetes manifests
* Namespace isolation
* ConfigMaps and Secrets
* Gateway API HTTP routing
* TLS-ready Gateway configuration

---

# Kubernetes Resources Created

* Namespace
* Deployments
* Services
* PersistentVolumeClaims
* ConfigMaps
* Secrets
* Gateway
* HTTPRoute
* HorizontalPodAutoscaler

---

# Deployment Steps

## 1. Created Kubernetes Namespace

Created an isolated namespace for the complete BankApp deployment.

**Screenshot:**

---

## 2. Deployed MySQL

* Persistent Storage enabled
* Root credentials stored in Kubernetes Secret
* Database initialized successfully

**Screenshot:**

---

## 3. Deployed Ollama

* Persistent Volume attached
* AI model service running successfully

**Screenshot:**

---

## 4. Deployed Spring Boot Application

* Multiple replicas deployed
* Connected successfully with MySQL
* Connected successfully with Ollama

**Screenshot:**

---

## 5. Verified Pods

Verified all application pods reached the Running state.

**Screenshot:**

---

## 6. Verified Services

Confirmed ClusterIP services and external Gateway access.

**Screenshot:**

---

## 7. Configured Envoy Gateway

Configured Gateway API using Envoy Gateway.

* HTTP Listener
* HTTPS Listener
* Gateway programmed successfully

**Screenshot:**

---

## 8. Configured HTTPRoute

Created HTTPRoute to route all incoming traffic to the BankApp service.

Verified:

* Route Accepted
* References Resolved
* Backend Service Connected

**Screenshot:**

---

## 9. External LoadBalancer

Verified external AWS LoadBalancer was provisioned successfully.

Successfully accessed the application using the external endpoint.

**Screenshot:**

---

## 10. Verified Application Accessibility

Confirmed application responds correctly through the Gateway.

Observed HTTP redirect to login page, confirming successful routing.

**Screenshot:**

---

## 11. Configured Persistent Storage

Dynamic Persistent Volumes created automatically using the AWS EBS CSI Driver.

Verified:

* StorageClass
* PVCs
* PVs

**Screenshot:**

---

## 12. Verified Data Persistence

Test performed:

* Stored MySQL data
* Deleted MySQL Pod
* Kubernetes recreated Pod automatically
* Database remained intact

Result:

Persistent storage worked successfully.

**Screenshot:**

---

## 13. Horizontal Pod Autoscaler

Configured HPA with:

* Minimum Replicas: 2
* Maximum Replicas: 4
* CPU Target: 70%

Verified HPA was functioning correctly.

**Screenshot:**

---

## 14. Resource Monitoring

Verified cluster resource usage using Metrics Server.

Checked:

* Node CPU
* Node Memory
* Pod CPU
* Pod Memory

**Screenshot:**

---

## 15. Gateway TLS Preparation

Installed cert-manager.

Created Let's Encrypt ClusterIssuer.

Configured Gateway for HTTPS listener using TLS Secret reference.

Verified Gateway configuration is ready for certificate provisioning.

**Screenshot:**

---

# Validation Performed

✔ Deployments running successfully

✔ Services accessible

✔ Gateway programmed

✔ HTTPRoute accepted

✔ External LoadBalancer working

✔ Persistent Volumes created

✔ PVCs bound successfully

✔ Database persistence verified

✔ Horizontal Pod Autoscaler configured

✔ Metrics Server operational

✔ TLS infrastructure configured

---

# Challenges Faced

* Gateway API route validation
* Envoy Gateway listener configuration
* HTTPRoute hostname matching
* External LoadBalancer routing
* Persistent storage provisioning
* cert-manager installation
* ClusterIssuer configuration
* TLS Secret generation workflow
* HTTP to HTTPS preparation

---

# Key Learnings

* Deploying applications on Amazon EKS
* Kubernetes networking using Gateway API
* Envoy Gateway configuration
* HTTPRoute traffic management
* Kubernetes persistent storage
* AWS EBS CSI integration
* Horizontal Pod Autoscaling
* Kubernetes resource management
* Debugging Gateway API resources
* Preparing production-ready TLS using cert-manager
