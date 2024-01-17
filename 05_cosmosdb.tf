resource "azurerm_cosmosdb_account" "mongo" {
  name                      = var.cosmosdb_name
  resource_group_name       = azurerm_resource_group.az_openai_rg.name
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
    for_each = var.cosmosdb_geo_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
    }
  }

  dynamic "capabilities" {
    for_each = var.cosmosdb_capabilities
    content {
      name = capabilities.value
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.cosmosdb_virtual_network_subnets != null ? var.cosmosdb_virtual_network_subnets : azurerm_subnet.az_openai_subnet.*.id
    content {
      id = virtual_network_rule.value
    }
  }

  is_virtual_network_filter_enabled = var.cosmosdb_is_virtual_network_filter_enabled
  public_network_access_enabled     = var.cosmosdb_public_network_access_enabled
}

### Save CosmosDB details to Key Vault for consumption by other services (e.g. LibreChat App)
resource "azurerm_key_vault_secret" "openai_cosmos_uri" {
  name         = "${var.cosmosdb_name}-cosmos-uri"
  value        = azurerm_cosmosdb_account.mongo.primary_mongodb_connection_string
  key_vault_id = azurerm_key_vault.az_openai_kv.id
}