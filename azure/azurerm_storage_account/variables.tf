variable "resource_group_name" {
  description = "(Required) The name of the resource group to be retrieved."
  type        = string
}

variable "storage_account_config" {
  description = "A holistic view of the configs to be used during creation of the resource."

  type = object({
    name     = string           # (Required) Specifies the name of the storage account. Must be unique globally across Azure service.
    location = optional(string) # The location/region where the storage account is created, by default will apply to RG location.

    account_kind             = optional(string) # Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2.
    account_tier             = string           # (Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid.
    account_replication_type = string           # (Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.

    access_tier               = optional(string) # Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot.
    enable_https_traffic_only = optional(bool)   # Boolean flag which forces HTTPS if enabled, see below for more information. Defaults to true.
    #   https://docs.microsoft.com/en-us/azure/storage/common/storage-require-secure-transfer

    min_tls_version          = optional(string) # The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_0 for new storage accounts.
    allow_blob_public_access = optional(bool)   # Allow or disallow public access to all blobs or containers in the storage account. Defaults to false.
    is_hns_enabled           = optional(bool)   # Is Hierarchical Namespace enabled? This can only be true when account_tier==Standard or (account_tier==Premium && account_kind==BlockBlobStorage)
    nfsv3_enabled            = optional(bool)   # Is NFSv3 protocol enabled? Defaults to false. This can only be true when ((account_tier==Standard && account_kind==StorageV2) or (account_tier==Premium && account_kind==BlockBlobStorage) && (is_hns_enabled==true && enable_https_traffic_only==false))
    large_file_share_enabled = optional(bool)   # Is Large File Share enabled?

    custom_domain = optional(list(object({
      name          = string         # The Custom Domain Name to use for Storage Account
      use_subdomain = optional(bool) # Should the Custom Domain Name be validated using indirect CNAME validation?
    })))

    identity = optional(list(object({
      type = string # Specifies the identity type of the Storage Account. At this time the only allowed value is `SystemAssigned`
    })))

    blob_properties = optional(list(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string) # A list of headers that are allowed to be a part of the cross-origin request.
        allowed_methods    = list(string) #  A list of http headers that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
        allowed_origins    = list(string) # A list of origin domains that will be allowed by CORS.
        exposed_headers    = list(string) # A list of response headers that are exposed to CORS clients.
        max_age_in_seconds = number       # The number of seconds the client should cache the preflight response.
      })))

      delete_retention_policy = optional(list(object({
        days = optional(number) # Specifies the number of days that the blob should be retained between 1 and 365. Defaults to 7.
      })))

      versioning_enabled       = optional(bool)   # Is versioning enabled? Defaults to false.
      change_feed_enabled      = optional(bool)   # Is the blob service properties for change feed events enabled? Defaults to false.
      default_service_version  = optional(string) # The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version. Defaults to 2020-06-12.
      last_access_time_enabled = optional(bool)   # Is the last access time based tracking enabled? Defaults to false.

      container_delete_retention_policy = optional(list(object({
        days = optional(number) # Specifies the number of days that the blob should be retained between 1 and 365. Defaults to 7.
      })))
    })))

    queue_properties = optional(list(object({ # Cannot be set when access_tier==BlobStorage
      cors_rule = optional(list(object({
        allowed_headers    = list(string) # A list of headers that are allowed to be a part of the cross-origin request.
        allowed_methods    = list(string) #  A list of http headers that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
        allowed_origins    = list(string) # A list of origin domains that will be allowed by CORS.
        exposed_headers    = list(string) # A list of response headers that are exposed to CORS clients.
        max_age_in_seconds = number       # The number of seconds the client should cache the preflight response.
      })))

      logging = optional(list(object({
        delete                = bool             # Indicates whether all delete requests should be logged.
        read                  = bool             # Indicates whether all read requests should be logged.
        version               = string           # The version of storage analytics to configure.
        write                 = bool             # Indicates whether all write requests should be logged.
        retention_policy_days = optional(number) # Specifies the number of days that logs will be retained.
      })))

      minute_metrics = optional(list(object({
        enabled               = bool             # Indicates whether minute metrics are enabled for the Queue service.
        version               = string           # The version of storage analytics to configure.
        include_apis          = optional(bool)   # Indicates whether metrics should generate summary statistics for called API operations.
        retention_policy_days = optional(number) # Specifies the number of days that logs will be retained.
      })))

      hour_metrics = optional(list(object({
        enabled               = bool             # Indicates whether hour metrics are enabled for the Queue service.
        version               = string           # The version of storage analytics to configure.
        include_apis          = optional(bool)   # Indicates whether metrics should generate summary statistics for called API operations.
        retention_policy_days = optional(number) # Specifies the number of days that logs will be retained.
      })))
    })))

    static_website = optional(list(object({ # Can ONLY be set when account_kind==StorageV2 or account_kind==BlockBlobStorage
      index_document     = optional(string) # The webpage that Azure Storage serves for requests to root of a website. Example, "index.html"; value is case-sensitive.
      error_404_document = optional(string) # The absolute path to a custom webpage that should be used when request made does not correspond to existing file.
    })))

    network_rules = optional(list(object({                # If specifying network_rules, one of either ip_rules or virtual_network_subnet_ids must be specified and default_action must be set to Deny.
      default_action             = string                 # Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow.
      bypass                     = optional(list(string)) # Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.
      ip_rules                   = optional(list(string)) # List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed.
      virtual_network_subnet_ids = optional(list(string)) # A list of resource ids for subnets.
      private_link_access = optional(list(object({
        endpoint_resource_id = string # The resource id of the resource access rule to be granted access
        endpoint_tenant_id   = string # The tenant id of the resource of the resource access rule to be granted access.  Defaults to current tenant id.
      })))
    })))

    azure_files_authentication = optional(list(object({
      directory_type = string                   # Specifies the directory service used. Possible values are AADDS and AD.
      active_directory = optional(list(object({ # Required when directory_type is `AD`
        storage_sid         = string            # Specifies the security identifier (SID) for Azure Storage.
        domain_name         = string            # Specifies the primary domain that the AD DNS server is authoritative for.
        domain_sid          = string            # Specifies the security identifier (SID).
        domain_guid         = string            # Specifies the domain GUID.
        forest_name         = string            # Specifies the Active Directory forest.
        netbios_domain_name = string            # Specifies the NetBIOS domain name.
      })))
    })))

    routing = optional(list(object({
      publish_internet_endpoints  = optional(bool)   # Should internet routing storage endpoints be published? Defaults to false.
      publish_microsoft_endpoints = optional(bool)   # Should microsoft routing storage endpoints be published? Defaults to false.
      choice                      = optional(string) # Specifies the kind of network routing opted by the user. Possible values are InternetRouting and MicrosoftRouting. Defaults to MicrosoftRouting.
    })))

    tags = optional(map(string)) # Map of key/value pairs to assign tags to this resource. 

  })
}