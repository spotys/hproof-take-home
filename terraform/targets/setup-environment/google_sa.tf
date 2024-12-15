locals {
  service_account_name = "${var.azure_environment.name}-sa"
  service_account_id   = replace(local.service_account_name, " ", "-")
}

# import {
#   to = google_service_account.google_sa
#   id = "projects/hproof-take-home/serviceAccounts/hproof-take-home-sa@hproof-take-home.iam.gserviceaccount.com"
# }

resource "google_service_account" "google_sa" {
  project      = google_project.google_project.project_id
  display_name = local.service_account_name
  account_id   = local.service_account_id
}

resource "google_project_iam_binding" "project-sa-binding" {
  project = google_project.google_project.project_id
  role    = "roles/serviceusage.apiKeysAdmin"

  members = [
    google_service_account.google_sa.member,
  ]
}

resource "google_service_account_key" "google_sa_key" {
  service_account_id = google_service_account.google_sa.id
}

output "google_sa_keyfile" {
  value     = base64decode(google_service_account_key.google_sa_key.private_key)
  sensitive = true
}
