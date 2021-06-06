resource_group_name  = "Luke_RG"

virtual_network_config = {
    name = "tester"
    address_space = ["10.50.0.0/16"]
    location = "westus"
}


## Old version would have required this:
resource_group_name  = "Luke_RG"

virtual_network_config = {
    name = "tester"
    address_space = ["10.50.0.0/16"]
    location = "westus"

    # Old config would have required being explicit here with null or empty values
    bgp_community = null or ""
    dns_servers = null or []
    ddos_protection_plan = null or {}
    tags = null or {}

}