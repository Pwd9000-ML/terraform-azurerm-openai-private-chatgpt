### 01 Common Variables + RG ###
resource_group_name = "TF-Module-Automated-Tests-Cognitive-GPT"
location            = "westus"
tags = {
  Terraform   = "True"
  Description = "Private ChatGPT hosted on Azure OpenAI (Librechat)"
  Author      = "Marcel Lupo"
  GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
}

### 02 networking ###
virtual_network_name = "openaivnet"
vnet_address_space   = ["10.4.0.0/24"]
subnet_config = {
  subnet_name                                   = "app-cosmos-sub"
  subnet_address_space                          = ["10.4.0.0/24"]
  service_endpoints                             = ["Microsoft.AzureCosmosDB", "Microsoft.Web", "Microsoft.KeyVault"]
  private_endpoint_network_policies_enabled     = false
  private_link_service_network_policies_enabled = false
  subnets_delegation_settings = {
    app-service-plan = [
      {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    ]
  }
}

### 03 KeyVault ###
kv_name                  = "openaikv"
kv_sku                   = "standard"
kv_fw_default_action     = "Deny"
kv_fw_bypass             = "AzureServices"
kv_fw_allowed_ips        = ["0.0.0.0/0"]
kv_fw_network_subnet_ids = null

### 04 Create OpenAI Service ###
oai_account_name                       = "gptopenaiaccount"
oai_sku_name                           = "S0"
oai_custom_subdomain_name              = "gptopenai"
oai_dynamic_throttling_enabled         = false
oai_fqdns                              = []
oai_local_auth_enabled                 = true
oai_outbound_network_access_restricted = false
oai_public_network_access_enabled      = true
oai_customer_managed_key               = null
oai_identity = {
  type = "SystemAssigned"
}
oai_network_acls = null
oai_storage      = null
oai_model_deployment = [
  {
    deployment_id  = "gpt-4-1106-Preview"
    model_name     = "gpt-4"
    model_format   = "OpenAI"
    model_version  = "1106-Preview"
    scale_type     = "Standard"
    scale_capacity = 20 # 34K == Roughly 204 RPM (Requests per minute)
  },
  {
    deployment_id  = "gpt-4-vision-preview"
    model_name     = "gpt-4"
    model_format   = "OpenAI"
    model_version  = "vision-preview"
    scale_type     = "Standard"
    scale_capacity = 5
  }
]

### 05 cosmosdb ###
cosmosdb_name                    = "gptcosmosdb"
cosmosdb_offer_type              = "Standard"
cosmosdb_kind                    = "MongoDB"
cosmosdb_automatic_failover      = false
use_cosmosdb_free_tier           = true
cosmosdb_consistency_level       = "BoundedStaleness"
cosmosdb_max_interval_in_seconds = 10
cosmosdb_max_staleness_prefix    = 200
cosmosdb_geo_locations = [
  {
    location          = "uksouth"
    failover_priority = 0
  }
]
cosmosdb_capabilities                      = ["EnableMongo", "MongoDBv3.4"]
cosmosdb_virtual_network_subnets           = null
cosmosdb_is_virtual_network_filter_enabled = true
cosmosdb_public_network_access_enabled     = true

### 06 app services (librechat app + meilisearch) ###
# App Service Plan
app_service_name     = "openaiasp"
app_service_sku_name = "B1"

# Meilisearch App
meilisearch_app_name                      = "meilisearchapp"
meilisearch_app_virtual_network_subnet_id = null

# LibreChat App Service
libre_app_name                          = "librechatapp"
libre_app_public_network_access_enabled = true
libre_app_virtual_network_subnet_id     = null

### LibreChat App Settings ###
# Server Config
libre_app_title         = "Azure OpenAI LibreChat"
libre_app_custom_footer = "Privately hosted chat app powered by Azure OpenAI and LibreChat"
libre_app_host          = "0.0.0.0"
libre_app_port          = 3080
libre_app_mongo_uri     = null
libre_app_domain_client = "https://localhost:3080"
libre_app_domain_server = "https://localhost:3080"

# debug logging
libre_app_debug_logging = false
libre_app_debug_console = false

# Endpoints
libre_app_endpoints = "AzureOpenAI"

# Azure OpenAI
libre_app_az_oai_api_key                      = null
libre_app_az_oai_models                       = "gpt-4-1106-Preview,gpt-4-vision-preview"
libre_app_az_oai_use_model_as_deployment_name = true
libre_app_az_oai_instance_name                = null
libre_app_az_oai_api_version                  = "2023-07-01-preview"

# Plugins
libre_app_debug_plugins     = false
libre_app_plugins_creds_key = null
libre_app_plugins_creds_iv  = null

# Search
libre_app_enable_meilisearch            = true
libre_app_disable_meilisearch_analytics = true
libre_app_meili_host                    = null
libre_app_meili_key                     = null

# User Registration
libre_app_allow_email_login         = true
libre_app_allow_registration        = true
libre_app_allow_social_login        = false
libre_app_allow_social_registration = false
libre_app_jwt_secret                = null
libre_app_jwt_refresh_secret        = null

# ### CDN - Front Door ###
# create_front_door_cdn = true
# create_dns_zone       = true #Set to false if you already have a DNS zone, remember to add this DNS zone to your domain registrar

# # CDN PROFILE
# cdn_profile_name = "cdnfd"
# cdn_sku_name     = "Standard_AzureFrontDoor"

# # CDN ENDPOINTS
# cdn_endpoint = {
#   name    = "PrivateGPT"
#   enabled = true
# }

# # CDN ORIGIN GROUPS
# cdn_origin_groups = [
#   {
#     name                                                      = "PrivateGPTOriginGroup"
#     session_affinity_enabled                                  = false
#     restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 5
#     health_probe = {
#       interval_in_seconds = 100
#       path                = "/"
#       protocol            = "Https"
#       request_type        = "HEAD"
#     }
#     load_balancing = {
#       additional_latency_in_milliseconds = 50
#       sample_size                        = 4
#       successful_samples_required        = 3
#     }
#   }
# ]

# # GPT CDN ORIGIN
# cdn_gpt_origin = {
#   name                           = "PrivateGPTOrigin"
#   origin_group_name              = "PrivateGPTOriginGroup"
#   enabled                        = true
#   certificate_name_check_enabled = true
#   http_port                      = 80
#   https_port                     = 443
#   priority                       = 1
#   weight                         = 1000
# }

# # CDN ROUTE RULES
# cdn_route = {
#   name                       = "PrivateGPTRoute"
#   enabled                    = true
#   forwarding_protocol        = "HttpsOnly"
#   https_redirect_enabled     = true
#   patterns_to_match          = ["/*"]
#   supported_protocols        = ["Http", "Https"]
#   cdn_frontdoor_origin_path  = null
#   cdn_frontdoor_rule_set_ids = null
#   link_to_default_domain     = false
#   cache = {
#     query_string_caching_behavior = "IgnoreQueryString"
#     query_strings                 = []
#     compression_enabled           = false
#     content_types_to_compress     = []
#   }
# }

# # CDN WAF Config
# cdn_firewall_policy = {
#   create_waf                        = true
#   name                              = "PrivateGPTWAF"
#   enabled                           = true
#   mode                              = "Prevention"
#   custom_block_response_body        = "WW91ciByZXF1ZXN0IGhhcyBiZWVuIGJsb2NrZWQu"
#   custom_block_response_status_code = 403
#   custom_rules = [
#     {
#       name                           = "AllowedIPs"
#       action                         = "Block"
#       enabled                        = true
#       priority                       = 100
#       type                           = "MatchRule"
#       rate_limit_duration_in_minutes = 1
#       rate_limit_threshold           = 10
#       match_conditions = [
#         {
#           negation_condition = true
#           match_values       = ["86.106.76.66"] #Allowd IPs (Replace with your IP Allow list)
#           match_variable     = "RemoteAddr"
#           operator           = "IPMatch"
#           transforms         = []
#         }
#       ]
#     }
#   ]
# }

# # CDN Security Policy Config
# cdn_security_policy = {
#   name              = "PrivateGPTSecurityPolicy"
#   patterns_to_match = ["/*"]
# }