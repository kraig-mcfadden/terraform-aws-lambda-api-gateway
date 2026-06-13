variable "app_name" {
  type        = string
  description = "The overall name of the app. ex. gmail"
}

variable "domain" {
  type        = string
  description = "Domain for this API. Must have a hosted zone and ACM cert. ex. google.com"
}

variable "subdomain_prefix" {
  type        = string
  description = "The subdomain name to host this API. ex. mail"
}

variable "lambdas" {
  type = map(object({
    routes = optional(list(object({
      method = string,
      path   = string,
    })), []),
    catch_all = optional(bool, false),
    env_vars  = map(string)
    vpc_config = optional(object({
      vpc_id                        = string
      subnet_ids                    = list(string)
      additional_security_group_ids = optional(list(string), [])
    }))
  }))
  description = "Lambda definitions. Key is the name, value is lambda props. Set catch_all = true to send all unmatched requests to that lambda via the v2 HTTP API $default route. Set vpc_config to VPC-attach the lambda; the module creates an SG per lambda and exposes its id via lambda_security_group_ids."
}

variable "cors" {
  type = object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
  })
  default = {
    allowed_headers = []
    allowed_methods = []
    allowed_origins = []
  }
  description = "Optional, additional CORS rules. When any lambda has catch_all = true, allow_methods is forced to [\"*\"] since route methods aren't enumerable."
}
