output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongo.id
}

output "cosmosdb_account_endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongo.endpoint
}

output "cosmosdb_account_primary_master_key" {
  description = "The primary master key of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongo.primary_key
  sensitive   = true
}

output "cosmosdb_account_read_endpoints" {
  description = "The read endpoints of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongo.read_endpoints
}

output "cosmosdb_account_write_endpoints" {
  description = "The write endpoints of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongo.write_endpoints
}