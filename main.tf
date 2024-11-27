/* ------- S3 Artifact Bucket ------- */

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "${var.app_name}-lambda-artifacts"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_bucket_sse" {
  bucket = aws_s3_bucket.artifact_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = "true"
  }
}

/* ------- API Gateway ------- */

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.app_name}-lambda-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = toset(["https://${var.domain}"])
    allow_methods = toset(flatten([for lambda_def in var.lambdas : [for route in lambda_def.routes : upper(trimspace(route.method))]]))
  }
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name   = var.subdomain_prefix

  default_route_settings {
    throttling_burst_limit = 5
    throttling_rate_limit  = 1
  }
}

/* ------- Route 53 API Alias ------- */

data "aws_route53_zone" "zone" {
  name = var.domain
}

data "aws_acm_certificate" "acm" {
  domain = var.domain
}

resource "aws_apigatewayv2_domain_name" "api_gateway_domain" {
  domain_name = "${var.subdomain_prefix}.${var.domain}"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.acm.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "alias" {
  name    = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  domain_name = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name
  stage       = aws_apigatewayv2_stage.stage.id
}

/* ------- Lambdas ------- */

module "lambdas" {
  for_each = var.lambdas
  source   = "./lambda"

  name   = each.key
  routes = each.value.routes

  api_id            = aws_apigatewayv2_api.api_gateway.id
  api_execution_arn = aws_apigatewayv2_api.api_gateway.execution_arn
  artifact_bucket   = aws_s3_bucket.artifact_bucket.bucket
}
