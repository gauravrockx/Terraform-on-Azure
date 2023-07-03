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

resource "azurerm_network_interface" "appinterface" {
  name                = "app-interface"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip.id
  }
}

resource "azurerm_public_ip" "appip" {
  name                = "app-ip"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.appgrp ]
}

output "SubnetA-value" {
  value = azurerm_subnet.SubnetA.id
}

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
  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_subnet_network_security_group_association" "appnsgassociation" {
  subnet_id                 = azurerm_subnet.SubnetA.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
}

resource "azurerm_linux_virtual_machine" "Linuxvm" {
  name                = "Linux-vm"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "Azure@007"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.appinterface.id
    
  ]
  depends_on = [ azurerm_resource_group.appgrp ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

