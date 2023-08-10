# common vars #
variable "cdn_resource_group_name" {
  type        = string
  description = "Name of the resource group to create the CDN Front Door solution resources in."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of key value pairs that is used to tag resources created."
}

# DNS zone #
variable "create_dns_zone" {
  description = "Create a DNS zone for the CDN profile."
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
    ttl       = number
    tls = optional(list(object({
      certificate_type    = string
      minimum_tls_version = string
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
      zone_name = (Required) The name of the DNS zone to create the record in.
      host_name = (Required) The host name of the DNS record to create. (e.g. PrivateGPT)
      ttl       = (Optional) The TTL of the DNS record to create. (e.g. 3600)
      tls       = optional(list(object({
        certificate_type    = (Required) Defines the source of the SSL certificate. Possible values include 'CustomerCertificate' and 'ManagedCertificate'. Defaults to 'ManagedCertificate'.
        NOTE: It may take up to 15 minutes for the Front Door Service to validate the state and Domain ownership of the Custom Domain.
        minimum_tls_version = (Optional) TLS protocol version that will be used for Https. Possible values include TLS10 and TLS12. Defaults to TLS12.
      }))))
    })
  DESCRIPTION
}

# Front Door #
variable "cdn_profile_name" {
  description = "The name of the CDN profile."
  type        = string
  default     = "example-cdn-profile"
}

variable "cdn_sku_name" {
  description = "Specifies the SKU for the Front Door Profile. Possible values include 'Standard_AzureFrontDoor' and 'Premium_AzureFrontDoor'."
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "cdn_endpoint" {
  type = object({
    name    = string
    enabled = bool
  })
  default = {
    name    = "PrivateGPT"
    enabled = true
  }
  description = <<DESCRIPTION
    typp = object({
      name = (Required) The name of the CDN endpoint to create.
      enabled = (Required) Is the CDN endpoint enabled? Defaults to `true`.
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
  description = "PrivateGPT Origin details from Container App."
  type = object({
    name                           = string
    origin_group_name              = string
    enabled                        = bool
    certificate_name_check_enabled = bool
    host_name                      = string
    http_port                      = number
    https_port                     = number
    origin_host_header             = string
    priority                       = number
    weight                         = number
  })
  default = {
    name                           = "PrivateGPTOrigin"
    origin_group_name              = "PrivateGPTOriginGroup"
    enabled                        = true
    certificate_name_check_enabled = false
    host_name                      = "example.com"
    http_port                      = 80
    https_port                     = 443
    origin_host_header             = "example.com"
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