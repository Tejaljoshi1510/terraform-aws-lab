variable "vpc_id" {
  description = "VPC ID where EC2 will be created"
  type = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be created"
  type = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type  = string
  default = "t3.micro"
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB"
  type        = string
}