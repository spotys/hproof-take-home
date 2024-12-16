locals {
  application_name = "${var.azure_environment.name}-github"
}

resource "azuread_application" "application" {
  provider = azuread

  display_name = local.application_name
}

resource "azuread_service_principal" "service_principal" {
  provider = azuread

  client_id = azuread_application.application.client_id
}

resource "azuread_service_principal_password" "service_principal_password" {
  provider = azuread

  service_principal_id = azuread_service_principal.service_principal.id
}

resource "azurerm_role_assignment" "tf_sa_github_access" {
  principal_id         = azuread_service_principal.service_principal.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.azurerm_storage_account.tfstate_storage_account.id
}

resource "azurerm_role_assignment" "kv_github_access" {
  principal_id         = azuread_service_principal.service_principal.object_id
  role_definition_name = "Owner"
  scope                = azurerm_resource_group.the_rg.id
}

resource "azurerm_key_vault_access_policy" "sp_kv_access" {
  key_vault_id = azurerm_key_vault.the_kv.id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = azuread_service_principal.service_principal.object_id

  secret_permissions = [
    "Get", "List", "Set"
  ]
}

output "client_id" {
  value = azuread_service_principal.service_principal.client_id
}

output "client_secret" {
  value     = azuread_service_principal_password.service_principal_password.value
  sensitive = true
}
