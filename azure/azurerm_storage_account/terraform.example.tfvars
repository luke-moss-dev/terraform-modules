resource_group_name = "Luke_RG"

# storage_account_config = {
#   name     = "tester1234556jfjdkf"
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }


## Another config example
storage_account_config = {
  name     = "test12345abcdefg"
  location = "southcentralus"

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  access_tier               = "Cool"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  allow_blob_public_access = false
  is_hns_enabled           = false
  nfsv3_enabled            = false
  large_file_share_enabled = true

  identity = [{
    type = "SystemAssigned"
  }]

  network_rules = [{
    default_action = "Deny"
    bypass         = ["Logging"]
  }]

  tags = {
    Environment = "Test"
    POC         = "Me"
  }

}