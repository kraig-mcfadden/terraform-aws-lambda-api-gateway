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

output "security_group_id" {
  value       = one(aws_security_group.lambda[*].id)
  description = "ID of the security group created for this lambda's VPC ENI. Null when vpc_config is not set. Reference this from a DB SG to allow Lambda -> DB."
}

output "role_name" {
  value       = aws_iam_role.lambda_role.name
  description = "Lambda execution role name. Useful for attaching extra IAM policies from the caller."
}
