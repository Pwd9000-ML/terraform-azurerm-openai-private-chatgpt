### 01 Common Variables + RG ###
resource_group_name = "TF-Module-Automated-Tests-Cognitive-GPT"
location            = "SwedenCentral"
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
oai_account_name                       = "gptopenai"
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
    deployment_id  = "gpt-35-turbo"
    model_name     = "gpt-35-turbo"
    model_format   = "OpenAI"
    model_version  = "1106"
    scale_type     = "Standard"
    scale_capacity = 20 # 34K == Roughly 204 RPM (Requests per minute)
  },
  {
    deployment_id  = "gpt-4"
    model_name     = "gpt-4"
    model_format   = "OpenAI"
    model_version  = "1106-Preview"
    scale_type     = "Standard"
    scale_capacity = 20
  },
  {
    deployment_id  = "gpt-4-vision-preview"
    model_name     = "gpt-4"
    model_format   = "OpenAI"
    model_version  = "vision-preview"
    scale_type     = "Standard"
    scale_capacity = 5
  },
  {
    deployment_id  = "dall-e-3"
    model_name     = "dall-e-3"
    model_format   = "OpenAI"
    model_version  = "3.0"
    scale_type     = "Standard"
    scale_capacity = 2
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
    location          = "SwedenCentral"
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
#meilisearch_app_name                      = "meilisearchapp"
#meilisearch_app_virtual_network_subnet_id = null
#meilisearch_app_key                       = null

# LibreChat App Service
libre_app_name                          = "librechatapp"
libre_app_public_network_access_enabled = true
libre_app_virtual_network_subnet_id     = null # Access is allowed on the built in subnet of this module. If networking is created as part of the module, this will be automatically populated if value is 'null' (priority 100)
libre_app_allowed_subnets               = null # Add any other subnet ids to allow access to the app service (optional)
libre_app_allowed_ip_addresses = [
  {
    ip_address = "0.0.0.0/0" # Allow all IP Addresses (change to your IP range)
    priority   = 200
    name       = "ip-access-rule1"
    action     = "Allow"
  }
]

### LibreChat App Settings ###
# Server Config
libre_app_title         = "Azure OpenAI LibreChat"
libre_app_custom_footer = "Privately hosted chat app powered by Azure OpenAI and LibreChat"
libre_app_host          = "0.0.0.0"
libre_app_port          = 80
libre_app_docker_image  = "ghcr.io/danny-avila/librechat-dev-api:latest"
libre_app_mongo_uri     = null
libre_app_domain_client = "http://localhost:80"
libre_app_domain_server = "http://localhost:80"

# debug logging
libre_app_debug_logging = true
libre_app_debug_console = false

# Endpoints
libre_app_endpoints = "azureOpenAI"

# Azure OpenAI
libre_app_az_oai_api_key                      = null
libre_app_az_oai_models                       = "gpt-35-turbo,gpt-4,gpt-4-vision-preview"
libre_app_az_oai_use_model_as_deployment_name = true
libre_app_az_oai_instance_name                = null
libre_app_az_oai_api_version                  = "2023-07-01-preview"
libre_app_az_oai_dall3_api_version            = "2023-12-01-preview"
libre_app_az_oai_dall3_deployment_name        = "dall-e-3"

# Plugins
libre_app_debug_plugins     = true
libre_app_plugins_creds_key = null
libre_app_plugins_creds_iv  = null
# libre_app_plugin_models     = "gpt-35-turbo,gpt-4,gpt-4-vision-preview"
# libre_app_plugins_use_azure = true

# Search
libre_app_enable_meilisearch = false
#libre_app_disable_meilisearch_analytics = true
#libre_app_meili_host                    = null
#libre_app_meili_key                     = null

# User Registration
libre_app_allow_email_login         = true
libre_app_allow_registration        = true
libre_app_allow_social_login        = false
libre_app_allow_social_registration = false
libre_app_jwt_secret                = null
libre_app_jwt_refresh_secret        = null

# Custom Domain and Managed Certificate (Optional)
libre_app_custom_domain_create     = true
librechat_app_custom_domain_name   = "privategpt"
librechat_app_custom_dns_zone_name = "pwd9000.com"
dns_resource_group_name            = "Pwd9000-EB-Network"
