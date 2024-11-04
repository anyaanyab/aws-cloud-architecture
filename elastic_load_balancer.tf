# File containing configuration for creating an Application Load Balancer (ALB) 
# Used to distribute traffic across EC2 instances

resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id] # Deployment across two availability zones
}

# Resource for creating a Target Group for the ALB
resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Configuration of health checks 
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 15
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    timeout            = 5
    unhealthy_threshold = 2
  }
}

# Resource for creating a Listener for the ALB
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  # Rule for forwarding all traffic to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}