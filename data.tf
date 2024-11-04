# File for fetching the latest Ubuntu AMI for the launch template

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # AWS account ID for Canonical, creator of Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
