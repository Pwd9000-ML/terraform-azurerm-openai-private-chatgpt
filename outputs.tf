# #################################################
# # OUTPUTS                                       #
# #################################################

# Network Details
output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.az_openai_vnet.id
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.az_openai_vnet.name
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.az_openai_subnet.id
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.az_openai_subnet.name
}

# Key Vault Details
output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.az_openai_kv.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.az_openai_kv.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.az_openai_kv.vault_uri
}

# OPENAI Details
output "openai_endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account."
  value       = azurerm_cognitive_account.az_openai.endpoint
}

output "openai_primary_key" {
  description = "The primary access key for the Cognitive Service Account."
  sensitive   = true
  value       = azurerm_cognitive_account.az_openai.primary_access_key
}

output "openai_secondary_key" {
  description = "The secondary access key for the Cognitive Service Account."
  sensitive   = true
  value       = azurerm_cognitive_account.az_openai.secondary_access_key
}

output "openai_subdomain" {
  description = "The subdomain used to connect to the Cognitive Service Account."
  value       = azurerm_cognitive_account.az_openai.custom_subdomain_name
}

output "cognitive_deployment_ids" {
  description = "The IDs of the OpenAI Cognitive Account Model Deployments"
  value       = { for key, deployment in azurerm_cognitive_deployment.az_openai_models : key => deployment.id }
}

output "cognitive_deployment_names" {
  description = "The names of the OpenAI Cognitive Account Model Deployments"
  value       = { for key, deployment in azurerm_cognitive_deployment.az_openai_models : key => deployment.name }
}

# CosmosDB Details
output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.az_openai_mongodb.id
}

output "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.az_openai_mongodb.name
}

output "cosmosdb_account_endpoint" {
  description = "The endpoint used to connect to the Cosmos DB account"
  value       = azurerm_cosmosdb_account.az_openai_mongodb.endpoint
}

output "cosmosdb_account_primary_key" {
  description = "The primary master key for the Cosmos DB account"
  sensitive   = true
  value       = azurerm_cosmosdb_account.az_openai_mongodb.primary_key
}

output "cosmosdb_account_secondary_key" {
  description = "The secondary master key for the Cosmos DB account"
  sensitive   = true
  value       = azurerm_cosmosdb_account.az_openai_mongodb.secondary_key
}

# App Service Details
output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.az_openai_asp.id
}

output "app_service_plan_name" {
  description = "The name of the App Service Plan"
  value       = azurerm_service_plan.az_openai_asp.name
}

output "app_service_id" {
  description = "The ID of the App Service"
  value       = azurerm_linux_web_app.librechat.id
}

output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_linux_web_app.librechat.name
}

output "app_service_default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_linux_web_app.librechat.default_hostname
}

output "app_service_outbound_ip_addresses" {
  description = "The outbound IP addresses of the App Service"
  value       = azurerm_linux_web_app.librechat.outbound_ip_addresses
}
