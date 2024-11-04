# File defining variables used across all resources

# Define region variable with a default value
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

# Define instance type variable with a default value
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}