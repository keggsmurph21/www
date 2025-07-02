resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.main_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/27"
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.32/27"
  availability_zone = "us-east-1b"
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_b.id
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.64/27"
  availability_zone = "us-east-1c"
}

resource "aws_route_table" "public_c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_c.id
}

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id

  name = "${var.env}-alb"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_80_all" {
  security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

//resource "aws_vpc_security_group_ingress_rule" "ingress_443_all" {
//  security_group_id = aws_security_group.alb.id
//
//  from_port   = 443
//  to_port     = 443
//  ip_protocol = "tcp"
//  cidr_ipv4   = "0.0.0.0/0"
//}

resource "aws_lb" "alb" {
  name_prefix        = "${var.env}-"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id,
  ]

  xff_header_processing_mode = "append"

  timeouts {
    create = "5m"
  }

  // If you recreate the ALB, you need to update the Squarespace DNS records.
  prevent_destroy = true
}

resource "aws_route53_record" "alb_default" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

//resource "aws_lb_listener" "https" {
//  load_balancer_arn = aws_lb.alb.arn
//  port              = "443"
//  protocol          = "HTTPS"
//  ssl_policy        = local.https_listener_ssl_policy
//  certificate_arn   = var.default_certificate_arn
//
//  default_action {
//    type = "fixed-response"
//
//    fixed_response {
//      content_type = "text/plain"
//      status_code  = "404"
//    }
//  }
//
//  tags = {
//    Name = "${var.resource_name_prefix}ALB Listener"
//  }
//}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }

  //default_action {
  //  type = "redirect"
  //
  //  redirect {
  //    port        = 443
  //    protocol    = "HTTPS"
  //    status_code = "HTTP_301"
  //  }
  //}
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 101

  action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      host        = "murp-us-public.s3.us-east-1.amazonaws.com"
      port        = 443
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = [
        "/*.html",
        "/images/*",
        "/js/*",
        "/styles/*",
      ]
    }
  }
}

resource "aws_lb_listener_rule" "index" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 102

  action {
    type = "redirect"

    redirect {
      path        = "/index.html"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
