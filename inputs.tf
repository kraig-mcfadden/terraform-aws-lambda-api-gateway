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
