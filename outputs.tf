output "artifact_bucket_arn" {
  value = aws_s3_bucket.artifact_bucket.arn
}

output "lambda_role_arns" {
  value = { for lambda_name, outputs in module.lambdas : lambda_name => outputs.role_arn }
}

output "lambda_arns" {
  value = { for lambda_name, outputs in module.lambdas : lambda_name => outputs.lambda_arn }
}
