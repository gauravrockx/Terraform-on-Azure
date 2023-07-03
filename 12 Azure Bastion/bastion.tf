resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.10.0/27"]
  depends_on           = [azurerm_virtual_network.appnetwork]
}

resource "azurerm_public_ip" "bastionip" {
  name                = "bastionip"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_bastion_host" "appbastion" {
  name                = "app-bastion"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  depends_on = [ azurerm_resource_group.appgrp ]
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.bastionip.id
    
  }
}