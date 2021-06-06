#################################################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#                                               #
#   Azure Virtual Network                       #
#       June 6, 2021  v0.0.1                    #
#                                               #
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#################################################

# commented; used only for testing
# provider "azurerm" {
#   features {}
# }

## Retrieve resource group information
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

## Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name = local.virtual_network_config.name
  resource_group_name = data.azurerm_resource_group.rg.name 
  location = local.virtual_network_config.location != "" ? local.virtual_network_config.location : data.azurerm_resource_group.rg.location  # Default to RG locale. 
  address_space = local.virtual_network_config.address_space
  dns_servers = local.virtual_network_config.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = local.virtual_network_config.ddos_protection_plan
    content {
      id = ddos_protection_plan.key 
      enable = ddos_protection_plan.value 
    }
  }

  tags = local.virtual_network_config.tags
}