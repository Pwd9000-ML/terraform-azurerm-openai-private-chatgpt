# #################################################
# # OUTPUTS                                       #
# #################################################
# ## OpenAI Service Account Details
# output "openai_endpoint" {
#   description = "The endpoint used to connect to the Cognitive Service Account."
#   value       = module.openai.openai_endpoint
# }

# output "openai_primary_key" {
#   description = "The primary access key for the Cognitive Service Account."
#   sensitive   = true
#   value       = module.openai.openai_primary_key
# }

# output "openai_secondary_key" {
#   description = "The secondary access key for the Cognitive Service Account."
#   sensitive   = true
#   value       = module.openai.openai_secondary_key
# }

# output "openai_subdomain" {
#   description = "The subdomain used to connect to the Cognitive Service Account."
#   value       = module.openai.openai_subdomain
# }

# output "openai_account_name" {
#   description = "The name of the Cognitive Service Account."
#   value       = module.openai.openai_account_name
# }

# ## key vault
# output "key_vault_id" {
#   description = "The ID of the Key Vault used to store OpenAI account and model details."
#   value       = module.openai.key_vault_id
# }

# output "key_vault_uri" {
#   description = "The URI of the Key Vault used to store OpenAI account and model details.."
#   value       = module.openai.key_vault_uri
# }

# ## Container App Enviornment
# #output "container_app_enviornment_id" {
# #  description = "The ID of the container app enviornment."
# #  value       = module.privategpt_chatbot_container_apps.container_app_environment_id
# #}

# ## Container App
# #output "container_app_id" {
# #  description = "The ID of the container app."
# #  value       = module.privategpt_chatbot_container_apps.container_app_id
# #}

# #output "latest_revision_fqdn" {
# #  description = "The FQDN of the Latest Revision of the Container App."
# #  value       = module.privategpt_chatbot_container_apps.latest_revision_fqdn
# #}

# #output "latest_revision_name" {
# #  description = "The Name of the Latest Revision of the Container App."
# #  value       = module.privategpt_chatbot_container_apps.latest_revision_name
# #}
