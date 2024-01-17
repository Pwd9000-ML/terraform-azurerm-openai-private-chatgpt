data "azurerm_subnet" "openai_subnet" {
  name                 = var.subnet_config.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

# data "azurerm_key_vault" "gpt" {
#   name                = local.kv_config.name
#   resource_group_name = azurerm_resource_group.rg.name
#   depends_on          = [module.private-chatgpt-openai.key_vault_id]
# }