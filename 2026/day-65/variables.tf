variable "ami_id" {
  type        = string
  description = "ami id of instance"
  default     = "ami-0189c3f216088b7db"
}

variable "instance_type" {
  type        = string
  description = "aws EC2 instance type"
  default     = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "aws subnet id"
  default     = "10.0.1.0/24"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "instance_name" {
  type        = string
  description = "aws EC2 instance name"
  default     = "Custom-instance"
}

variable "tags" {
  type        = map(string)
  description = "tags by user"
  default     = {}
}

