

###############################################
# OpenAI Service                              #
###############################################
#This module will create an OpenAI service account, deploy models and store the account details in a key vault for consumption by our ChatGPT service.
module "openai" {
  source  = "Pwd9000-ML/openai-service/azurerm"
  version = ">= 1.1.0"

  #common
  location = var.location
  tags     = var.tags

  #key vault (To store OpenAI Account and model details)
  keyvault_resource_group_name                 = var.keyvault_resource_group_name
  kv_config                                    = var.kv_config
  keyvault_firewall_default_action             = var.keyvault_firewall_default_action
  keyvault_firewall_bypass                     = var.keyvault_firewall_bypass
  keyvault_firewall_allowed_ips                = var.keyvault_firewall_allowed_ips
  keyvault_firewall_virtual_network_subnet_ids = var.keyvault_firewall_virtual_network_subnet_ids

  #Create OpenAI Service?
  create_openai_service                     = var.create_openai_service
  openai_resource_group_name                = var.openai_resource_group_name
  openai_account_name                       = var.openai_account_name
  openai_custom_subdomain_name              = var.openai_custom_subdomain_name
  openai_sku_name                           = var.openai_sku_name
  openai_local_auth_enabled                 = var.openai_local_auth_enabled
  openai_outbound_network_access_restricted = var.openai_outbound_network_access_restricted
  openai_public_network_access_enabled      = var.openai_public_network_access_enabled
  openai_identity                           = var.openai_identity

  #Create Model Deployment?
  create_model_deployment = var.create_model_deployment
  model_deployment        = var.model_deployment
}

### Create a solution log analytics workspace to store logs ###
resource "azurerm_log_analytics_workspace" "gpt" {
  name                = var.laws_name
  location            = var.location
  resource_group_name = var.solution_resource_group_name
  sku                 = var.laws_sku
  retention_in_days   = var.laws_retention_in_days
}

### Create Container App Enviornment ###
resource "azurerm_container_app_environment" "gpt" {
  name                       = var.cae_name
  location                   = var.location
  resource_group_name        = var.solution_resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.gpt.id
  tags                       = var.tags
}

### Create a container app instance ###
resource "azurerm_container_app" "gpt" {
  name                         = var.ca_name
  container_app_environment_id = azurerm_container_app_environment.gpt.id
  resource_group_name          = var.solution_resource_group_name
  revision_mode                = var.ca_revision_mode

  dynamic "identity" {
    for_each = var.ca_identity != null ? [var.ca_identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "ingress" {
    for_each = var.ca_ingress != null ? [var.ca_ingress] : []
    content {
      allow_insecure_connections = ingress.value.allow_insecure_connections
      external_enabled           = ingress.value.external_enabled
      target_port                = ingress.value.target_port
      transport                  = ingress.value.transport
      dynamic "traffic_weight" {
        for_each = ingress.value.traffic_weight != null ? [ingress.value.traffic_weight] : []
        content {
          percentage      = traffic_weight.value.percentage
          latest_revision = traffic_weight.value.latest_revision
        }
      }
    }
  }

  template {
    min_replicas = var.ca_container_config != null ? var.ca_container_config.min_replicas : null
    max_replicas = var.ca_container_config != null ? var.ca_container_config.max_replicas : null
    dynamic "container" {
      for_each = var.ca_container_config != null ? [var.ca_container_config] : []
      content {
        name   = container.value.name
        image  = container.value.image
        cpu    = container.value.cpu
        memory = container.value.memory
        dynamic "env" {
          for_each = length(container.value.env) > 0 ? { for each in container.value.env : each.name => each } : {}
          content {
            name        = env.value.name
            secret_name = env.value.secret_name
            value       = env.value.value
          }
        }
      }
    }
  }

  dynamic "secret" {
    for_each = length(var.ca_secrets) > 0 ? { for each in var.ca_secrets : each.name => each } : {}
    content {
      name  = secret.value.name
      value = secret.value.value
    }
  }

  tags = var.tags
}

# Add container app permission to key vault RBAC (to retrieve OpenAI Account and model details)
resource "azurerm_role_assignment" "kv_role_assigment" {
  for_each             = toset(["Key Vault Secrets User"])
  role_definition_name = each.key
  scope                = module.openai.key_vault_id
  principal_id         = azurerm_container_app.gpt.identity.0.principal_id
}

### Front solution with an Azure front door (optional) ###
# 1.) Deploy Azure Front Door.
# 2.) Setup a custom domain with AFD managed certificate.
# 3.) Optionally create an Azure DNS Zone or use an existing one.
# 4.) Create a CNAME record in the custom DNS zone.

module "azure_frontdoor_cdn" {
  count  = var.create_front_door_cdn ? 1 : 0
  source = "./modules/cdn_frontdoor"

  cdn_resource_group_name = var.cdn_resource_group_name
  create_dns_zone         = var.create_dns_zone
  dns_resource_group_name = var.dns_resource_group_name
  custom_domain_config    = var.custom_domain_config
  cdn_profile_name        = var.cdn_profile_name
  cdn_sku_name            = var.cdn_sku_name
  cdn_endpoint            = var.cdn_endpoint
  cdn_origin_groups       = var.cdn_origin_groups
  cdn_gpt_origin          = local.cdn_gpt_origin
  cdn_route               = var.cdn_route
  tags                    = var.tags
  depends_on              = [azurerm_container_app.gpt]
}