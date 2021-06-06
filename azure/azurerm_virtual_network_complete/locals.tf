## Here I declare any and all defaults wanted for any provider required values that are optional in the object variable
## This also fills the object with empty types, rather than null values
## For example, ddos_protection_plan is now [] rather than `null`, which is important/required for for_each loop.
locals {
  virtual_network_config = defaults(var.virtual_network_config, {
    location = ""   # This will help to default the location of vnet to RG locale, cannot supply dynamic value here from data.azurerm_resource_group
  })
}