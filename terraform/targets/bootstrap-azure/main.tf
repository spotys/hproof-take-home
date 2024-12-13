resource "azurerm_resource_group" "the_rg" {
  provider = azurerm

  name     = "${var.azure.project_name}-rg"
  location = var.azure.location
}

resource "azurerm_storage_account" "the_sa" {
  name                     = "${replace(var.azure.project_name, "-", "")}sa"
  resource_group_name      = azurerm_resource_group.the_rg.name
  location                 = azurerm_resource_group.the_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.azure.tags
}

resource "azurerm_storage_container" "tfstate-container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.the_sa.id
  container_access_type = "private"
}
