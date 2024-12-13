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
    region          = string
    maps_key_prefix = string
    rotation = optional(object({
      years   = optional(number, 0)
      months  = optional(number, 0)
      days    = optional(number, 0)
      hours   = optional(number, 0)
      minutes = optional(number, 0)
      manual  = optional(string, "0")
      }), { days = 1 }
    )
  })
}
