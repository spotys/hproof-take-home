data "azurerm_client_config" "this" {}

data "azurerm_storage_account" "tfstate_storage_account" {
  resource_group_name = "terraform-shared-rg"
  name                = "terraformsharedsa"
}
