azure = {
  subscription_id = "<no-subscription_id-given>"
  location        = "westus"
  project_name    = "hproof-take-home"
  secret_key      = "GoogleMapKey"
}

gcp = {
  project_id      = "<no-project-id-given>"
  region          = "us-central1"
  maps_key_prefix = "maps-api-key"

  rotation = {
    days   = 1
    manual = "0" # change to rotate the API key outside of the regular schedule
  }
}
