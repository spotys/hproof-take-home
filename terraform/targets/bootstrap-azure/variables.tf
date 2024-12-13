variable "azure" {
  type = object({
    location     = string
    project_name = string
    tags         = optional(map(string), {})
  })
}
