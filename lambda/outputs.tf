output "role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}
