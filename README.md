# terraform-aws-lambda-api-gateway
Creates one or more lambdas that source code from an S3 bucket and are fronted by API Gateway

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.44.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambdas"></a> [lambdas](#module\_lambdas) | ./lambda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.api_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_domain_name.api_gateway_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_stage.stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.artifact_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.artifact_bucket_pab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.artifact_bucket_sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_acm_certificate.acm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The overall name of the app. ex. gmail | `string` | n/a | yes |
| <a name="input_cors"></a> [cors](#input\_cors) | Optional, additional CORS rules. When any lambda has catch\_all = true, allow\_methods is forced to ["*"] since route methods aren't enumerable. | <pre>object({<br/>    allowed_headers = list(string)<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>  })</pre> | <pre>{<br/>  "allowed_headers": [],<br/>  "allowed_methods": [],<br/>  "allowed_origins": []<br/>}</pre> | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain for this API. Must have a hosted zone and ACM cert. ex. google.com | `string` | n/a | yes |
| <a name="input_lambdas"></a> [lambdas](#input\_lambdas) | Lambda definitions. Key is the name, value is lambda props. Set catch\_all = true to send all unmatched requests to that lambda via the v2 HTTP API $default route. | <pre>map(object({<br/>    routes = optional(list(object({<br/>      method = string,<br/>      path   = string,<br/>    })), []),<br/>    catch_all = optional(bool, false),<br/>    env_vars  = map(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_subdomain_prefix"></a> [subdomain\_prefix](#input\_subdomain\_prefix) | The subdomain name to host this API. ex. mail | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_bucket_arn"></a> [artifact\_bucket\_arn](#output\_artifact\_bucket\_arn) | ARN of the lambda artifact bucket |
| <a name="output_artifact_bucket_name"></a> [artifact\_bucket\_name](#output\_artifact\_bucket\_name) | Name of the lambda artifact bucket |
| <a name="output_deploy_targets"></a> [deploy\_targets](#output\_deploy\_targets) | Per-lambda info for building a deploy role: bucket + per-lambda function name, ARN, and S3 artifact key. |
| <a name="output_lambda_arns"></a> [lambda\_arns](#output\_lambda\_arns) | Map of lambda name => function ARN |
| <a name="output_lambda_role_arns"></a> [lambda\_role\_arns](#output\_lambda\_role\_arns) | Map of lambda name => execution role ARN |
<!-- END_TF_DOCS -->