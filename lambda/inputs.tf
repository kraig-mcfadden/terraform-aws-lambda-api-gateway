variable "name" {
  type        = string
  description = "Name of this lambda"
}

variable "routes" {
  type = list(object({
    method = string,
    path   = string,
  }))
  default     = []
  description = "REST verb and path for hitting lambda; e.g. GET /emails. Ignored when catch_all = true."
}

variable "catch_all" {
  type        = bool
  default     = false
  description = "If true, route all unmatched API Gateway requests to this lambda via the v2 HTTP API $default route. Routes are still honored for explicit matches if both are supplied."
}

variable "api_id" {
  type        = string
  description = "Id of the API Gateway fronting this lambda"
}

variable "api_execution_arn" {
  type        = string
  description = "Execution ARN of the API Gateway fronting this lambda"
}

variable "artifact_bucket" {
  type        = string
  description = "Name of the bucket where lambda will pull source code from"
}

variable "env_vars" {
  type        = map(string)
  description = "Optional set of environment variables"
  default     = {}
}

variable "vpc_config" {
  type = object({
    vpc_id                        = string
    subnet_ids                    = list(string)
    additional_security_group_ids = optional(list(string), [])
  })
  default     = null
  description = "If set, VPC-attaches the lambda. subnet_ids should be private subnets in 2+ AZs. The module creates an SG in vpc_id and outputs its id; additional_security_group_ids are attached on top of it."
}
