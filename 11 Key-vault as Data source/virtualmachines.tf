resource "azurerm_network_interface" "appinterface" {
  count = var.number_of_machines
  name                = "app-interface${count.index}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip[count.index].id
  }
  depends_on = [azurerm_virtual_network.appnetwork, azurerm_subnet.subnets, azurerm_public_ip.appip]
}

#Pub-IP
resource "azurerm_public_ip" "appip" {
  count = var.number_of_machines
  name                = "app-ip${count.index}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.appgrp ]
}


#Linux VM

resource "azurerm_linux_virtual_machine" "Linuxvm" {
  count = var.number_of_machines
  name                = "Linux-vm${count.index}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.vmpassword.value
# availability_set_id = azurerm_availability_set.appset.id
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.appinterface[count.index].id
    
  ]
  depends_on = [ azurerm_resource_group.appgrp, azurerm_network_interface.appinterface ]

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

data "azurerm_key_vault" "keyvault0022e233" {
  name                = "keyvault0022e233"
  resource_group_name = "key-grp"
}

output "vault_uri" {
  value = data.azurerm_key_vault.keyvault0022e233.vault_uri
}

data "azurerm_key_vault_secret" "vmpassword" {
  name = "vmpassword"
  key_vault_id = data.azurerm_key_vault.keyvault0022e233.id
  depends_on = [ azurerm_resource_group.appgrp, data.azurerm_key_vault.keyvault0022e233 ]
}
