variable "azure_environment" {
  type = object({
    name     = string
    location = string
  })
}

variable "google_environment" {
  type = object({
    name            = string
    billing_account = string
    services        = list(string)
  })
}
