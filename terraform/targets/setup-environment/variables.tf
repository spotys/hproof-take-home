variable "environment" {
  type = object({
    name       = string
    location   = string
    secret_key = string
  })
}
