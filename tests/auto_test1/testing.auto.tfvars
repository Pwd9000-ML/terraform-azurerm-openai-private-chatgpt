### Common Variables ###
location = "uksouth"
tags = {
  Terraform   = "True"
  Description = "Private ChatGPT - OpenAI"
  Author      = "Marcel Lupo"
  GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
}

### Create OpenAI Service ###
create_openai_service                     = true
openai_resource_group_name                = "Terraform-Cognitive-Services"
openai_service_name                       = "pwd9000"
openai_sku_name                           = "S0"
openai_local_auth_enabled                 = true
openai_outbound_network_access_restricted = false
openai_public_network_access_enabled      = false
openai_identity = {
  type = "SystemAssigned"
}