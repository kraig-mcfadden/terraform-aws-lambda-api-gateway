output "artifact_bucket_arn" {
  value       = aws_s3_bucket.artifact_bucket.arn
  description = "ARN of the lambda artifact bucket"
}

output "artifact_bucket_name" {
  value       = aws_s3_bucket.artifact_bucket.bucket
  description = "Name of the lambda artifact bucket"
}

output "lambda_role_arns" {
  value       = { for name, m in module.lambdas : name => m.role_arn }
  description = "Map of lambda name => execution role ARN"
}

output "lambda_arns" {
  value       = { for name, m in module.lambdas : name => m.lambda_arn }
  description = "Map of lambda name => function ARN"
}

output "lambda_security_group_ids" {
  value       = { for name, m in module.lambdas : name => m.security_group_id if m.security_group_id != null }
  description = "Map of lambda name => security group ID for VPC-attached lambdas. Pass these to your DB module's allowed_security_group_ids to let the lambda connect."
}

output "lambda_role_names" {
  value       = { for name, m in module.lambdas : name => m.role_name }
  description = "Map of lambda name => execution role name. Use to attach extra policies (e.g., secretsmanager:GetSecretValue) from the caller."
}

# Bundle of everything a caller needs to construct a CI deploy IAM role
# (s3:PutObject on the right key, lambda:UpdateFunctionCode on the right ARN).
output "deploy_targets" {
  description = "Per-lambda info for building a deploy role: bucket + per-lambda function name, ARN, and S3 artifact key."
  value = {
    artifact_bucket_arn  = aws_s3_bucket.artifact_bucket.arn
    artifact_bucket_name = aws_s3_bucket.artifact_bucket.bucket
    lambdas = {
      for name, m in module.lambdas : name => {
        function_name = name
        function_arn  = m.lambda_arn
        artifact_key  = m.artifact_key
      }
    }
  }
}
