resource "azurerm_virtual_network" "appnetwork" {
  name                = "app-network"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]
  depends_on          = [azurerm_resource_group.appgrp]
}

resource "azurerm_subnet" "subnets" {
 # count = var.number_of_subnets
  name                 = "SubnetA"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on           = [azurerm_virtual_network.appnetwork]
}

#NSG
resource "azurerm_network_security_group" "appnsg" {
  name                = "app-nsg"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "Http"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_subnet_network_security_group_association" "appnsgassociation" {
 # count = var.number_of_subnets
  subnet_id                 = azurerm_subnet.subnets.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
  depends_on =[
    azurerm_network_security_group.appnsg,
    azurerm_subnet.subnets
  ]
}


