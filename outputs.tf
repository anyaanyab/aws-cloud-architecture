# The ELB DNS name can be used to access the website
# It can be found in the AWS Console or will be displayed in the terminal through this code:

output "elb_dns_name" {
  value = aws_lb.web.dns_name
}