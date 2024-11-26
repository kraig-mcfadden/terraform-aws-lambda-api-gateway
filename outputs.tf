output "artifact_bucket_arn" {
  value = aws_s3_bucket.artifact_bucket.arn
}

output "lambda_role_arns" {
  value = module.lambdas.role_arn
}

output "lambda_arns" {
  value = module.lambdas.lambda_arn
}
