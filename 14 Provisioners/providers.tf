terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.10.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
#  subscription_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#  tenant_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#  client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
#  client_secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  features {}
}
  