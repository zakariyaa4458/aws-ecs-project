resource "aws_lb" "web-lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



resource "aws_lb_target_group" "alb-tg" {
  name        = "tf-example-lb-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/22" # 1,024 IPs - right-sized
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "my-app-vpc"
    Environment = "production"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index + 1}"
    Type = "public"
  }
}

# ALB Security Group - accepts traffic from internet
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "alb-sg" }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_acm_certificate_validation" "cert_validation" {


  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

}

resource "aws_route53_record" "cert_validation" {

  for_each = {
    for option in aws_acm_certificate.cert.domain_validation_options :
    option.domain_name => option
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]

}

resource "aws_acm_certificate" "cert" {
  domain_name       = "www.zakariyaalab.com"
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "main" {
  name         = "zakariyaalab.com"
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"


  alias {
    name                   = aws_lb.web-lb.dns_name
    zone_id                = aws_lb.web-lb.zone_id
    evaluate_target_health = true
  }
}
