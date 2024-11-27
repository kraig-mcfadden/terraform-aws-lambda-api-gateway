variable "name" {
  type        = string
  description = "Name of this lambda"
}

variable "routes" {
  type = list(object({
    method = string,
    path   = string,
  }))
  description = "REST verb and path for hitting lambda; e.g. GET /emails"
}

variable "api_id" {
  type        = string
  description = "Id of the API Gateway fronting this lambda"
}

variable "api_execution_arn" {
  type    = string
  default = "Execution ARN of the API Gateway fronting this lambda"
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
