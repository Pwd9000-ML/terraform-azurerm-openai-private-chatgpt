### Common Variables ###
resource_group_name = "Terraform-PrivateGPT1"
location            = "eastus"
tags = {
  Terraform   = "True"
  Description = "Private ChatGPT hosten on Azure OpenAI"
  Author      = "Marcel Lupo"
  GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
}

### OpenAI Service Module Inputs ###
kv_config = {
  name = "openaikv9001"
  sku  = "standard"
}
keyvault_firewall_default_action             = "Deny"
keyvault_firewall_bypass                     = "AzureServices"
keyvault_firewall_allowed_ips                = ["0.0.0.0/0"] #for testing purposes only - allow all IPs
keyvault_firewall_virtual_network_subnet_ids = []

### Create OpenAI Service ###
create_openai_service                     = true
openai_account_name                       = "pwd9001"
openai_custom_subdomain_name              = "pwd9001" #translates to "https://pwd9001.openai.azure.com/"
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
  {
    deployment_id = "gpt35turbo16k"
    model_name    = "gpt-35-turbo-16k"
    model_format  = "OpenAI"
    model_version = "0613"
    scale_type    = "Standard"
  },
  {
    deployment_id = "gpt35turbo"
    model_name    = "gpt-35-turbo"
    model_format  = "OpenAI"
    model_version = "0613"
    scale_type    = "Standard"
  }
]

### log analytics workspace ###
laws_name              = "gptlaws9001"
laws_sku               = "PerGB2018"
laws_retention_in_days = 30

### Container App Enviornment ###
cae_name = "gptcae9001"

### Container App ###
ca_name          = "gptca9001"
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
  max_replicas = 7

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
      value = "gpt35turbo16k"
    },
    {
      name  = "DEFAULT_MODEL" #see model_deployment variable (model_name)
      value = "gpt-35-turbo-16k"
    }
  ]
}

### CDN - Front Door ###
create_front_door_cdn   = true
create_dns_zone         = false #Set to false if you already have a DNS zone
dns_resource_group_name = "pwd9000-eb-network"
custom_domain_config = {
  zone_name = "pwd9000.com"
  host_name = "monkeyGPT"
  ttl       = 600
  tls = [{
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }]
}

# CDN PROFILE
cdn_profile_name = "fd9001"
cdn_sku_name     = "Standard_AzureFrontDoor"

# CDN ENDPOINTS
cdn_endpoint = {
  name    = "PrivateGPT1"
  enabled = true
}

# CDN ORIGIN GROUPS
cdn_origin_groups = [
  {
    name                                                      = "PrivateGPT1OriginGroup"
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
  name                           = "PrivateGPT1Origin"
  origin_group_name              = "PrivateGPT1OriginGroup"
  enabled                        = true
  certificate_name_check_enabled = true
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
}

# CDN ROUTE RULES
cdn_route = {
  name                       = "PrivateGPT1Route"
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