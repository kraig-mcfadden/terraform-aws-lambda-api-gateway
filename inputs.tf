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
  }))
  description = "Lambda definitions. Key is the name, value is lambda props. Set catch_all = true to send all unmatched requests to that lambda via the v2 HTTP API $default route."
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
