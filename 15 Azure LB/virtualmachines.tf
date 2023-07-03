resource "azurerm_network_interface" "appinterface" {
  count = var.number_of_machines
  name                = "app-interface${count.index}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets.id
    private_ip_address_allocation = "Dynamic"
   # public_ip_address_id = azurerm_public_ip.appip[count.index].id
  }
  depends_on = [azurerm_virtual_network.appnetwork, azurerm_subnet.subnets]
}
/*
#Pub-IP
resource "azurerm_public_ip" "appip" {
  count = var.number_of_machines
  name                = "app-ip${count.index}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  allocation_method   = "Static"
  sku = "Standard"
#  zones = ["${count.index+1}"]
  depends_on = [ azurerm_resource_group.appgrp ]
}
*/


#Linux VM

data "template_file" "cloudinitdata" {
  template = file("script.sh")
}

resource "azurerm_linux_virtual_machine" "Linuxvm" {
  count = var.number_of_machines
  name                = "Linux-vm${count.index}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "Azure@007"
availability_set_id = azurerm_availability_set.appset.id
#  zone = (count.index+1)
custom_data = base64encode(data.template_file.cloudinitdata.rendered)
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