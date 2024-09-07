# Create OpenAI Cognitive Account
resource "azurerm_cognitive_account" "az_openai" {
  kind                               = "OpenAI"
  location                           = var.location
  name                               = var.oai_account_name
  resource_group_name                = azurerm_resource_group.az_openai_rg.name
  sku_name                           = var.oai_sku_name
  custom_subdomain_name              = var.oai_custom_subdomain_name
  dynamic_throttling_enabled         = var.oai_dynamic_throttling_enabled
  fqdns                              = var.oai_fqdns
  local_auth_enabled                 = var.oai_local_auth_enabled
  outbound_network_access_restricted = var.oai_outbound_network_access_restricted
  public_network_access_enabled      = var.oai_public_network_access_enabled
  tags                               = var.tags

  dynamic "customer_managed_key" {
    for_each = var.oai_customer_managed_key != null ? [var.oai_customer_managed_key] : []
    content {
      key_vault_key_id   = customer_managed_key.value.key_vault_key_id
      identity_client_id = customer_managed_key.value.identity_client_id
    }
  }

  dynamic "identity" {
    for_each = var.oai_identity != null ? [var.oai_identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_acls" {
    for_each = var.oai_network_acls != null ? [var.oai_network_acls] : []
    content {
      default_action = network_acls.value.default_action
      ip_rules       = network_acls.value.ip_rules

      dynamic "virtual_network_rules" {
        for_each = network_acls.value.virtual_network_rules != null ? network_acls.value.virtual_network_rules : []
        content {
          subnet_id                            = virtual_network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
        }
      }
    }
  }

  dynamic "storage" {
    for_each = var.oai_storage
    content {
      storage_account_id = storage.value.storage_account_id
      identity_client_id = storage.value.identity_client_id
    }
  }
}

# Create OpenAI Cognitive Account Model Deployments
resource "azurerm_cognitive_deployment" "az_openai_models" {
  for_each = { for each in var.oai_model_deployment : each.deployment_id => each }

  cognitive_account_id = azurerm_cognitive_account.az_openai.id
  name                 = each.value.deployment_id
  rai_policy_name      = each.value.rai_policy_name

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }
  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    size     = each.value.sku_size
    family   = each.value.sku_family
    capacity = each.value.sku_capacity
  }
}

# Save OpenAI Cognitive Account details to Key Vault for consumption by other services
resource "azurerm_key_vault_secret" "openai_endpoint" {
  name         = "${var.oai_account_name}-openai-endpoint"
  value        = azurerm_cognitive_account.az_openai.endpoint
  key_vault_id = azurerm_key_vault.az_openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

resource "azurerm_key_vault_secret" "openai_primary_key" {
  name         = "${var.oai_account_name}-openai-key"
  value        = azurerm_cognitive_account.az_openai.primary_access_key
  key_vault_id = azurerm_key_vault.az_openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}
