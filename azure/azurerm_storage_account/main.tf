#################################################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#                                               #
#   Azure Storage Account                       #
#       Luke Mossburgh - SHI                    #
#           June 7, 2021  v0.0.1                #
#                                               #
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#################################################

#commented; used only for testing
provider "azurerm" {
  features {}
}

## Retrieve resource group information
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

## Storage Account
resource "azurerm_storage_account" "sa" {
  name                = local.storage_account_config.name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = local.storage_account_config.location != "" ? local.storage_account_config.location : data.azurerm_resource_group.rg.location # Default to RG locale. 

  account_kind             = local.storage_account_config.account_kind
  account_tier             = local.storage_account_config.account_tier
  account_replication_type = local.storage_account_config.account_replication_type
  access_tier              = local.storage_account_config.access_tier

  enable_https_traffic_only = local.storage_account_config.enable_https_traffic_only
  min_tls_version           = local.storage_account_config.min_tls_version
  allow_blob_public_access  = local.storage_account_config.allow_blob_public_access
  is_hns_enabled            = local.storage_account_config.is_hns_enabled
  nfsv3_enabled             = local.storage_account_config.nfsv3_enabled

  large_file_share_enabled = local.storage_account_config.large_file_share_enabled

  dynamic "custom_domain" {
    for_each = local.storage_account_config.custom_domain
    content {
      name          = custom_domain.value["name"]
      use_subdomain = custom_domain.value["use_subdomain"]
    }
  }

  dynamic "identity" {
    for_each = local.storage_account_config.identity
    content {
      type = identity.value["type"]
    }
  }

  dynamic "blob_properties" {
    for_each = local.storage_account_config.blob_properties
    content {
      dynamic "cors_rule" {
        for_each = blob_properties.value["cors_rule"]
        content {
          allowed_headers    = cors_rule.value["allowed_headers"]
          allowed_methods    = cors_rule.value["allowed_methods"]
          allowed_origins    = cors_rule.value["allowed_origins"]
          exposed_headers    = cors_rule.value["exposed_headers"]
          max_age_in_seconds = cors_rule.value["max_age_in_seconds"]
        }
      }

      dynamic "delete_retention_policy" {
        for_each = blob_properties.value["delete_retention_policy"]
        content {
          days = delete_retention_policy.value["days"]
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value["container_delete_retention_policy"]
        content {
          days = container_delete_retention_policy.value["days"]
        }
      }

      versioning_enabled       = blob_properties.value["versioning_enabled"]
      change_feed_enabled      = blob_properties.value["change_feed_enabled"]
      default_service_version  = blob_properties.value["default_service_version"]
      last_access_time_enabled = blob_properties.value["last_access_time_enabled"]
    }
  }

  dynamic "queue_properties" {
    for_each = local.storage_account_config.queue_properties
    content {
      dynamic "cors_rule" {
        for_each = queue_properties.value["cors_rule"]
        content {
          allowed_headers    = cors_rule.value["allowed_headers"]
          allowed_methods    = cors_rule.value["allowed_methods"]
          allowed_origins    = cors_rule.value["allowed_origins"]
          exposed_headers    = cors_rule.value["exposed_headers"]
          max_age_in_seconds = cors_rule.value["max_age_in_seconds"]
        }
      }

      dynamic "logging" {
        for_each = queue_properties.value["logging"]
        content {
          delete                = logging.value["delete"]
          read                  = logging.value["read"]
          version               = logging.value["version"]
          write                 = logging.value["write"]
          retention_policy_days = logging.value["retention_policy_days"]
        }
      }

      dynamic "minute_metrics" {
        for_each = queue_properties.value["minute_metrics"]
        content {
          enabled               = minute_metrics.value["enabled"]
          version               = minute_metrics.value["version"]
          include_apis          = minute_metrics.value["include_apis"]
          retention_policy_days = minute_metrics.value["retention_policy_days"]
        }
      }

      dynamic "hour_metrics" {
        for_each = queue_properties.value["hour_metrics"]
        content {
          enabled               = hour_metrics.value["enabled"]
          version               = hour_metrics.value["version"]
          include_apis          = hour_metrics.value["include_apis"]
          retention_policy_days = hour_metrics.value["retention_policy_days"]
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = local.storage_account_config.static_website
    content {
      index_document     = static_website.value["index_document"]
      error_404_document = static_website.value["error_404_document"]
    }
  }

  dynamic "network_rules" {
    for_each = local.storage_account_config.network_rules
    content {
      default_action             = network_rules.value["default_action"]
      bypass                     = network_rules.value["bypass"]
      ip_rules                   = network_rules.value["ip_rules"]
      virtual_network_subnet_ids = network_rules.value["virtual_network_subnet_ids"]

      dynamic "private_link_access" {
        for_each = network_rules.value["private_link_access"]
        content {
          endpoint_resource_id = private_link_access.value["endpoint_resource_id"]
          endpoint_tenant_id   = private_link_access.value["endpoint_tenant_id"]
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = local.storage_account_config.azure_files_authentication
    content {
      directory_type = azure_files_authentication.value["directory_type"]

      dynamic "active_directory" {
        for_each = azure_files_authentication.value["active_directory"]
        content {
          storage_sid         = active_directory.value["storage_sid"]
          domain_name         = active_directory.value["domain_name"]
          domain_sid          = active_directory.value["domain_sid"]
          domain_guid         = active_directory.value["domain_guid"]
          forest_name         = active_directory.value["forest_name"]
          netbios_domain_name = active_directory.value["netbios_domain_name"]
        }
      }
    }
  }

  dynamic "routing" {
    for_each = local.storage_account_config.routing
    content {
      publish_internet_endpoints  = routing.value["publish_internet_endpoints"]
      publish_microsoft_endpoints = routing.value["publish_microsoft_endpoints"]
      choice                      = routing.value["choice"]
    }
  }

  tags = local.storage_account_config.tags
}
