locals {
  resource_group_name = "app-grp"
  resource_group_location = "West Europe"
  virtual_network={
    name = "app-network"
    address_space = "10.0.0.0/16"
 }
 subnets=[
    {
        name = "SubnetA"
        address_prefix = "10.0.1.0/24"
    },
    {
        name = "SubnetB"
        address_prefix = "10.0.2.0/24"
    }
 ]
}