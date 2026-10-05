resource "aws_security_group" "alb" {
  name = "terraform-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id = var.vpc_id

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_lb" "main" {
  name = "terraform-alb"
  load_balancer_type = "application"
  internal           = false

  subnets = var.public_subnet_ids

  security_groups = [
    aws_security_group.alb.id
  ]

  tags = {
    Name = "terraform-alb"
  }
}
# target group 
resource "aws_lb_target_group" "web" {
  name = "terraform-web-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    port = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
  }

  tags = {
    Name = "terraform-web-target-group"
  }
}

#connect the EC2 to this target group
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id = var.target_instance_id
  port  = 80
}

#create alb listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}