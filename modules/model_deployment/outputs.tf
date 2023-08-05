output "model_deployment_id" {
  description = "The ID of the model deployment."
  value       = { for k, v in azurerm_cognitive_deployment.model : k => v.id }
}