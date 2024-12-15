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
    service         = string
    rotation = optional(object({
      years   = optional(number)
      months  = optional(number)
      days    = optional(number)
      hours   = optional(number)
      minutes = optional(number)
      manual  = optional(string, "0")
      }), { days = 1 }
    )
  })
}
