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
    routes = list(object({
      method = string,
      path   = string,
    })),
    env_vars = map(string)
  }))
  description = "Lambda definitions. Key is the name, value is lambda props"
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
  description = "Optional, additional CORS rules"
}
