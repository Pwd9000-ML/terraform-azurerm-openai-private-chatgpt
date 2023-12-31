### Common Variables ###
resource_group_name = "TF-Module-Example2-Cognitive-GPT"
location            = "uksouth"
tags = {
  Terraform   = "True"
  Description = "Private ChatGPT hosted on Azure OpenAI"
  Author      = "Marcel Lupo"
  GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
}

### OpenAI Service Module Inputs ###
kv_config = {
  name = "openaikv2158"
  sku  = "standard"
}
keyvault_firewall_default_action             = "Deny"
keyvault_firewall_bypass                     = "AzureServices"
keyvault_firewall_allowed_ips                = ["0.0.0.0/0"] #for testing purposes only - allow all IPs
keyvault_firewall_virtual_network_subnet_ids = []

### Create OpenAI Service ###
create_openai_service                     = true
openai_account_name                       = "openaiacc2158"
openai_custom_subdomain_name              = "openaiacc2158" #translates to "https://openaiacc2158.openai.azure.com/"
openai_sku_name                           = "S0"
openai_local_auth_enabled                 = true
openai_outbound_network_access_restricted = false
openai_public_network_access_enabled      = true
openai_identity = {
  type = "SystemAssigned"
}

### Create Model deployment ###
create_model_deployment = true
model_deployment = [
  # {
  #   deployment_id  = "gpt35turbo"    ## Example of "gpt-35-turbo"
  #   model_name     = "gpt-35-turbo"
  #   model_format   = "OpenAI"
  #   model_version  = "0613"
  #   scale_type     = "Standard"
  #   scale_capacity = 16
  # },
  # {
  #   deployment_id  = "gpt4" ## Example of "gpt-4"
  #   model_name     = "gpt-4"
  #   model_format   = "OpenAI"
  #   model_version  = "0613"
  #   scale_type     = "Standard"
  #   scale_capacity = 16
  # },
  {
    deployment_id  = "gpt35turbo16k"
    model_name     = "gpt-35-turbo-16k"
    model_format   = "OpenAI"
    model_version  = "0613"
    scale_type     = "Standard"
    scale_capacity = 34 # 34K == Roughly 204 RPM (Requests per minute)
  },
  {
    deployment_id  = "gpt432k" ## latest model
    model_name     = "gpt-4-32k"
    model_format   = "OpenAI"
    model_version  = "0613"
    scale_type     = "Standard"
    scale_capacity = 34 # 34K == Roughly 204 RPM (Requests per minute)
  }
]

### log analytics workspace for container apps ###
laws_name              = "openailaws2158"
laws_sku               = "PerGB2018"
laws_retention_in_days = 30

### Container App Enviornment ###
cae_name = "openaicae2158"

### Container App ###
ca_name          = "openaica2158"
ca_revision_mode = "Single"
ca_identity = {
  type = "SystemAssigned"
}
ca_ingress = {
  allow_insecure_connections = false
  external_enabled           = true
  target_port                = 3000
  transport                  = "auto"
  traffic_weight = {
    latest_revision = true
    percentage      = 100
  }
}
ca_container_config = {
  name         = "gpt-chatbot-ui"
  image        = "ghcr.io/pwd9000-ml/chatbot-ui:main"
  cpu          = 2
  memory       = "4Gi"
  min_replicas = 0
  max_replicas = 5

  ## Environment Variables (Required)##
  env = [
    {
      name        = "OPENAI_API_KEY"
      secret_name = "openai-api-key" #see locals.tf (Can also be added from key vault created by module, or existing key)
    },
    {
      name        = "OPENAI_API_HOST"
      secret_name = "openai-api-host" #see locals.tf (Can also be added from key vault created by module, or existing host/endpoint)
    },
    {
      name  = "OPENAI_API_TYPE"
      value = "azure"
    },
    {
      name  = "AZURE_DEPLOYMENT_ID" #see model_deployment variable (deployment_id)
      value = "gpt432k"
    },
    {
      name  = "DEFAULT_MODEL" #see model_deployment variable (model_name)
      value = "gpt-4-32k"
    }
  ]
}

### key vault access ###
key_vault_access_permission = ["Key Vault Secrets User"]

### CDN - Front Door ###
create_front_door_cdn   = true
create_dns_zone         = true # Set to false if you already have a DNS zone, set to true if you want to create a new one
dns_resource_group_name = "TF-Module-Example2-Cognitive-GPT"
custom_domain_config = {
  zone_name = "newzone2158.com"
  host_name = "privategpt"
  ttl       = 600
  tls = [{
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }]
}

# CDN PROFILE
cdn_profile_name = "openaifd2158"
cdn_sku_name     = "Standard_AzureFrontDoor"

# CDN ENDPOINTS
cdn_endpoint = {
  name    = "PrivateGPT"
  enabled = true
}

# CDN ORIGIN GROUPS
cdn_origin_groups = [
  {
    name                                                      = "PrivateGPTOriginGroup"
    session_affinity_enabled                                  = false
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 5
    health_probe = {
      interval_in_seconds = 100
      path                = "/"
      protocol            = "Https"
      request_type        = "HEAD"
    }
    load_balancing = {
      additional_latency_in_milliseconds = 50
      sample_size                        = 4
      successful_samples_required        = 3
    }
  }
]

# GPT CDN ORIGIN
cdn_gpt_origin = {
  name                           = "PrivateGPTOrigin"
  origin_group_name              = "PrivateGPTOriginGroup"
  enabled                        = true
  certificate_name_check_enabled = true
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
}

# CDN ROUTE RULES
cdn_route = {
  name                       = "PrivateGPTRoute"
  enabled                    = true
  forwarding_protocol        = "HttpsOnly"
  https_redirect_enabled     = true
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

# CDN FIREWALL POLICIES
cdn_firewall_policy = {
  create_waf                        = true
  name                              = "PrivateGPTWAF2158"
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
          match_values       = ["86.106.76.66"] #Add your Allowed IPs here (e.g. ["x.x.x.x", "x.x.x.x"])
          match_variable     = "RemoteAddr"
          operator           = "IPMatch"
          transforms         = []
        }
      ]
    }
  ]
}

# CDN SECURITY POLICY (WAF)
cdn_security_policy = {
  name              = "PrivateGPTSecurityPolicy"
  patterns_to_match = ["/*"]
}