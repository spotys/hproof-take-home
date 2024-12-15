# Google - the API key rotation logic
resource "time_rotating" "api_key_rotation_period" {
  rotation_years   = var.gcp.rotation.years
  rotation_months  = var.gcp.rotation.months
  rotation_days    = var.gcp.rotation.days
  rotation_hours   = var.gcp.rotation.hours
  rotation_minutes = var.gcp.rotation.minutes
}

resource "random_id" "api_key_suffix" {
  byte_length = 2

  keepers = {
    rotation_time  = time_rotating.api_key_rotation_period.rotation_rfc3339
    manual_trigger = var.gcp.rotation.manual
  }
}

resource "google_apikeys_key" "maps" {
  provider = google

  project = var.gcp.project_id
  name    = "${var.gcp.maps_key_prefix}-${random_id.api_key_suffix.hex}"

  restrictions {
    api_targets {
      service = var.gcp.service
    }
  }

  lifecycle {
    replace_triggered_by = [
      random_id.api_key_suffix.hex
    ]
  }
}

# Azure - the secret management logic
data "azurerm_client_config" "this" {}

data "azurerm_resource_group" "the_rg" {
  provider = azurerm

  name = "${var.azure.project_name}-rg"
}

data "azurerm_key_vault" "the_kv" {
  provider = azurerm

  name                = "${var.azure.project_name}-kv"
  resource_group_name = data.azurerm_resource_group.the_rg.name
}

resource "azurerm_key_vault_secret" "the_secret" {
  provider = azurerm

  name         = var.azure.secret_key
  value        = google_apikeys_key.maps.key_string # new version gets created if the value changes
  key_vault_id = data.azurerm_key_vault.the_kv.id
}
