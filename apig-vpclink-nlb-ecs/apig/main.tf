resource "aws_api_gateway_rest_api" "apig" {
  name        = var.apigateway-name
  description = var.apigateway-name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# vpc-link
resource "aws_api_gateway_vpc_link" "nginx-vpclink" {
  name        = var.vpclink_name
  description = var.vpclink_name
  target_arns = [aws_lb.nginx-nlb.arn]

  tags = {
    Name = var.vpclink_name
  }
}

# Custom Domain
data "aws_acm_certificate" "amazon_issued" {
  domain      = var.my_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_api_gateway_domain_name" "nginx-custom-domain" {
  domain_name              = var.custom_domain
  regional_certificate_arn = data.aws_acm_certificate.amazon_issued.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = var.custom_domain
  }
}

# A record
data "aws_route53_zone" "selected" {
  name         = var.my_domain
  private_zone = false
}

resource "aws_route53_record" "example" {
  name    = aws_api_gateway_domain_name.nginx-custom-domain.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.selected.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.nginx-custom-domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.nginx-custom-domain.regional_zone_id
  }
}

# Route - 점검 필요
resource "aws_api_gateway_resource" "api-resource" {
  rest_api_id = aws_api_gateway_rest_api.apig.id
  parent_id   = aws_api_gateway_rest_api.apig.root_resource_id
  path_part   = "/"
}

resource "aws_api_gateway_method" "api-method" {
  rest_api_id   = aws_api_gateway_rest_api.apig.id
  resource_id   = aws_api_gateway_resource.api-resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# 통합
