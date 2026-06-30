# Day 67 - TerraWeek Capstone

## Project Structure

```text
terraweek-capstone/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── dev.tfvars
├── stage.tfvars
├── prod.tfvars
└── modules/
    ├── vpc/
    │   └── main.tf
    ├── ec2/
    │   └── main.tf
    └── s3/
        └── main.tf
```

---

## Module Configs

### modules/vpc/main.tf

```hcl
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
}
```

### modules/ec2/main.tf

```hcl
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
}
```

### modules/s3/main.tf

```hcl
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}
```

---

## Root main.tf

```hcl
locals {
  env = terraform.workspace
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.cidr_block
}

module "ec2" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = var.instance_type
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "terra-${local.env}-bucket"
}
```

---

## Environment tfvars

### dev.tfvars

```hcl
instance_type = "t2.micro"
cidr_block    = "10.0.0.0/16"
```

### stage.tfvars

```hcl
instance_type = "t2.small"
cidr_block    = "10.1.0.0/16"
```

### prod.tfvars

```hcl
instance_type = "t3.medium"
cidr_block    = "10.2.0.0/16"
```

**Differences:**
- Dev → `t2.micro`, `10.0.0.0/16`
- Stage → `t2.small`, `10.1.0.0/16`
- Prod → `t3.medium`, `10.2.0.0/16`

---

## Terraform Best Practices

- Use modules for reusable code.
- Store state remotely.
- Keep variables in tfvars files.
- Use workspaces for multiple environments.
- Pin provider versions.
- Run `terraform fmt` and `terraform validate`.
- Review changes with `terraform plan`.

---

## TerraWeek Summary

| Day | Concepts |
|-----|----------|
| 61 | IaC, HCL, init/plan/apply/destroy, state basics |
| 62 | Providers, resources, dependencies, lifecycle |
| 63 | Variables, outputs, data sources, locals, functions |
| 64 | Remote backend, locking, import, drift |
| 65 | Custom modules, registry modules, versioning |
| 66 | EKS with modules, real-world provisioning |
| 67 | Workspaces, multi-env, capstone project |
