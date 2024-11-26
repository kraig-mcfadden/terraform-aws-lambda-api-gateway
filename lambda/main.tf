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

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logging_policy_attachment,
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}

/* ------- API Gateway Integration ------- */

resource "aws_lambda_permission" "lambda_api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${var.api_execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "api_gateway_lambda_integration" {
  api_id             = var.api_id
  integration_type   = "AWS_PROXY"
  connection_type    = "INTERNET"
  description        = "API gateway integration for lambda ${var.name}"
  integration_method = upper(trimspace(var.method))
  integration_uri    = aws_lambda_function.lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = var.api_id
  route_key = "${upper(trimspace(var.method))} ${trimspace(var.path)}"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_lambda_integration.id}"
}

resource "aws_apigatewayv2_deployment" "deployment" {
  api_id      = var.api_id
  description = "${var.name} API deployment"

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.api_gateway_lambda_integration),
      jsonencode(aws_apigatewayv2_route.route),
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}
