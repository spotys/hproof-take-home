resource "azurerm_key_vault" "the_kv" {
  provider = azurerm

  name                       = local.key_vault_name
  location                   = azurerm_resource_group.the_rg.location
  resource_group_name        = azurerm_resource_group.the_rg.name
  tenant_id                  = data.azurerm_client_config.this.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

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
