resource "azurerm_resource_group" "myrg" {
  name     = "myrg1"
  location = "West Europe"
}

resource "azurerm_storage_account" "mystorageaccount999832" {
  name                     = "mystorageaccount999832"
  resource_group_name      = azurerm_resource_group.myrg.name
  location                 = azurerm_resource_group.myrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.mystorageaccount999832.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.mystorageaccount999832.name
  storage_container_name = azurerm_storage_container.data.name
  type                   = "Block"
  source                 = "main.tf"
}