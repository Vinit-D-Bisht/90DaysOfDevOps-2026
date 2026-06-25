variable "region" {
  type        = string
  description = "aws region"
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  type        = string
  description = "aws vpc cidr"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "aws subnet cidr"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  type        = string
  description = "aws EC2 instance type"
  default     = "t3.micro"
}

variable "project_name" {
  type        = string
  description = "project name user provides it"
}

variable "environment" {
  type        = string
  description = "environment"
  default     = "dev"
}

variable "allowed_ports" {
  type        = list(number)
  description = "allowed port numbers"
  default     = [22, 80, 443]
}

variable "extra_tags" {
  type        = map(string)
  description = "extra tags by user"
  default     = {}
}


