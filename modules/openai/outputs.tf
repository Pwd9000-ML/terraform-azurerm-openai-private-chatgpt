#################################################
# OUTPUTS                                       #
#################################################
### openai account outputs ###
output "openai_endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account."
  value       = var.create_openai_service ? module.create_openai_service[0].openai_endpoint : data.azurerm_cognitive_account.openai[0].endpoint
}

output "openai_primary_key" {
  description = "The primary access key for the Cognitive Service Account."
  sensitive   = true
  value       = var.create_openai_service ? module.create_openai_service[0].openai_primary_key : data.azurerm_cognitive_account.openai[0].primary_access_key
}

output "openai_secondary_key" {
  description = "The secondary access key for the Cognitive Service Account."
  sensitive   = true
  value       = var.create_openai_service ? module.create_openai_service[0].openai_secondary_key : data.azurerm_cognitive_account.openai[0].secondary_access_key
}

output "openai_subdomain" {
  description = "The subdomain used to connect to the Cognitive Service Account."
  value       = var.create_openai_service ? module.create_openai_service[0].openai_subdomain : var.openai_custom_subdomain_name
}

output "openai_account_name" {
  description = "The name of the Cognitive Service Account."
  value       = var.create_openai_service ? module.create_openai_service[0].openai_account_name : var.openai_account_name
}

output "openai_resource_group_name" {
  description = "The name of the Resource Group hosting the Cognitive Service Account."
  value       = var.create_openai_service ? module.create_openai_service[0].openai_resource_group_name : var.openai_resource_group_name
}

### key vault outputs ###
output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.openai_kv.id
}

output "key_vault_uri" {
  description = "The URI of the Key Vault."
  value       = azurerm_key_vault.openai_kv.vault_uri
}
