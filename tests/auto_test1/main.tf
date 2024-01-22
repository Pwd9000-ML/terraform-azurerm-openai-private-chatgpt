terraform {
  backend "azurerm" {}
  #backend "local" { path = "terraform-test1.tfstate" }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# #################################################
# # PRE-REQS                                      #
# #################################################
### Random integer to generate unique names
resource "random_integer" "number" {
  min = 0001
  max = 9999
}

# ##################################################
# # MODULE TO TEST                                 #
# ##################################################
module "private-chatgpt-openai" {
  source = "../.."

  # 01 common + RG #
  #================#
  location            = var.location
  tags                = var.tags
  resource_group_name = var.resource_group_name

  # 02 networking #
  #===============#
  virtual_network_name = "${var.virtual_network_name}${random_integer.number.result}"
  vnet_address_space   = var.vnet_address_space
  subnet_config        = var.subnet_config

  # 03 keyvault (Solution Secrets)
  #==============================#
  kv_name                  = "${var.kv_name}${random_integer.number.result}"
  kv_sku                   = var.kv_sku
  kv_fw_default_action     = var.kv_fw_default_action
  kv_fw_bypass             = var.kv_fw_bypass
  kv_fw_allowed_ips        = var.kv_fw_allowed_ips
  kv_fw_network_subnet_ids = var.kv_fw_network_subnet_ids

  # 04 openai service
  #==================#
  oai_account_name                       = "${var.oai_account_name}${random_integer.number.result}"
  oai_sku_name                           = var.oai_sku_name
  oai_custom_subdomain_name              = "${var.oai_custom_subdomain_name}${random_integer.number.result}"
  oai_dynamic_throttling_enabled         = var.oai_dynamic_throttling_enabled
  oai_fqdns                              = var.oai_fqdns
  oai_local_auth_enabled                 = var.oai_local_auth_enabled
  oai_outbound_network_access_restricted = var.oai_outbound_network_access_restricted
  oai_public_network_access_enabled      = var.oai_public_network_access_enabled
  oai_customer_managed_key               = var.oai_customer_managed_key
  oai_identity                           = var.oai_identity
  oai_network_acls                       = var.oai_network_acls
  oai_storage                            = var.oai_storage
  oai_model_deployment                   = var.oai_model_deployment

  # 05 cosmosdb
  #============#
  cosmosdb_name                              = "${var.cosmosdb_name}${random_integer.number.result}"
  cosmosdb_offer_type                        = var.cosmosdb_offer_type
  cosmosdb_kind                              = var.cosmosdb_kind
  cosmosdb_automatic_failover                = var.cosmosdb_automatic_failover
  use_cosmosdb_free_tier                     = var.use_cosmosdb_free_tier
  cosmosdb_consistency_level                 = var.cosmosdb_consistency_level
  cosmosdb_max_interval_in_seconds           = var.cosmosdb_max_interval_in_seconds
  cosmosdb_max_staleness_prefix              = var.cosmosdb_max_staleness_prefix
  cosmosdb_geo_locations                     = var.cosmosdb_geo_locations
  cosmosdb_capabilities                      = var.cosmosdb_capabilities
  cosmosdb_virtual_network_subnets           = var.cosmosdb_virtual_network_subnets
  cosmosdb_is_virtual_network_filter_enabled = var.cosmosdb_is_virtual_network_filter_enabled
  cosmosdb_public_network_access_enabled     = var.cosmosdb_public_network_access_enabled

  # 06 app services (librechat app + meilisearch)
  #=============================================#
  # App Service Plan
  app_service_name     = "${var.app_service_name}${random_integer.number.result}"
  app_service_sku_name = var.app_service_sku_name

  # MeiSearch App
  #meilisearch_app_name                      = "${var.meilisearch_app_name}${random_integer.number.result}"
  #meilisearch_app_virtual_network_subnet_id = var.meilisearch_app_virtual_network_subnet_id
  #meilisearch_app_key                       = var.meilisearch_app_key

  # LibreChat App
  libre_app_name                          = "${var.libre_app_name}${random_integer.number.result}"
  libre_app_virtual_network_subnet_id     = var.libre_app_virtual_network_subnet_id
  libre_app_public_network_access_enabled = var.libre_app_public_network_access_enabled
  libre_app_allowed_ip_address            = var.libre_app_allowed_ip_address

  ### LibreChat App Settings ###
  # Server Config
  libre_app_title         = var.libre_app_title
  libre_app_custom_footer = var.libre_app_custom_footer
  libre_app_host          = var.libre_app_host
  libre_app_port          = var.libre_app_port
  libre_app_mongo_uri     = var.libre_app_mongo_uri
  libre_app_domain_client = var.libre_app_domain_client
  libre_app_domain_server = var.libre_app_domain_server

  # Debug Config
  libre_app_debug_logging = var.libre_app_debug_logging
  libre_app_debug_console = var.libre_app_debug_console

  # Endpoints
  libre_app_endpoints = var.libre_app_endpoints

  # Azure OpenAI Config
  libre_app_az_oai_api_key                      = var.libre_app_az_oai_api_key
  libre_app_az_oai_models                       = var.libre_app_az_oai_models
  libre_app_az_oai_use_model_as_deployment_name = var.libre_app_az_oai_use_model_as_deployment_name
  libre_app_az_oai_instance_name                = var.libre_app_az_oai_instance_name
  libre_app_az_oai_api_version                  = var.libre_app_az_oai_api_version
  libre_app_az_oai_dall3_api_version            = var.libre_app_az_oai_dall3_api_version
  libre_app_az_oai_dall3_deployment_name        = var.libre_app_az_oai_dall3_deployment_name

  # Plugins
  libre_app_debug_plugins     = var.libre_app_debug_plugins
  libre_app_plugins_creds_key = var.libre_app_plugins_creds_key
  libre_app_plugins_creds_iv  = var.libre_app_plugins_creds_iv
  libre_app_plugin_models     = var.libre_app_plugin_models

  # Search
  libre_app_enable_meilisearch = var.libre_app_enable_meilisearch
  #libre_app_disable_meilisearch_analytics = var.libre_app_disable_meilisearch_analytics
  #libre_app_meili_host                    = var.libre_app_meili_host
  #libre_app_meili_key                     = var.libre_app_meili_key

  # User Registration
  libre_app_allow_email_login         = var.libre_app_allow_email_login
  libre_app_allow_registration        = var.libre_app_allow_registration
  libre_app_allow_social_login        = var.libre_app_allow_social_login
  libre_app_allow_social_registration = var.libre_app_allow_social_registration
  libre_app_jwt_secret                = var.libre_app_jwt_secret
  libre_app_jwt_refresh_secret        = var.libre_app_jwt_refresh_secret

}





#   #Create OpenAI Service?
#   create_openai_service                     = var.create_openai_service
#   openai_resource_group_name                = azurerm_resource_group.rg.name
#   openai_account_name                       = "${var.openai_account_name}${random_integer.number.result}"
#   openai_custom_subdomain_name              = "${var.openai_custom_subdomain_name}${random_integer.number.result}"
#   openai_sku_name                           = var.openai_sku_name
#   openai_local_auth_enabled                 = var.openai_local_auth_enabled
#   openai_outbound_network_access_restricted = var.openai_outbound_network_access_restricted
#   openai_public_network_access_enabled      = var.openai_public_network_access_enabled
#   openai_identity                           = var.openai_identity

#   #Create Model Deployment?
#   create_model_deployment = var.create_model_deployment
#   model_deployment        = var.model_deployment

#   #Create networking for CosmosDB and Web App (Optional)
#   create_openai_networking    = var.create_openai_networking
#   network_resource_group_name = azurerm_resource_group.rg.name
#   virtual_network_name        = "${var.virtual_network_name}${random_integer.number.result}"
#   vnet_address_space          = var.vnet_address_space
#   subnet_config               = var.subnet_config

#   #Create a CosmosDB account running MongoDB to store chat data (Optional)
#   create_cosmosdb                            = var.create_cosmosdb
#   cosmosdb_name                              = "${var.cosmosdb_name}${random_integer.number.result}"
#   cosmosdb_resource_group_name               = var.cosmosdb_resource_group_name
#   cosmosdb_offer_type                        = var.cosmosdb_offer_type
#   cosmosdb_kind                              = var.cosmosdb_kind
#   cosmosdb_automatic_failover                = var.cosmosdb_automatic_failover
#   use_cosmosdb_free_tier                     = var.use_cosmosdb_free_tier
#   cosmosdb_consistency_level                 = var.cosmosdb_consistency_level
#   cosmosdb_max_interval_in_seconds           = var.cosmosdb_max_interval_in_seconds
#   cosmosdb_max_staleness_prefix              = var.cosmosdb_max_staleness_prefix
#   cosmosdb_geo_locations                     = var.cosmosdb_geo_locations
#   cosmosdb_capabilities                      = var.cosmosdb_capabilities
#   cosmosdb_is_virtual_network_filter_enabled = var.cosmosdb_is_virtual_network_filter_enabled
#   cosmosdb_public_network_access_enabled     = var.cosmosdb_public_network_access_enabled

#   #Create a solution log analytics workspace to store logs from our container apps instance
#   #laws_name              = "${var.laws_name}${random_integer.number.result}"
#   #laws_sku               = var.laws_sku
#   #laws_retention_in_days = var.laws_retention_in_days

#   #Create Container App Enviornment
#   #cae_name = "${var.cae_name}${random_integer.number.result}"

#   #Create a container app instance
#   #ca_resource_group_name = azurerm_resource_group.rg.name
#   #ca_name                = "${var.ca_name}${random_integer.number.result}"
#   #ca_revision_mode       = var.ca_revision_mode
#   #ca_identity            = var.ca_identity
#   #ca_container_config    = var.ca_container_config

#   #Create a container app secrets
#   #ca_secrets = local.ca_secrets

#   #key vault access
#   #key_vault_access_permission = var.key_vault_access_permission
#   #key_vault_id                = data.azurerm_key_vault.gpt.id

#   #Create front door CDN
#   create_front_door_cdn   = var.create_front_door_cdn
#   cdn_resource_group_name = azurerm_resource_group.rg.name
#   create_dns_zone         = var.create_dns_zone
#   dns_resource_group_name = azurerm_resource_group.rg.name
#   custom_domain_config    = local.custom_domain_config
#   cdn_profile_name        = "${var.cdn_profile_name}${random_integer.number.result}"
#   cdn_sku_name            = var.cdn_sku_name
#   cdn_endpoint            = var.cdn_endpoint
#   cdn_origin_groups       = var.cdn_origin_groups
#   cdn_gpt_origin          = var.cdn_gpt_origin
#   cdn_route               = var.cdn_route
#   cdn_firewall_policy     = local.cdn_firewall_policy
#   cdn_security_policy     = var.cdn_security_policy
# }