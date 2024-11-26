resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = var.name
  retention_in_days = 14
}

data "aws_iam_policy_document" "lambda_logging_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.lambda_log_group.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "${var.name}-lambda-logging-policy"
  description = "Allow lambda to send logs to Cloudwatch"
  policy      = data.aws_iam_policy_document.lambda_logging_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}
