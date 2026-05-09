<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | >= 2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_integration.api_gateway_lambda_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_route.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.lambda_logging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_logging_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.lambda_api_gateway_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_object.bootstrapping_the_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [archive_file.fake_bootstrap](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_logging_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_execution_arn"></a> [api\_execution\_arn](#input\_api\_execution\_arn) | Execution ARN of the API Gateway fronting this lambda | `string` | n/a | yes |
| <a name="input_api_id"></a> [api\_id](#input\_api\_id) | Id of the API Gateway fronting this lambda | `string` | n/a | yes |
| <a name="input_artifact_bucket"></a> [artifact\_bucket](#input\_artifact\_bucket) | Name of the bucket where lambda will pull source code from | `string` | n/a | yes |
| <a name="input_catch_all"></a> [catch\_all](#input\_catch\_all) | If true, route all unmatched API Gateway requests to this lambda via the v2 HTTP API $default route. Routes are still honored for explicit matches if both are supplied. | `bool` | `false` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Optional set of environment variables | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of this lambda | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | REST verb and path for hitting lambda; e.g. GET /emails. Ignored when catch\_all = true. | <pre>list(object({<br/>    method = string,<br/>    path   = string,<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_key"></a> [artifact\_key](#output\_artifact\_key) | S3 key the lambda's code is loaded from. Use this to scope a deploy role's s3:PutObject permission. |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | Lambda function ARN |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Lambda execution role ARN |
<!-- END_TF_DOCS -->