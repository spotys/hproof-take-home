variable "azure" {
  type = object({
    location     = string
    project_name = string
    secret_key   = string
  })
}

variable "gcp" {
  type = object({
    project_id      = string
    maps_key_prefix = string
    services        = list(string)
    rotation_hours  = optional(number, 24)
  })
}
