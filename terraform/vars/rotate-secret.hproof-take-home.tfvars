azure = {
  subscription_id = "<no-subscription_id-given>"
  location        = "westus"
  project_name    = "hproof-take-home"
  secret_key      = "GoogleMapKey"
}

gcp = {
  project_id      = "hproof-take-home"
  region          = "us-central1"
  maps_key_prefix = "maps-api-key"
  services = [
    "static-maps-backend.googleapis.com",
    # "maps-embed-backend.googleapis.com",
    # "maps-backend.googleapis.com",
  ]
  rotation = {
    days   = 1
    manual = "0" # change to rotate the API key outside of the regular schedule
  }
}
