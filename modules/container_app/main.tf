### Create a solution log analytics workspace to store logs ###
resource "azurerm_log_analytics_workspace" "gpt" {
  name                = var.laws_name
  location            = var.location
  resource_group_name = var.ca_resource_group_name
  sku                 = var.laws_sku
  retention_in_days   = var.laws_retention_in_days
  tags                = var.tags
}

### Create Container App Enviornment ###
resource "azurerm_container_app_environment" "gpt" {
  name                       = var.cae_name
  location                   = var.location
  resource_group_name        = var.ca_resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.gpt.id
  tags                       = var.tags
}

### Create a container app instance ###
resource "azurerm_container_app" "gpt" {
  name                         = var.ca_name
  container_app_environment_id = azurerm_container_app_environment.gpt.id
  resource_group_name          = var.ca_resource_group_name
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

# Add container app permission to key vault RBAC (to retrieve OpenAI Account and model details if stored in a key vault)
resource "azurerm_role_assignment" "kv_role_assigment" {
  for_each             = var.key_vault_access_permission != null ? toset(var.key_vault_access_permission) : []
  role_definition_name = each.key
  scope                = var.key_vault_id
  principal_id         = azurerm_container_app.gpt.identity.0.principal_id
}