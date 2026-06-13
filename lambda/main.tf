/* ------- Lambda ------- */

resource "aws_lambda_function" "lambda" {
  architectures = ["arm64"]
  function_name = var.name
  handler       = "doesnt.matter"
  runtime       = "provided.al2023"
  timeout       = 30
  memory_size   = 128
  role          = aws_iam_role.lambda_role.arn
  s3_bucket     = var.artifact_bucket
  s3_key        = aws_s3_object.bootstrapping_the_bootstrap.key

  environment {
    variables = var.env_vars
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids = vpc_config.value.subnet_ids
      security_group_ids = concat(
        [aws_security_group.lambda[0].id],
        vpc_config.value.additional_security_group_ids,
      )
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logging_policy_attachment,
    aws_iam_role_policy_attachment.lambda_vpc_access,
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}

/* ------- API Gateway Integration ------- */

resource "aws_lambda_permission" "lambda_api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # /*/* matches any stage and any route on this v2 HTTP API.
  source_arn = "${var.api_execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "api_gateway_lambda_integration" {
  api_id             = var.api_id
  integration_type   = "AWS_PROXY"
  connection_type    = "INTERNET"
  description        = "API gateway integration for lambda ${var.name}"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  for_each = { for i, route in var.routes : i => route }

  api_id    = var.api_id
  route_key = "${upper(trimspace(each.value.method))} ${trimspace(each.value.path)}"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "default" {
  count = var.catch_all ? 1 : 0

  api_id    = var.api_id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_lambda_integration.id}"
}
