# File defining the launch template used by autoscaling group to launch EC2 instances
# Includes necessary configuration for EC2 instances

resource "aws_launch_template" "web" {
  name_prefix   = "web"
  image_id      = data.aws_ami.ubuntu.id # Ubuntu AMI retrieved from AWS with data.tf
  instance_type = var.instance_type

  # Configuration of network settings
  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [aws_security_group.web.id]
  }

  # User data script is added
  user_data = filebase64("${path.module}/user-data-az.sh")
}