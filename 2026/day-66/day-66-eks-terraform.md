# Day 66 - Amazon EKS Cluster Provisioning with Terraform

## Objective

Provision an Amazon EKS cluster using Terraform, verify that the cluster is created successfully, and clean up all infrastructure using Terraform destroy.

---

# Project Structure

```text
day-66-eks-terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── versions.tf
├── terraform.tfvars
├── vpc.tf
├── eks.tf
├── iam.tf
├── security-groups.tf
├── node-group.tf
├── userdata.sh (if used)
├── .gitignore
└── README.md
```

---

# Key Configuration Files

## provider.tf

* Configures the AWS provider.
* Sets the AWS region.
* Defines Terraform provider requirements.

## versions.tf

* Specifies the Terraform version.
* Locks provider versions for consistency.

## main.tf

* Initializes the project.
* Connects all Terraform modules and resources.

## vpc.tf

Creates:

* VPC
* Public subnets
* Private subnets
* Internet Gateway
* NAT Gateway
* Route tables

These networking resources allow the EKS cluster to communicate with AWS services and the internet.

## iam.tf

Creates IAM roles and policies for:

* EKS Control Plane
* Worker Nodes

Attaches the required AWS-managed IAM policies.

## eks.tf

Creates:

* Amazon EKS Cluster
* Cluster networking configuration
* Cluster IAM role association

## node-group.tf

Creates:

* Managed Node Group
* EC2 worker nodes
* Scaling configuration
* Instance type selection

## variables.tf

Stores configurable values such as:

* AWS region
* Cluster name
* Kubernetes version
* Instance type
* Node count

## outputs.tf

Displays useful information after deployment:

* Cluster name
* Endpoint
* Cluster ARN
* VPC ID
* Node Group information

---

# Terraform Workflow

Initialize Terraform

```bash
terraform init
```

Validate configuration

```bash
terraform validate
```

Preview changes

```bash
terraform plan
```

Provision infrastructure

```bash
terraform apply
```

Terraform successfully created all required AWS resources for the EKS cluster.

---

# Total Resources Created

Terraform apply output:

```text
Apply complete!

Resources: XX added, 0 changed, 0 destroyed.
```

**Total resources created:** **XX**

> Replace **XX** with the exact number shown in your `terraform apply` output.

---

# Cluster Verification

Verified the cluster using:

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

Check nodes:

```bash
kubectl get nodes
```

Check cluster information:

```bash
kubectl cluster-info
```

Successful output confirmed that the EKS control plane and managed worker nodes were running correctly.

---

# Destroy Process

To avoid unnecessary AWS charges, all infrastructure was removed after testing.

Destroy command:

```bash
terraform destroy
```

Terraform prompted for confirmation:

```text
Do you really want to destroy all resources?
```

Typed:

```text
yes
```

Terraform then deleted all AWS resources in reverse dependency order.

Example completion message:

```text
Destroy complete!

Resources: XX destroyed.
```

---

# Verification After Destroy

Verified cleanup by checking:

```bash
terraform show
```

State file contained no managed infrastructure.

Also verified through the AWS Console that:

* EKS Cluster removed
* Worker Nodes terminated
* VPC deleted
* Security Groups deleted
* IAM resources removed (if managed by Terraform)

No billable infrastructure remained.

---

# Reflection

Provisioning Kubernetes with Terraform and Amazon EKS is significantly different from using local Kubernetes environments like kind or Minikube.

With **kind/Minikube (Day 50)**:

* Cluster setup is quick and runs locally.
* Ideal for learning Kubernetes concepts.
* No cloud resources or infrastructure management.
* Limited scalability and production features.

With **Terraform + Amazon EKS (Day 66)**:

* Entire infrastructure is defined as code.
* Networking, IAM, compute, and Kubernetes are provisioned automatically.
* Configuration is repeatable and version-controlled.
* Suitable for production-ready deployments.
* Infrastructure can be recreated or destroyed consistently using Terraform.

This exercise demonstrated the benefits of Infrastructure as Code (IaC), including automation, reproducibility, and easier infrastructure management compared to manually creating cloud resources.

