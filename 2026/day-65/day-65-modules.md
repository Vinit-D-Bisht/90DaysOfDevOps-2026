# Day 65 - Terraform Modules

## 1. Custom Module Structure

```text
.
├── data.tf
├── locals.tf
├── main.tf
├── modules
│   ├── ec2-instance
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── security-group
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── providers.tf
├── variables.tf
└── vpc.tf
```

---

## 3. Root `main.tf`

```hcl
module "security_group" {
  source = "./modules/security-group"

  # input variables
}

module "ec2_instance" {
  source = "./modules/ec2-instance"

  # input variables
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "x.x.x"

  # VPC configuration
}
```

---

## 4. Hand-Written VPC vs Registry VPC Module

| Hand-Written VPC                 | Registry VPC Module                              |
| -------------------------------- | ------------------------------------------------ |
| Create VPC resources manually    | Creates all required VPC resources automatically |
| More Terraform code              | Less Terraform code                              |
| Full control over every resource | Easier and faster to deploy                      |
| Best for learning                | Best for reusable production deployments         |

---

## 5. Module Best Practices

* Pin registry module versions.
* Keep each module focused on one purpose.
* Use variables instead of hardcoding values.
* Define outputs for resource sharing.
* Make modules reusable and easy to maintain.

