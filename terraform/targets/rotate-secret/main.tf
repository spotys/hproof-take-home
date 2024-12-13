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

  name         = "${var.gcp.maps_key_prefix}-${random_id.api_key_suffix.hex}"
  display_name = "My micro-service Maps Key"

  restrictions {
    api_targets {
      service = "maps-backend.googleapis.com"
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

resource "azurerm_resource_group" "the_rg" {
  provider = azurerm

  name     = "${var.azure.project_name}-rg"
  location = var.azure.location
}

resource "azurerm_key_vault" "the_kv" {
  provider = azurerm

  name                       = "${var.azure.project_name}-kv"
  location                   = azurerm_resource_group.the_rg.location
  resource_group_name        = azurerm_resource_group.the_rg.name
  tenant_id                  = data.azurerm_client_config.this.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.this.tenant_id
    object_id = data.azurerm_client_config.this.object_id

    key_permissions = [] # not using keys here

    secret_permissions = [
      "Get",
      "Set",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "the_secret" {
  provider = azurerm

  name         = var.azure.secret_key
  value        = google_apikeys_key.maps.key_string # new version gets created if the value changes
  key_vault_id = azurerm_key_vault.the_kv.id
}
