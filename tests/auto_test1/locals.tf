locals {
  # Container App Secrets
  ca_secrets = [
    {
      name  = "openai-api-key"
      value = "${module.private-chatgpt-openai.openai_primary_key}"
    },
    {
      name  = "openai-api-host"
      value = "${module.private-chatgpt-openai.openai_endpoint}"
    }
  ]

  # Key Vault Config (with ranodm number suffix)
  kv_config = {
    name = "gptkv${random_integer.number.result}"
    sku  = "standard"
  }

  # Custom Domain Config (with ranodm number suffix)
  custom_domain_config = {
    zone_name = "gpt${random_integer.number.result}.com"
    host_name = "PrivateGPT"
    ttl       = 600
    tls = [{
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }]
  }

  # CDN WAF Config (with ranodm number suffix)
  cdn_firewall_policies = [{
    name                              = "PrivateGPTWAF${random_integer.number.result}"
    enabled                           = true
    mode                              = "Prevention"
    custom_block_response_body        = "WW91ciByZXF1ZXN0IGhhcyBiZWVuIGJsb2NrZWQu"
    custom_block_response_status_code = 403
    custom_rules = [
      {
        name                           = "AllowedIPs"
        action                         = "Block"
        enabled                        = true
        priority                       = 100
        type                           = "MatchRule"
        rate_limit_duration_in_minutes = 1
        rate_limit_threshold           = 10
        match_conditions = [
          {
            negation_condition = true
            match_values       = ["86.106.76.66"] #Allowd IPs (Replace with your IP Allow list)
            match_variable     = "RemoteAddr"
            operator           = "IPMatch"
            transforms         = []
          }
        ]
      }
    ]
  }]

  # CDN Security Policy Config (with ranodm number suffix)
  cdn_security_policy = {
    link_waf             = true
    name                 = "PrivateGPTSecurityPolicy"
    firewall_policy_name = "PrivateGPTWAF${random_integer.number.result}"
    patterns_to_match    = ["/*"]
  }
}