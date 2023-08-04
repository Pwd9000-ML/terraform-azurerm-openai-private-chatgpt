resource_group_name        = "Terraform-Private-ChatGPT"
openai_resource_group_name = "Terraform-Cognitive-Service"
location                   = "uksouth"
tags = {
  Terraform   = "True"
  Description = "Cogntive Service for Private ChatGPT - OpenAI"
  Author      = "Marcel Lupo"
  GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
}

#virtual_network_name          = "sonarqube-vnet"
#vnet_address_space            = ["10.1.0.0/16"]

# subnet_config = [
#   {
#     subnet_name                                   = "sonarqube-resource-sub"
#     subnet_address_space                          = ["10.1.0.0/24"]
#     service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
#     private_endpoint_network_policies_enabled     = false
#     private_link_service_network_policies_enabled = false
#   }
# ]

# subnet_config_delegated_aci = [
#   {
#     subnet_name                                   = "sonarqube-delegated-sub"
#     subnet_address_space                          = ["10.1.1.0/24"]
#     service_endpoints                             = []
#     private_endpoint_network_policies_enabled     = false
#     private_link_service_network_policies_enabled = false
#     delegation_name                               = "aci-sub-delegation"
#     delegation_service                            = "Microsoft.ContainerInstance/containerGroups"
#     delegation_ations                             = ["Microsoft.Network/virtualNetworks/subnets/action"]
#   }
# ]

# private_dns_zones = [
#   "privatelink.vaultcore.azure.net",
#   "privatelink.file.core.windows.net",
#   "privatelink.database.windows.net",
#   "pwd9000.local"
# ]

