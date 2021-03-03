terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=1.44.0"
    }
  }
}

resource "azurerm_resource_group" "devrg" {
    location = "westeurope"
    name = "Devresgrp"  
}

resource "azurerm_virtual_network" "tvnet" {
    address_space = [ "10.10.0.0/16" ]
    location = "westeurope"
    name = "terravnet"
    resource_group_name = azurerm_resource_group.devrg.name

    subnet {
        name = "Subnet1"
        address_prefix = "10.10.0.0/24"
    }

    tags = {
      "environment" = "dev"
    }
}

