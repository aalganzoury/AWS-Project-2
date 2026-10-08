# Public ALB: HTTP->HTTPS redirect, HTTPS listener placeholder (ACM var), access logs, drop invalid headers.
terraform {
  required_version = ">= 1.6"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}

resource "aws_lb" "this" {
  name                       = "lab-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id]
  subnets                    = var.public_subnet_ids
  drop_invalid_header_fields = true # WHY: header smuggling defense
  dynamic "access_logs" {
    for_each = var.access_log_bucket == "" ? [] : [1]
    content {
      bucket  = var.access_log_bucket
      prefix  = var.access_log_prefix
      enabled = true
    }
  }
  tags = var.tags
}

resource "aws_lb_target_group" "app" {
  name        = "lab-app-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }
  tags = var.tags
}

resource "aws_lb_target_group_attachment" "app" {
  count            = length(var.target_ips)
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = var.target_ips[count.index]
  port             = var.app_port
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
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

# HTTPS listener created only when ACM ARN provided (placeholder for lab without domain).
resource "aws_lb_listener" "https" {
  count             = var.acm_certificate_arn == "" ? 0 : 1
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
