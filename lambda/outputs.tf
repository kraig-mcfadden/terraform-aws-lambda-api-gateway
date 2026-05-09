output "role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "Lambda execution role ARN"
}

output "lambda_arn" {
  value       = aws_lambda_function.lambda.arn
  description = "Lambda function ARN"
}

output "artifact_key" {
  value       = aws_s3_object.bootstrapping_the_bootstrap.key
  description = "S3 key the lambda's code is loaded from. Use this to scope a deploy role's s3:PutObject permission."
}
