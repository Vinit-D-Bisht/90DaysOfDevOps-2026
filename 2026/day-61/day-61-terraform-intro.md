# Day 61 - Terraform Introduction

## What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) is the practice of managing cloud infrastructure using code instead of manually creating resources. It helps automate deployments, keeps environments consistent, and reduces human errors. Terraform is a popular IaC tool used to create and manage cloud resources.

## Terraform Apply Output

Add a screenshot of `terraform apply` showing the creation of:

* S3 Bucket
* EC2 Instance

```md
![Terraform Apply Output](terraform-apply.png)
```

## AWS Console Resources

Add a screenshot showing the created resources in the AWS Console.

```md
![AWS Resources](aws-console.png)
```

## Terraform Commands

| Command                | Description                                                |
| ---------------------- | ---------------------------------------------------------- |
| `terraform init`       | Initializes the Terraform project and downloads providers. |
| `terraform plan`       | Shows the changes Terraform will make.                     |
| `terraform apply`      | Creates or updates resources.                              |
| `terraform destroy`    | Removes all managed resources.                             |
| `terraform show`       | Displays details of the current state.                     |
| `terraform state list` | Lists resources tracked by Terraform.                      |

## Terraform State File

The `terraform.tfstate` file stores information about the infrastructure managed by Terraform. It contains resource details, IDs, and current configuration data. Terraform uses this file to track resources and determine what changes need to be made during future runs.

