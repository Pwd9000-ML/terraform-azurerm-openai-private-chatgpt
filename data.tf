##################################################
# DATA                                           #
##################################################

# Data sources to get Subnet ID/ss for CosmosDB and App Service
# Usage in Module example: subnet_id = data.azurerm_subnet.subnet["app-cosmos-sub"].id
data "azurerm_subnet" "subnet" {
  for_each             = { for each in var.subnet_config : each.subnet_name => each }
  name                 = each.value.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
}
