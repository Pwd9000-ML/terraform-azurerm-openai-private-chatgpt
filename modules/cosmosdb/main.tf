resource "azurerm_cosmosdb_account" "mongo" {
  name                      = var.cosmosdb_name
  resource_group_name       = var.cosmosdb_resource_group_name
  location                  = var.location
  offer_type                = var.cosmosdb_offer_type
  kind                      = var.cosmosdb_kind
  enable_automatic_failover = var.cosmosdb_automatic_failover
  enable_free_tier          = var.use_cosmosdb_free_tier
  tags                      = var.tags

  consistency_policy {
    consistency_level       = var.cosmosdb_consistency_level
    max_interval_in_seconds = var.cosmosdb_max_interval_in_seconds
    max_staleness_prefix    = var.cosmosdb_max_staleness_prefix
  }

  dynamic "geo_location" {
    for_each = var.geo_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
    }
  }

  dynamic "capabilities" {
    for_each = var.capabilities
    content {
      name = capabilities.value
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_subnets
    content {
      id = virtual_network_rule.value
    }
  }

  is_virtual_network_filter_enabled = var.is_virtual_network_filter_enabled
  public_network_access_enabled     = var.public_network_access_enabled
}

# Add "self" permission to key vault RBAC (to manange key vault secrets)
# resource "azurerm_role_assignment" "kv_role_assigment" {
#   for_each             = toset(["Key Vault Administrator"])
#   role_definition_name = each.key
#   scope                = var.openai_keyvault_id
#   principal_id         = data.azurerm_client_config.current.object_id
# }

### Save CosmosDB details to Key Vault for consumption by other services (e.g. LibreChat App)
resource "azurerm_key_vault_secret" "openai_cosmos_uri" {
  name         = "${var.cosmosdb_name}-cosmos-uri"
  value        = azurerm_cosmosdb_account.mongo.primary_mongodb_connection_string
  key_vault_id = var.openai_keyvault_id
}