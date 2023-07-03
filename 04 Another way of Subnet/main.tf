resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "West Europe"
}

resource "azurerm_virtual_network" "appnetwork" {
  name                = "app-network"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]
  depends_on          = [azurerm_resource_group.appgrp]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = local.subnets[0].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnets[0].address_prefix]
  depends_on           = [azurerm_virtual_network.appnetwork]
}

resource "azurerm_subnet" "SubnetB" {
  name                 = local.subnets[1].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnets[1].address_prefix]
  depends_on = [azurerm_virtual_network.appnetwork,
  azurerm_resource_group.appgrp]

}