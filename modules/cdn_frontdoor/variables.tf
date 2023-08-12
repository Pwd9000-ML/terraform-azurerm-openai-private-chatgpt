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
    zone_name = "mydomain7335.com"
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
  type = list(object({
    name                                                      = string
    session_affinity_enabled                                  = optional(bool, false)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 5)
    health_probe = optional(object({
      interval_in_seconds = optional(number, 100)
      path                = optional(string, "/")
      protocol            = optional(string, "Http")
      request_type        = optional(string, "HEAD")
    }))
    load_balancing = optional(object({
      additional_latency_in_milliseconds = optional(number, 50)
      sample_size                        = optional(number, 4)
      successful_samples_required        = optional(number, 3)
    }))
  }))
  default = [
    {
      name                                                      = "PrivateGPTOriginGroup"
      session_affinity_enabled                                  = false
      restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 5
      health_probe = {
        interval_in_seconds = 100
        path                = "/"
        protocol            = "Http"
        request_type        = "HEAD"
      }
      load_balancing = {
        additional_latency_in_milliseconds = 50
        sample_size                        = 4
        successful_samples_required        = 3
      }
    }
  ]
  description = <<-DESCRIPTION
    type = list(object({
      name                                                      = (Required) The name of the CDN origin group to create.
      session_affinity_enabled                                  = (Optional) Is session affinity enabled? Defaults to `false`.
      restore_traffic_time_to_healed_or_new_endpoint_in_minutes = (Optional) The time in minutes to restore traffic to a healed or new endpoint. Defaults to `5`.
      health_probe = (Optional) The health probe settings.
      type = object({
        interval_in_seconds = (Optional) The interval in seconds between health probes. Defaults to `100`.
        path                = (Optional) The path to use for health probes. Defaults to `/`.
        protocol            = (Optional) The protocol to use for health probes. Possible values include 'Http' and 'Https'. Defaults to `Http`.
        request_type        = (Optional) The request type to use for health probes. Possible values include 'GET', 'HEAD', and 'OPTIONS'. Defaults to `HEAD`.
      }))
      load_balancing = (Optional) The load balancing settings.
      type = object({
        additional_latency_in_milliseconds = (Optional) The additional latency in milliseconds for probes to fall into the lowest latency bucket. Defaults to `50`.
        sample_size                        = (Optional) The number of samples to take for load balancing decisions. Defaults to `4`.
        successful_samples_required        = (Optional) The number of samples within the sample period that must succeed. Defaults to `3`.
      }))
    }))
    DESCRIPTION
}

variable "cdn_gpt_origin" {
  type = object({
    name                           = string
    origin_group_name              = string
    enabled                        = optional(bool, true)
    certificate_name_check_enabled = optional(bool, true)
    host_name                      = string
    http_port                      = optional(number, 80)
    https_port                     = optional(number, 443)
    origin_host_header             = optional(string, "www.mysite.example.com")
    priority                       = optional(number, 1)
    weight                         = optional(number, 1000)
  })
  default = {
    name                           = "PrivateGPTOrigin"
    origin_group_name              = "PrivateGPTOriginGroup"
    enabled                        = true
    certificate_name_check_enabled = true
    host_name                      = "mysite.example.com"
    http_port                      = 80
    https_port                     = 443
    origin_host_header             = "www.mysite.example.com"
    priority                       = 1
    weight                         = 1000
  }
  description = <<-DESCRIPTION
    type = object({
      name                           = (Required) The name which should be used for this Front Door Origin. Changing this forces a new Front Door Origin to be created.
      origin_group_name              = (Required) The name of the CDN origin group to associate this origin with.
      enabled                        = (Optional) Is the CDN origin enabled? Defaults to `true`.
      certificate_name_check_enabled = (Required) Specifies whether certificate name checks are enabled for this origin. Defaults to `true`.
      host_name                      = (Required) The IPv4 address, IPv6 address or Domain name of the Origin. (e.g. mysite.example.com)
      http_port                      = (Optional) The HTTP port of the origin. (e.g. 80)
      https_port                     = (Optional) The HTTPS port of the origin. (e.g. 443)
      origin_host_header             = (Optional) The origin host header. (e.g. www.mysite.example.com)
      priority                       = (Optional) The priority of the origin. (e.g. 1)
      weight                         = (Optional) The weight of the origin. (e.g. 1000)
    })
  DESCRIPTION
}

variable "cdn_route" {
  type = object({
    name                       = string
    enabled                    = optional(bool, true)
    forwarding_protocol        = optional(string, "HttpsOnly")
    https_redirect_enabled     = optional(bool, false)
    patterns_to_match          = optional(list(string), ["/*"])
    supported_protocols        = optional(list(string), ["Http", "Https"])
    cdn_frontdoor_origin_path  = optional(string, null)
    cdn_frontdoor_rule_set_ids = optional(list(string), null)
    link_to_default_domain     = optional(bool, false)
    cache = optional(object({
      query_string_caching_behavior = string
      query_strings                 = optional(list(string), [])
      compression_enabled           = bool
      content_types_to_compress     = optional(list(string), [])
    }))
  })
  default = {
    name                       = "PrivateGPTRoute"
    enabled                    = true
    forwarding_protocol        = "HttpsOnly"
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
      enabled                        = (Optional) Is the CDN route enabled? Defaults to `true`.
      forwarding_protocol            = (Optional) The protocol this rule will use when forwarding traffic to backends. Possible values include `MatchRequest`, `HttpOnly` and `HttpsOnly`. Defaults to `HttpsOnly`.
      https_redirect_enabled         = (Optional) Is HTTPS redirect enabled? Defaults to `false`.
      patterns_to_match              = (Optional) The list of patterns to match for this rule. Defaults to `["/*"]`.
      supported_protocols            = (Optional) The list of supported protocols for this rule. Defaults to `["Http", "Https"]`.
      cdn_frontdoor_origin_path      = (Optional) The path to use when forwarding traffic to backends. Defaults to `null`.
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

variable "cdn_firewall_policies" {
  type = list(object({
    name                              = string
    enabled                           = optional(bool, true)
    mode                              = optional(string, "Prevention")
    redirect_url                      = optional(string)
    custom_block_response_status_code = optional(number, 403)
    custom_block_response_body        = optional(string)
    custom_rules = optional(list(object({
      name                           = string
      action                         = string
      enabled                        = optional(bool, true)
      priority                       = number
      type                           = string
      rate_limit_duration_in_minutes = optional(number, 1)
      rate_limit_threshold           = optional(number, 10)
      match_conditions = list(object({
        match_variable     = string
        match_values       = list(string)
        operator           = string
        selector           = optional(string)
        negation_condition = optional(bool)
        transforms         = optional(list(string))
      }))
    })))
  }))
  default = [{
    name                              = "PrivateGPTFirewallPolicy"
    enabled                           = true
    mode                              = "Prevention"
    redirect_url                      = null
    custom_block_response_status_code = 403
    custom_block_response_body        = "WW91ciByZXF1ZXN0IGhhcyBiZWVuIGJsb2NrZWQu"
    custom_rules = [
      {
        name                           = "PrivateGPTFirewallPolicyCustomRule"
        action                         = "Block"
        enabled                        = true
        priority                       = 100
        type                           = "MatchRule"
        rate_limit_duration_in_minutes = 1
        rate_limit_threshold           = 10
        match_conditions = [
          {
            match_variable     = "RemoteAddr"
            match_values       = ["10.0.1.0/24", "10.0.2.0/24"]
            operator           = "IPMatch"
            selector           = null
            negation_condition = null
            transforms         = []
          }
        ]
      }
    ]
  }]
  description = "The CDN firewall policies to create."
}

variable "cdn_security_policy" {
  type = object({
    link_waf             = bool
    name                 = string
    firewall_policy_name = string
    patterns_to_match    = list(string)
  })
  default = {
    link_waf             = true
    name                 = "PrivateGPTSecurityPolicy"
    firewall_policy_name = "PrivateGPTFirewallPolicy"
    patterns_to_match    = ["/*"]
  }
  description = <<-DESCRIPTION
    type = object({
      link_waf             = (Required) Link the created WAF to the security policy. `true` or `false`
      name                 = (Required) The name of the CDN security policy to create.
      firewall_policy_name = (Required) The name of the CDN firewall policy to associate with this security policy.
      patterns_to_match    = (Required) The list of patterns to match for this policy. Defaults to `["/*"]`.
    })
  DESCRIPTION
}