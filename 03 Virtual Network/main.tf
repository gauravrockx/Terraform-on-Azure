resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "West Europe"
}

resource "azurerm_virtual_network" "appnetwork" {
  name                = "app-network"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]
  

  subnet {
    name           = local.subnets[0].name
    address_prefix = local.subnets[0].address_prefix
  }

  subnet {
    name           = local.subnets[1].name
    address_prefix = local.subnets[1].address_prefix
  }
  depends_on = [ azurerm_resource_group.appgrp ]


}