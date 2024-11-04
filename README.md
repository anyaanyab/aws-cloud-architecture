# AWS Cloud Architecture

A cloud architecture for hosting a webpage using AWS.

## What is it?

This AWS cloud architecture is written in Terraform and makes the website:
- highly available;
- accessible from anywhere in the world;
- work without latency;
- autoscalable, if a lot of visitors come to the webpage.

## Components

main.tf:
- *VPC* - Virtual Private Cloud - creates isolated network environment
- Internet Gateway - enables internet access
- Public Subnets - host resources in different availability zones
- Route Table - manages network traffic flow
- Security Groups - control inbound/outbound traffic

launch_template.tf:
- Launch Template - defines *EC2* instance configuration
- User Data - configures Apache web server

elastic_load_balancer.tf:
- *ALB* - Application Load Balancer - distributes incoming traffic
- Target Group - manages instance health checks
- Listener - routes incoming requests

autoscaling.tf:
- *ASG* - Auto Scaling Group - maintains desired instance count
- Scaling Policies - adjusts capacity based on demand

data.tf:
- AMI Data Source - fetches latest Ubuntu AMI for the launch template

outputs.tf:
- ALB DNS Name - provides the endpoint URL for accessing the website

variables.tf:
- Variable Definitions - declares configurable parameters

variables.tfvars:
- Variable Values - sets actual values for parameters

user-data-az.sh:
- Bootstrap Script - installs and configures Apache

## Requirements

In order to implement this cloud architecture, following requirements have to be considered:
- Terraform is installed on the computer (for example, using Homebrew);
- AWS account is set up; access key and secret key have been retrieved;
- Terraform extensions can be downloaded in the IDE (for example, in VSCode).

## Installation

To run this project locally, clone the repository:
    git clone https://github.com/anyaanyab/aws-cloud-architecture

## Usage

After opening the project files in your IDE of choice:
- Insert access key and secret key in main.tf;
- Run *terraform init* to initialize Terraform;
- Run *terraform plan* to have Terraform plan out the implementation;
- Run *terraform apply* to make Terraform apply the configuration in your AWS account;
- After *Apply complete!*, the ELB DNS name will be displayed next to *elb_dns_name*, which can be inserted into your browser to check if the website is working correctly;
- Run *terraform destroy* to destroy the configuration.

### Enjoy the AWS Cloud Architecture!
