#Public IP for LB
resource "azurerm_public_ip" "loadip" {
  name                = "load-ip"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku = "Standard"
  depends_on = [ azurerm_resource_group.appgrp ]
}

#Azure LB
resource "azurerm_lb" "appbalancer" {
  name                = "appbalancer"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  sku = "Standard"
  sku_tier = "Regional"

  frontend_ip_configuration {
    name                 = "frontendip"
    public_ip_address_id = azurerm_public_ip.loadip.id
  }
  depends_on = [ azurerm_public_ip.loadip ]
}

#LB Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backendpool" {
  loadbalancer_id = azurerm_lb.appbalancer.id
  name            = "backendpool"
  depends_on = [ azurerm_lb.appbalancer ]
}

#Add Azure VMs on Backend address pool
resource "azurerm_lb_backend_address_pool_address" "backendVM" {
  count = var.number_of_machines
  name                                = "Linux-vm${count.index}"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.backendpool.id
  virtual_network_id                  = azurerm_virtual_network.appnetwork.id
  ip_address                          = azurerm_network_interface.appinterface[count.index].private_ip_address
  depends_on = [ azurerm_lb_backend_address_pool.backendpool, azurerm_network_interface.appinterface ]
  }

#Health Probe for backend pool instances
  resource "azurerm_lb_probe" "probeA" {
  loadbalancer_id = azurerm_lb.appbalancer.id
  name            = "probeA"
  port            = 80
  protocol = "Tcp"
  depends_on = [ azurerm_lb_backend_address_pool.backendpool ]
}

#LB rule to send traffic on backend pool bases on IP address and Port no.
resource "azurerm_lb_rule" "RuleA" {
  loadbalancer_id                = azurerm_lb.appbalancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontendip"
  probe_id = azurerm_lb_probe.probeA.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backendpool.id]
}