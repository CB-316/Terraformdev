terraform {
  backend "azurerm" {
    resource_group_name   = "CB-TerraformDev-RG"
    storage_account_name  = "cbterraformsa2"
    container_name        = "terraformstatedev"
    key                   = "terraform.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=1.44.0"
    }
  }
}

resource "azurerm_resource_group" "devrg" {
    name     = "CB-TerraformDev-RG" 
    location = "westeurope"

 tags = {
   "terraform" = "denmark"
 }

}

resource "azurerm_virtual_network" "tvnet" {
    name                = "terravnet"
    address_space       = [ "10.10.0.0/16" ]
    location            = "westeurope"
    
    resource_group_name = azurerm_resource_group.devrg.name

    subnet {
        name           = "Subnet1"
        address_prefix = "10.10.0.0/24"
    }

    tags = {
      "environment" = "dev"
    }
}

resource "azurerm_storage_account" "tsa" {
  name = "cbterraformsa2"
  account_replication_type = "LRS"
  location = azurerm_resource_group.devrg.location
  account_tier             = "Standard"

  resource_group_name = azurerm_resource_group.devrg.name
 
 }

resource "azurerm_storage_container" "tcon" {
  name                  = "terraformstatedev"
  storage_account_name  = azurerm_storage_account.tsa.name
  container_access_type = "private"
}

