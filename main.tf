# File with definitions of the Terraform version, AWS provider and variables used globally across Terraform configuration

# Terraform AWS Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Terraform version defined
    }
  }
}

# AWS Provider configuration with specified region; authentication is set up:
# ATTENTION - access key and secret access key are missing
# -> to connect to your AWS account, provide these below; don't forget to remove the hashtags
provider "aws" {
  region = var.region
  # access_key = "your_access_key"
  # secret_key = "your_secret_key"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create Internet Gateway for public internet access, so everyone on the internet can access server
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Two subnets defined for high availability

# Create a public subnet for availability zone a
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet1"
  }
}

# Create a public subnet for availability zone b
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}b"

  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet2"
  }
}

# Create custom route table for public subnets, so traffic from subnet can get out to the internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# Subnet1 is associated with route table
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Subnet2 is associated with route table
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Create security group for the Application Load Balancer (ALB)
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.main.id

  # Incoming HTTP traffic (port 80) is allowed from everywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic is allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for web servers
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Web Security Group"
  vpc_id      = aws_vpc.main.id

  # Incoming HTTP traffic (port 80) is allowed only from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # All outbound traffic is allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}