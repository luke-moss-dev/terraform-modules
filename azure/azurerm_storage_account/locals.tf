## Here I declare the defaults for any provider required values that are optional in the object variable
locals {
  storage_account_config = defaults(var.storage_account_config, {
    location                 = "" # This will help to default the location of storage account to RG locale, cannot supply dynamic value here from data.azurerm_resource_group
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    min_tls_version          = "TLS1_0"
    allow_blob_public_access = false
    nfsv3_enabled            = false

    network_rules = {
      private_link_access = {}
    }
  })
}