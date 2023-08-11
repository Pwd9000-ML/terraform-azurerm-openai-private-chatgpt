output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.gpt.id
  description = "The id of the log analytics workspace."
}

output "container_app_environment_id" {
  value       = azurerm_container_app_environment.gpt.id
  description = "The id of the container app environment."
}

output "container_app_id" {
  value       = azurerm_container_app.gpt.id
  description = "The id of the container app."
}

output "latest_revision_name" {
  value       = azurerm_container_app.gpt.latest_revision_name
  description = "The name of the latest Container Revision."
}

output "latest_revision_fqdn" {
  value       = azurerm_container_app.gpt.latest_revision_fqdn
  description = "The FQDN of the latest revision of the container app."
}

output "outbound_ip_addresses" {
  value       = azurerm_container_app.gpt.outbound_ip_addresses
  description = "A list of the Public IP Addresses which the Container App uses for outbound network access."
}