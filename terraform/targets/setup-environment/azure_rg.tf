locals {
  resource_group_name = "${var.azure_environment.name}-rg"
  key_vault_name      = "${var.azure_environment.name}-kv"
}

resource "azurerm_resource_group" "the_rg" {
  provider = azurerm

  name     = local.resource_group_name
  location = var.azure_environment.location
}
