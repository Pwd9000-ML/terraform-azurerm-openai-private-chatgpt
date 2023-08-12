#Create Custom DNS zone or use existing
resource "azurerm_dns_zone" "gpt" {
  count               = var.create_dns_zone ? 1 : 0
  name                = var.custom_domain_config.zone_name
  resource_group_name = var.dns_resource_group_name
  tags                = var.tags
}

#Create CDN profile
resource "azurerm_cdn_frontdoor_profile" "gpt" {
  name                = var.cdn_profile_name
  resource_group_name = var.cdn_resource_group_name
  sku_name            = var.cdn_sku_name #"Standard_AzureFrontDoor"
  tags                = var.tags
}

#Create CDN endpoint
resource "azurerm_cdn_frontdoor_endpoint" "gpt" {
  name                     = var.cdn_endpoint.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.gpt.id
  enabled                  = var.cdn_endpoint.enabled
  tags                     = var.tags
}

#Create CDN origin group
resource "azurerm_cdn_frontdoor_origin_group" "gpt" {
  for_each                                                  = { for each in var.cdn_origin_groups : each.name => each }
  name                                                      = each.value.name
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.gpt.id
  session_affinity_enabled                                  = each.value.session_affinity_enabled
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  dynamic "health_probe" {
    for_each = each.value.health_probe != null ? [each.value.health_probe] : []
    content {
      interval_in_seconds = each.value.health_probe.interval_in_seconds
      path                = each.value.health_probe.path
      protocol            = each.value.health_probe.protocol
      request_type        = each.value.health_probe.request_type
    }
  }

  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }
}

#Create CDN origin
resource "azurerm_cdn_frontdoor_origin" "gpt" {
  name                           = var.cdn_gpt_origin.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.gpt[var.cdn_gpt_origin.origin_group_name].id
  enabled                        = var.cdn_gpt_origin.enabled
  certificate_name_check_enabled = var.cdn_gpt_origin.certificate_name_check_enabled
  host_name                      = var.cdn_gpt_origin.host_name
  http_port                      = var.cdn_gpt_origin.http_port
  https_port                     = var.cdn_gpt_origin.https_port
  origin_host_header             = var.cdn_gpt_origin.origin_host_header
  priority                       = var.cdn_gpt_origin.priority
  weight                         = var.cdn_gpt_origin.weight
}

#Create CDN custom domain
resource "azurerm_cdn_frontdoor_custom_domain" "gpt" {
  name                     = var.custom_domain_config.host_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.gpt.id
  dns_zone_id              = var.create_dns_zone ? azurerm_dns_zone.gpt[0].id : data.azurerm_dns_zone.gpt[0].id
  host_name                = "${var.custom_domain_config.host_name}.${var.custom_domain_config.zone_name}"

  dynamic "tls" {
    for_each = length(var.custom_domain_config.tls) > 0 ? { for each in var.custom_domain_config.tls : each.certificate_type => each } : {}
    content {
      certificate_type    = tls.value.certificate_type
      minimum_tls_version = tls.value.minimum_tls_version
    }
  }
}

#create CDN route
resource "azurerm_cdn_frontdoor_route" "gpt" {
  name                            = var.cdn_route.name
  enabled                         = var.cdn_route.enabled
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.gpt.id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.gpt[var.cdn_gpt_origin.origin_group_name].id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.gpt.id]
  forwarding_protocol             = var.cdn_route.forwarding_protocol
  https_redirect_enabled          = var.cdn_route.https_redirect_enabled
  patterns_to_match               = var.cdn_route.patterns_to_match
  supported_protocols             = var.cdn_route.supported_protocols
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.gpt.id]
  cdn_frontdoor_origin_path       = var.cdn_route.cdn_frontdoor_origin_path
  cdn_frontdoor_rule_set_ids      = var.cdn_route.cdn_frontdoor_rule_set_ids
  link_to_default_domain          = var.cdn_route.link_to_default_domain

  dynamic "cache" {
    for_each = var.cdn_route.cache != null ? [var.cdn_route.cache] : []
    content {
      query_string_caching_behavior = cache.value.query_string_caching_behavior
      query_strings                 = cache.value.query_strings
      compression_enabled           = cache.value.compression_enabled
      content_types_to_compress     = cache.value.content_types_to_compress
    }
  }
}

# Create a CNAME record in the custom DNS zone.
resource "azurerm_dns_cname_record" "gpt" {
  name                = var.custom_domain_config.host_name
  zone_name           = var.create_dns_zone ? azurerm_dns_zone.gpt[0].name : data.azurerm_dns_zone.gpt[0].name
  resource_group_name = var.dns_resource_group_name
  ttl                 = var.custom_domain_config.ttl
  record              = azurerm_cdn_frontdoor_endpoint.gpt.host_name
  depends_on          = [azurerm_cdn_frontdoor_route.gpt]
}

# Create a TXT record in the custom DNS zone.
resource "azurerm_dns_txt_record" "gpt" {
  name                = join(".", ["_dnsauth", "${var.custom_domain_config.host_name}"])
  zone_name           = var.create_dns_zone ? azurerm_dns_zone.gpt[0].name : data.azurerm_dns_zone.gpt[0].name
  resource_group_name = var.dns_resource_group_name
  ttl                 = var.custom_domain_config.ttl

  record {
    value = azurerm_cdn_frontdoor_custom_domain.gpt.validation_token
  }
  depends_on = [azurerm_cdn_frontdoor_route.gpt]
}

# Create WAF Firewall Policy
resource "azurerm_cdn_frontdoor_firewall_policy" "gpt" {
  count                             = var.cdn_firewall_policy.create_waf == true ? 1 : 0
  name                              = var.cdn_firewall_policy.name
  resource_group_name               = var.cdn_resource_group_name
  sku_name                          = var.cdn_sku_name
  enabled                           = var.cdn_firewall_policy.enabled
  mode                              = var.cdn_firewall_policy.mode
  redirect_url                      = var.cdn_firewall_policy.redirect_url
  custom_block_response_status_code = var.cdn_firewall_policy.custom_block_response_status_code
  custom_block_response_body        = var.cdn_firewall_policy.custom_block_response_body

  dynamic "custom_rule" {
    for_each = var.cdn_firewall_policy.custom_rules
    content {
      name                           = custom_rule.value.name
      enabled                        = custom_rule.value.enabled
      priority                       = custom_rule.value.priority
      rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rate_limit_threshold
      type                           = custom_rule.value.type
      action                         = custom_rule.value.action

      dynamic "match_condition" {
        for_each = custom_rule.value.match_conditions
        content {
          match_variable     = match_condition.value.match_variable
          match_values       = match_condition.value.match_values
          operator           = match_condition.value.operator
          selector           = match_condition.value.selector
          negation_condition = match_condition.value.negation_condition
          transforms         = match_condition.value.transforms
        }
      }
    }
  }

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_security_policy" "gpt" {
  count                    = var.cdn_firewall_policy.create_waf == true ? 1 : 0
  name                     = var.cdn_security_policy.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.gpt.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.gpt[0].id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.gpt.id
        }
        patterns_to_match = var.cdn_security_policy.patterns_to_match
      }
    }
  }
}