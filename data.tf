##################################################
# DATA                                           #
##################################################
data "azurerm_client_config" "current" {}

# data "azurerm_subnet" "openai_subnet" {
#   name                 = var.subnet_config.subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name  = var.resource_group_name
#   depends_on           = [azurerm_subnet.az_openai_subnet]
# }

# Data sources to get Subnet ID/s for CosmosDB and App Service
# Usage in Module example: subnet_id = data.azurerm_subnet.subnet["app-cosmos-sub"].id
# data "azurerm_subnet" "subnet" {
#   for_each             = { for each in var.subnet_config : each.subnet_name => each if var.create_openai_networking == false }
#   name                 = each.value.subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name  = var.network_resource_group_name
# }

# data "azurerm_cosmosdb_account" "mongo" {
#   for_each            = { for each in var.cosmosdb_name : each.value => each if var.create_cosmosdb == false }
#   name                = each.value
#   resource_group_name = var.cosmosdb_resource_group_name
# }