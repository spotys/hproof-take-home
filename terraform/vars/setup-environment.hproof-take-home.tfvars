azure_environment = {
  name       = "hproof-take-home"
  location   = "westus"
  secret_key = "GoogleMapKey"
}

google_environment = {
  name            = "hproof-take-home"
  billing_account = "011A32-A69AFA-5D6862"
  services = [
    "apikeys.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "static-maps-backend.googleapis.com",
    # "maps-embed-backend.googleapis.com",
    # "maps-backend.googleapis.com",
  ]
}
