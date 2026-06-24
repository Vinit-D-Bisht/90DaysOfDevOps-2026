# Day 62 - Providers, Resources and Dependencies

## main.tf with Resource Explanations

```hcl
# Creates a VPC with CIDR block 10.0.0.0/16
resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TerraWeek-VPC"
  }
}

# Creates a public subnet inside the VPC
resource "aws_subnet" "Subnet" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerraWeek-Public-Subnet"
  }
}

# Attaches an Internet Gateway to the VPC
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.VPC.id
}

# Creates a route table and adds a route to the Internet Gateway
resource "aws_route_table" "awsRT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

# Associates the route table with the subnet
resource "aws_route_table_association" "assoRT" {
  subnet_id      = aws_subnet.Subnet.id
  route_table_id = aws_route_table.awsRT.id
}

# Creates a security group for the EC2 instance
resource "aws_security_group" "SG" {
  name        = "aws-SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.VPC.id

  tags = {
    Name = "TerraWeek-SG"
  }
}

# Allows SSH access from anywhere
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allows HTTP access from anywhere
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allows all outbound traffic
resource "aws_vpc_security_group_egress_rule" "egressSG" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Creates an EC2 instance in the subnet
resource "aws_instance" "my_instance" {
  ami                         = "ami-05416e951c79e4833"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.Subnet.id
  vpc_security_group_ids      = [aws_security_group.SG.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "TerraWeek-server"
  }
}

# Creates an S3 bucket after the EC2 instance is created
resource "aws_s3_bucket" "my_bucket" {
  depends_on = [aws_instance.my_instance]

  bucket = "vinit-ki-secret-bucket"

  tags = {
    Name = "my BT"
  }
}
```

---

## Implicit vs Explicit Dependencies

### Implicit Dependencies

Implicit dependencies are automatically detected by Terraform when one resource references another resource.

For example:

```hcl
vpc_id = aws_vpc.VPC.id
```

The subnet needs the VPC ID, so Terraform automatically creates the VPC before creating the subnet.

Examples from this project:

* Subnet depends on VPC
* Internet Gateway depends on VPC
* Route Table depends on VPC and Internet Gateway
* Route Table Association depends on Subnet and Route Table
* Security Group depends on VPC
* EC2 Instance depends on Subnet and Security Group

Terraform uses these references to build a dependency graph and determine the correct creation order.

### Explicit Dependencies

Explicit dependencies are defined manually using `depends_on`.

Example:

```hcl
depends_on = [aws_instance.my_instance]
```

The S3 bucket does not directly reference the EC2 instance, so Terraform cannot detect the dependency automatically. Using `depends_on` tells Terraform to create the EC2 instance first and then create the S3 bucket.

### Difference

* Implicit dependencies are created automatically through resource references.
* Explicit dependencies are created manually using `depends_on`.
* Terraform prefers implicit dependencies whenever possible.
* Explicit dependencies are useful when resources depend on each other but do not directly reference each other's attributes.

