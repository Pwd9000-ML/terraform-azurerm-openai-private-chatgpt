### common ###
variable "location" {
  type        = string
  default     = "uksouth"
  description = "Azure region where resources will be hosted."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of key value pairs that is used to tag resources created."
}

### solution resource group ###
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create where the cognitive account OpenAI service is hosted."
  nullable    = false
}

### OpenAI service Module params ###
### key vault ###
variable "kv_config" {
  type = object({
    name = string
    sku  = string
  })
  default = {
    name = "openaikv9000"
    sku  = "standard"
  }
  description = "Key Vault configuration object to create azure key vault to store openai account details."
  nullable    = false
}

variable "keyvault_firewall_default_action" {
  type        = string
  default     = "Deny"
  description = "Default action for keyvault firewall rules."
}

variable "keyvault_firewall_bypass" {
  type        = string
  default     = "AzureServices"
  description = "List of keyvault firewall rules to bypass."
}

variable "keyvault_firewall_allowed_ips" {
  type        = list(string)
  default     = []
  description = "value of keyvault firewall allowed ip rules."
}

variable "keyvault_firewall_virtual_network_subnet_ids" {
  type        = list(string)
  default     = []
  description = "value of keyvault firewall allowed virtual network subnet ids."
}

### openai service ###
variable "create_openai_service" {
  type        = bool
  description = "Create the OpenAI service."
  default     = false
}

variable "openai_account_name" {
  type        = string
  description = "Name of the OpenAI service."
  default     = "demo-account"
}

variable "openai_custom_subdomain_name" {
  type        = string
  description = "The subdomain name used for token-based authentication. Changing this forces a new resource to be created. (normally the same as the account name)"
  default     = "demo-account"
}

variable "openai_sku_name" {
  type        = string
  description = "SKU name of the OpenAI service."
  default     = "S0"
}

variable "openai_local_auth_enabled" {
  type        = bool
  default     = true
  description = "Whether local authentication methods is enabled for the Cognitive Account. Defaults to `true`."
}

variable "openai_outbound_network_access_restricted" {
  type        = bool
  default     = false
  description = "Whether or not outbound network access is restricted. Defaults to `false`."
}

variable "openai_public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether or not public network access is enabled. Defaults to `false`."
}

variable "openai_identity" {
  type = object({
    type = string
  })
  default = {
    type = "SystemAssigned"
  }
  description = <<-DESCRIPTION
    type = object({
      type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
      identity_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.
    })
  DESCRIPTION
}

### model deployment ###
variable "create_model_deployment" {
  type        = bool
  description = "Create the model deployment."
  default     = false
}

variable "model_deployment" {
  type = list(object({
    deployment_id   = string
    model_name      = string
    model_format    = string
    model_version   = string
    scale_type      = string
    scale_tier      = optional(string)
    scale_size      = optional(number)
    scale_family    = optional(string)
    scale_capacity  = optional(number)
    rai_policy_name = optional(string)
  }))
  default     = []
  description = <<-DESCRIPTION
      type = list(object({
        deployment_id   = (Required) The name of the Cognitive Services Account `Model Deployment`. Changing this forces a new resource to be created.
        model_name = {
          model_format  = (Required) The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is OpenAI.
          model_name    = (Required) The name of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created.
          model_version = (Required) The version of Cognitive Services Account Deployment model.
        }
        scale = {
          scale_type     = (Required) Deployment scale type. Possible value is Standard. Changing this forces a new resource to be created.
          scale_tier     = (Optional) Possible values are Free, Basic, Standard, Premium, Enterprise. Changing this forces a new resource to be created.
          scale_size     = (Optional) The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. Changing this forces a new resource to be created.
          scale_family   = (Optional) If the service has different generations of hardware, for the same SKU, then that can be captured here. Changing this forces a new resource to be created.
          scale_capacity = (Optional) Tokens-per-Minute (TPM). If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. Default value is 1. Changing this forces a new resource to be created.
        }
        rai_policy_name = (Optional) The name of RAI policy. Changing this forces a new resource to be created.
      }))
  DESCRIPTION
  nullable    = false
}

### log analytics workspace ###
variable "laws_name" {
  type        = string
  description = "Name of the log analytics workspace to create."
  default     = "chatgpt-laws"
}

variable "laws_sku" {
  type        = string
  description = "SKU of the log analytics workspace to create."
  default     = "PerGB2018"
}

variable "laws_retention_in_days" {
  type        = number
  description = "Retention in days of the log analytics workspace to create."
  default     = 30
}

### container app environment ###
variable "cae_name" {
  type        = string
  description = "Name of the container app environment to create."
  default     = "chatgpt-cae"
}

### container app ###
variable "ca_name" {
  type        = string
  description = "Name of the container app to create."
  default     = "chatgpt-ca"
}

variable "ca_revision_mode" {
  type        = string
  description = "Revision mode of the container app to create."
  default     = "Single"
}

variable "ca_identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default     = null
  description = <<-DESCRIPTION
    type = object({
      type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
      identity_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.
    })
  DESCRIPTION
}

variable "ca_ingress" {
  type = object({
    allow_insecure_connections = optional(bool)
    external_enabled           = optional(bool)
    target_port                = number
    transport                  = optional(string)
    traffic_weight = optional(object({
      percentage      = number
      latest_revision = optional(bool)
    }))
  })
  default = {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 3000
    transport                  = "auto"
    traffic_weight = {
      percentage      = 100
      latest_revision = true
    }
  }
  description = <<-DESCRIPTION
    type = object({
      allow_insecure_connections = (Optional) Allow insecure connections to the container app. Defaults to `false`.
      external_enabled           = (Optional) Enable external access to the container app. Defaults to `true`.
      target_port                = (Required) The port to use for the container app. Defaults to `3000`.
      transport                  = (Optional) The transport protocol to use for the container app. Defaults to `auto`.
      type = object({
        percentage      = (Required) The percentage of traffic to route to the container app. Defaults to `100`.
        latest_revision = (Optional) The percentage of traffic to route to the container app. Defaults to `true`.
      })
  DESCRIPTION
}

variable "ca_container_config" {
  type = object({
    name         = string
    image        = string
    cpu          = number
    memory       = string
    min_replicas = optional(number, 1)
    max_replicas = optional(number, 10)
    env = optional(list(object({
      name        = string
      secret_name = optional(string)
      value       = optional(string)
    })))
  })
  default = {
    name         = "gpt-chatbot-ui"
    image        = "ghcr.io/pwd9000-ml/chatbot-ui:main"
    cpu          = 1
    memory       = "2Gi"
    min_replicas = 1
    max_replicas = 10
    env          = []
  }
  description = <<-DESCRIPTION
    type = object({
      name                    = (Required) The name of the container.
      image                   = (Required) The name of the container image.
      cpu                     = (Required) The number of CPU cores to allocate to the container.
      memory                  = (Required) The amount of memory to allocate to the container in GB.
      env = list(object({
        name        = (Required) The name of the environment variable.
        secret_name = (Optional) The name of the secret to use for the environment variable.
        value       = (Optional) The value of the environment variable.
      }))
    })
  DESCRIPTION
}

variable "ca_secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "secret1"
      value = "value1"
    },
    {
      name  = "secret2"
      value = "value2"
    }
  ]
  description = <<-DESCRIPTION
    type = list(object({
      name  = (Required) The name of the secret.
      value = (Required) The value of the secret.
    }))
  DESCRIPTION  
}

# DNS zone #
variable "create_dns_zone" {
  description = "Create a DNS zone for the CDN profile. If set to false, an existing DNS zone must be provided."
  type        = bool
  default     = false
}

variable "dns_resource_group_name" {
  description = "The name of the resource group to create the DNS zone in / or where the existing zone is hosted."
  type        = string
  nullable    = false
}

variable "custom_domain_config" {
  type = object({
    zone_name = string
    host_name = string
    ttl       = optional(number, 3600)
    tls = optional(list(object({
      certificate_type    = optional(string, "ManagedCertificate")
      minimum_tls_version = optional(string, "TLS12")
    })))
  })
  default = {
    zone_name = "gpt9000.com"
    host_name = "PrivateGPT"
    ttl       = 3600
    tls = [{
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }]
  }
  description = <<-DESCRIPTION
    type = object({
      zone_name = (Required) The name of the DNS zone to create the CNAME and TXT record in for the CDN Front Door Custom domain.
      host_name = (Required) The host name of the DNS record to create. (e.g. Contoso)
      ttl       = (Optional) The TTL of the DNS record to create. (e.g. 3600)
      tls       = optional(list(object({
        certificate_type    = (Optional) Defines the source of the SSL certificate. Possible values include 'CustomerCertificate' and 'ManagedCertificate'. Defaults to 'ManagedCertificate'.
        NOTE: It may take up to 15 minutes for the Front Door Service to validate the state and Domain ownership of the Custom Domain.
        minimum_tls_version = (Optional) TLS protocol version that will be used for Https. Possible values include TLS10 and TLS12. Defaults to TLS12.
      }))))
    })
  DESCRIPTION
}

# Front Door #
variable "create_front_door_cdn" {
  description = "Create a Front Door profile."
  type        = bool
  default     = false
}

variable "cdn_profile_name" {
  description = "The name of the CDN profile to create."
  type        = string
  default     = "example-cdn-profile"
}

variable "cdn_sku_name" {
  description = "Specifies the SKU for the CDN Front Door Profile. Possible values include 'Standard_AzureFrontDoor' and 'Premium_AzureFrontDoor'."
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "cdn_endpoint" {
  type = object({
    name    = string
    enabled = optional(bool, true)
  })
  default = {
    name    = "PrivateGPT"
    enabled = true
  }
  description = <<DESCRIPTION
    typp = object({
      name    = (Required) The name of the CDN endpoint to create.
      enabled = (Optional) Is the CDN endpoint enabled? Defaults to `true`.
    })
  DESCRIPTION
}

variable "cdn_origin_groups" {
  description = "A map of CDN origin groups to create."
  type = list(object({
    name                                                      = string
    session_affinity_enabled                                  = bool
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = number
    health_probe = object({
      interval_in_seconds = number
      path                = string
      protocol            = string
      request_type        = string
    })
    load_balancing = object({
      additional_latency_in_milliseconds = number
      sample_size                        = number
      successful_samples_required        = number
    })
  }))
  default = [
    {
      name                                                      = "PrivateGPTOriginGroup"
      session_affinity_enabled                                  = false
      restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 5
      health_probe = {
        interval_in_seconds = 30
        path                = "/"
        protocol            = "Http"
        request_type        = "GET"
      }
      load_balancing = {
        additional_latency_in_milliseconds = 0
        sample_size                        = 4
        successful_samples_required        = 2
      }
    }
  ]
}

variable "cdn_gpt_origin" {
  description = "A map of CDN origins to create."
  type = object({
    name                           = string
    origin_group_name              = string
    enabled                        = bool
    certificate_name_check_enabled = bool
    http_port                      = number
    https_port                     = number
    priority                       = number
    weight                         = number
  })
  default = {
    name                           = "PrivateGPTOrigin"
    origin_group_name              = "PrivateGPTOriginGroup"
    enabled                        = true
    certificate_name_check_enabled = false
    http_port                      = 80
    https_port                     = 443
    priority                       = 1
    weight                         = 1000
  }
}

variable "cdn_route" {
  type = object({
    name                       = string
    enabled                    = bool
    forwarding_protocol        = string
    https_redirect_enabled     = bool
    patterns_to_match          = list(string)
    supported_protocols        = list(string)
    cdn_frontdoor_origin_path  = optional(string)
    cdn_frontdoor_rule_set_ids = optional(list(string))
    link_to_default_domain     = bool
    cache = object({
      query_string_caching_behavior = string
      query_strings                 = list(string)
      compression_enabled           = bool
      content_types_to_compress     = list(string)
    })
  })
  default = {
    name                       = "PrivateGPTRoute"
    enabled                    = true
    forwarding_protocol        = "MatchRequest"
    https_redirect_enabled     = false
    patterns_to_match          = ["/*"]
    supported_protocols        = ["Http", "Https"]
    cdn_frontdoor_origin_path  = null
    cdn_frontdoor_rule_set_ids = null
    link_to_default_domain     = false
    cache = {
      query_string_caching_behavior = "IgnoreQueryString"
      query_strings                 = []
      compression_enabled           = false
      content_types_to_compress     = []
    }
  }
  description = <<-DESCRIPTION
    type = object({
      name                           = (Required) The name of the CDN route to create.
      enabled                        = (Required) Is the CDN route enabled? Defaults to `true`.
      forwarding_protocol            = (Required) The protocol this rule will use when forwarding traffic to backends. Possible values include 'MatchRequest', 'HttpOnly' and 'HttpsOnly'. Defaults to 'MatchRequest'.
      https_redirect_enabled         = (Required) Is HTTPS redirect enabled? Defaults to `false`.
      patterns_to_match              = (Required) The list of patterns to match for this rule. Defaults to `["/"]`.
      supported_protocols            = (Required) The list of supported protocols for this rule. Defaults to `["Http", "Https"]`.
      cdn_frontdoor_origin_path      = (Required) The path to use when forwarding traffic to backends. Defaults to `/`.
      cdn_frontdoor_rule_set_ids     = (Optional) The list of rule set IDs to associate with this rule. Defaults to `null`.
      link_to_default_domain         = (Optional) Is the CDN route linked to the default domain? Defaults to `false`.
      cache = (Optional) The CDN route cache settings.
      type = object({
        query_string_caching_behavior = (Required) The query string caching behavior. Possible values include 'IgnoreQueryString', 'BypassCaching', 'UseQueryString', and 'NotSet'. Defaults to 'IgnoreQueryString'.
        query_strings                 = (Optional) The list of query strings to include or exclude from caching. Defaults to `[]`.
        compression_enabled           = (Required) Is compression enabled? Defaults to `false`.
        content_types_to_compress     = (Optional) The list of content types to compress. Defaults to `[]`.
      })
    })
  DESCRIPTION
}