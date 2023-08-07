#################################################
# OUTPUTS                                       #
#################################################
output "openai_endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account."
  value       = module.openai.openai_endpoint
}

output "openai_primary_key" {
  description = "The primary access key for the Cognitive Service Account."
  sensitive   = true
  value       = module.openai.openai_primary_key
}

output "openai_secondary_key" {
  description = "The secondary access key for the Cognitive Service Account."
  sensitive   = true
  value       = module.openai.openai_secondary_key
}

output "openai_subdomain" {
  description = "The subdomain used to connect to the Cognitive Service Account."
  value       = module.openai.openai_subdomain
}

output "openai_account_name" {
  description = "The name of the Cognitive Service Account."
  value       = module.openai.openai_account_name
}
