# Google - the API key rotation logic
locals {
  time_now  = timestamp()
  key_count = 2
}

# we have two keys
#  - each starting the rotation interval at a different point in time (the rfc3339 attribute)
#  - each rotated after double the requested interval to allow for safe app/service reconfiguration/restart period (the rotation_hours attribute)
# this results in one rotation per requested interval
resource "time_rotating" "api_key_rotation_period" {
  count = local.key_count

  rfc3339        = timeadd(local.time_now, "-${count.index * var.gcp.rotation_hours}h")
  rotation_hours = local.key_count * var.gcp.rotation_hours
}

resource "random_id" "api_key_suffix" {
  count = local.key_count

  byte_length = 2

  keepers = {
    rotation_time = time_rotating.api_key_rotation_period[count.index].rotation_rfc3339
  }
}

resource "google_apikeys_key" "api_key" {
  count = local.key_count

  provider = google

  project      = var.gcp.project_id
  name         = "${var.gcp.maps_key_prefix}-${random_id.api_key_suffix[count.index].hex}"
  display_name = "${var.gcp.maps_key_prefix}-${random_id.api_key_suffix[count.index].hex}"

  restrictions {

    dynamic "api_targets" {
      for_each = toset(var.gcp.services)

      content {
        service = api_targets.value
      }
    }
  }

  lifecycle {
    replace_triggered_by = [
      random_id.api_key_suffix[count.index].hex
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

# The tricky part - save the newest API key to Azure KeyVault
#   - simply sort by rotation timestamp and pick the last i.e. the latest
locals {
  api_key_map         = { for i in range(local.key_count) : time_rotating.api_key_rotation_period[i].rotation_rfc3339 => google_apikeys_key.api_key[i].key_string }
  rotation_timestamps = [for k, _ in local.api_key_map : k]
  latest_timestamp    = sort(local.rotation_timestamps)[length(local.rotation_timestamps) - 1]
  latest_api_key      = local.api_key_map[local.latest_timestamp]
}

resource "azurerm_key_vault_secret" "the_secret" {
  provider = azurerm

  name         = var.azure.secret_key
  value        = local.latest_api_key # new version gets created if the value changes
  key_vault_id = data.azurerm_key_vault.the_kv.id
}
