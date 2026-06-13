resource "aws_security_group" "lambda" {
  count = var.vpc_config != null ? 1 : 0

  name        = "${var.name}-lambda"
  description = "Lambda ${var.name} ENI egress"
  vpc_id      = var.vpc_config.vpc_id
}

resource "aws_security_group_rule" "lambda_egress_all" {
  count = var.vpc_config != null ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda[0].id
  description       = "Allow all egress (DB in VPC, NAT to internet)"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  count = var.vpc_config != null ? 1 : 0

  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
