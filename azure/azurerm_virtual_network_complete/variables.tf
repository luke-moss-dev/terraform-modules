## NOTE: Subnets can be declared inline within the virtual network resource, however the options are more limited. We will create them separately.

# Defaults for the config variable will be declared in locals.tf
variable "virtual_network_config" {
  description = "A holistic view of the configs to be used during creation of the resource."

  type = object({
    name          = string           # (Required) The name of the virtual network. 
    address_space = list(string)     # (Required) The address space that is used the virtual network. You can supply more than one address space.
    location      = optional(string) # The location/region where the virtual network is created, by default will apply to RG location.
    bgp_community = optional(string) # The BGP community attribute in format <as-number>:<community-value>.

    ddos_protection_plan = optional(list(object({
      id     = string # (Required if declared) The ID of DDoS Protection Plan.
      enable = bool   # (Required if declared) Enable/disable DDoS Protection Plan on Virtual Network.
    })))

    dns_servers = optional(list(string)) # List of IP addresses of DNS servers.

    tags = optional(map(string)) # Map of key/value pairs to assign tags to this resource.
  })
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group to be retrieved."
  type        = string
}