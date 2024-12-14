locals {
  project_id = replace(var.google_environment.name, " ", "-")
}

resource "google_project" "google_project" {
  name            = var.google_environment.name
  project_id      = local.project_id
  billing_account = var.google_environment.billing_account
}

resource "google_project_service" "maps_service" {
  for_each = toset(var.google_environment.services)
  project  = google_project.google_project.project_id
  service  = each.value
}
