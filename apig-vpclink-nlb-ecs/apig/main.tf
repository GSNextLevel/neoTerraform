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

# Route
resource "aws_api_gateway_resource" "api-resource" {
  rest_api_id = aws_api_gateway_rest_api.apig.id
  parent_id   = aws_api_gateway_rest_api.apig.root_resource_id
  path_part   = "home"
}

resource "aws_api_gateway_method" "api-method" {
  rest_api_id   = aws_api_gateway_rest_api.apig.id
  resource_id   = aws_api_gateway_resource.api-resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# VPC_LINK 통합
resource "aws_api_gateway_integration" "nginx-vpc-link" {
  rest_api_id = aws_api_gateway_rest_api.apig.id
  resource_id = aws_api_gateway_resource.api-resource.id
  http_method = aws_api_gateway_method.api-method.http_method

  request_templates = {
    "application/json" = ""
    "application/xml"  = "#set($inputRoot = $input.path('$'))\n{ }"
  }

  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
    "integration.request.header.X-Foo"           = "'Bar'"
  }

  type                    = "HTTP"
  uri                     = "http://${data.aws_lb.nginx-nlb.dns_name}"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.nginx-vpclink.id
}

resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.apig.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.deploy.id
  rest_api_id   = aws_api_gateway_rest_api.apig.id
  stage_name    = "dev"
}
