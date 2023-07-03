resource "azurerm_resource_group" "app-group" {
    name = "app-group"
    location = "West Europe" 
}

resource "azurerm_storage_account" "azuremmnorck007" {
  name                     = "azuremmnorck007"
  resource_group_name      = "app-group"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [ azurerm_resource_group.app-group ]
}

/* Count Meta Example
resource "azurerm_storage_container" "example" {
  count = 3
  name                  = "data${count.index}"
  storage_account_name  = azurerm_storage_account.azuremmnorck007.name
  container_access_type = "private"
  depends_on = [ azurerm_resource_group.app-group ]
}
 end here */

#For each meta example
resource "azurerm_storage_container" "data" {
  for_each = toset(["data","files","documents"])
  name                  = each.key
  storage_account_name  = azurerm_storage_account.azuremmnorck007.name
  container_access_type = "blob"
  depends_on = [ azurerm_resource_group.app-group ]
}

resource "azurerm_storage_blob" "files" {
  for_each = {
    sample1 = "C:\\tmp1\\sample1.txt"
    sample2 = "C:\\tmp2\\sample2.txt"
  }
  name                   = each.key
  storage_account_name   = "azuremmnorck007"
  storage_container_name = "data"
  type                   = "Block"
  source                 = each.value
  depends_on = [ azurerm_storage_account.azuremmnorck007 ]
}