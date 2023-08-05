output "openai_endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account."
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_primary_key" {
  description = "The primary access key for the Cognitive Service Account."
  sensitive   = true
  value       = azurerm_cognitive_account.openai.primary_access_key
}

output "openai_secondary_key" {
  description = "The secondary access key for the Cognitive Service Account."
  sensitive   = true
  value       = azurerm_cognitive_account.openai.secondary_access_key
}

output "openai_subdomain" {
  description = "The subdomain used to connect to the Cognitive Service Account."
  value       = azurerm_cognitive_account.openai.custom_subdomain_name
}

output "openai_account_name" {
  description = "The name of the Cognitive Service Account."
  value       = var.account_name
}

output "openai_resource_group_name" {
  description = "The name of the Resource Group hosting the Cognitive Service Account."
  value       = var.resource_group_name
}