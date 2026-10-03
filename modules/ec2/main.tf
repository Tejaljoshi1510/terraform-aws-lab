# Security Group
resource "aws_security_group" "web" {
  name  = "terraform-lab-web-sg"
  description = "Security group for web server"
  vpc_id = var.vpc_id

  tags = {
    Name = "web-sg"
  }
}
#For the web Security Group, allow incoming TCP traffic from any IPv4 address to port 80.
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port  = 80
}
# Egress - All
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4 = "0.0.0.0/0"
  #All IP protocols not restricting for tcp/udp
  ip_protocol = "-1"
}
#This controls outgoing traffic from EC2
# EC2 Instance
resource "aws_instance" "web" {
  ami  = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  tags = {
    Name = "instance-web"
  }
}
