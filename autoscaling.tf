# File for creating an auto-scaling group 
# Automatically scales EC2 instances based on CPU usage or other metrics (traffic demand)

resource "aws_autoscaling_group" "web" {
  name               = "web-asg"
  desired_capacity   = 2 # Run 2 instances by default
  max_size           = 4 # Scale up to 4 instances
  min_size           = 2 # Never go below 2 instances
  target_group_arns  = [aws_lb_target_group.web.arn] # Target group defined
  vpc_zone_identifier = [aws_subnet.public_1.id, aws_subnet.public_2.id] # Deployment across two availability zones

  # Using the latest version of the launch template
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  # Applying a tag to the ASG
  tag {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  }

}