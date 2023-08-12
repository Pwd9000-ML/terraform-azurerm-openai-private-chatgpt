data "azurerm_key_vault" "gpt" {
  name                = var.kv_config.name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [module.private-chatgpt-openai.key_vault_id]
}