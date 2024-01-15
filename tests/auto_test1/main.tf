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

#################################################
# PRE-REQS                                      #
#################################################
### Random integer to generate unique names
resource "random_integer" "number" {
  min = 0001
  max = 9999
}

### Resource group to deploy the container apps private ChatGPT instance and supporting resources into
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

##################################################
# MODULE TO TEST                                 #
##################################################
module "private-chatgpt-openai" {
  source = "../.."

  #common
  location = var.location
  tags     = var.tags

  #keyvault (OpenAI Service Account details)
  kv_config                                    = local.kv_config
  keyvault_resource_group_name                 = azurerm_resource_group.rg.name
  keyvault_firewall_default_action             = var.keyvault_firewall_default_action
  keyvault_firewall_bypass                     = var.keyvault_firewall_bypass
  keyvault_firewall_allowed_ips                = var.keyvault_firewall_allowed_ips
  keyvault_firewall_virtual_network_subnet_ids = var.keyvault_firewall_virtual_network_subnet_ids

  #Create OpenAI Service?
  create_openai_service                     = var.create_openai_service
  openai_resource_group_name                = azurerm_resource_group.rg.name
  openai_account_name                       = "${var.openai_account_name}${random_integer.number.result}"
  openai_custom_subdomain_name              = "${var.openai_custom_subdomain_name}${random_integer.number.result}"
  openai_sku_name                           = var.openai_sku_name
  openai_local_auth_enabled                 = var.openai_local_auth_enabled
  openai_outbound_network_access_restricted = var.openai_outbound_network_access_restricted
  openai_public_network_access_enabled      = var.openai_public_network_access_enabled
  openai_identity                           = var.openai_identity

  #Create Model Deployment?
  create_model_deployment = var.create_model_deployment
  model_deployment        = var.model_deployment

  #Create networking for CosmosDB and Web App (Optional)
  create_openai_networking    = var.create_openai_networking
  network_resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name        = var.virtual_network_name
  vnet_address_space          = var.vnet_address_space
  subnet_config               = var.subnet_config

  #Create a solution log analytics workspace to store logs from our container apps instance
  #laws_name              = "${var.laws_name}${random_integer.number.result}"
  #laws_sku               = var.laws_sku
  #laws_retention_in_days = var.laws_retention_in_days

  #Create Container App Enviornment
  #cae_name = "${var.cae_name}${random_integer.number.result}"

  #Create a container app instance
  #ca_resource_group_name = azurerm_resource_group.rg.name
  #ca_name                = "${var.ca_name}${random_integer.number.result}"
  #ca_revision_mode       = var.ca_revision_mode
  #ca_identity            = var.ca_identity
  #ca_container_config    = var.ca_container_config

  #Create a container app secrets
  #ca_secrets = local.ca_secrets

  #key vault access
  #key_vault_access_permission = var.key_vault_access_permission
  #key_vault_id                = data.azurerm_key_vault.gpt.id

  #Create front door CDN
  create_front_door_cdn   = var.create_front_door_cdn
  cdn_resource_group_name = azurerm_resource_group.rg.name
  create_dns_zone         = var.create_dns_zone
  dns_resource_group_name = azurerm_resource_group.rg.name
  custom_domain_config    = local.custom_domain_config
  cdn_profile_name        = "${var.cdn_profile_name}${random_integer.number.result}"
  cdn_sku_name            = var.cdn_sku_name
  cdn_endpoint            = var.cdn_endpoint
  cdn_origin_groups       = var.cdn_origin_groups
  cdn_gpt_origin          = var.cdn_gpt_origin
  cdn_route               = var.cdn_route
  cdn_firewall_policy     = local.cdn_firewall_policy
  cdn_security_policy     = var.cdn_security_policy
}