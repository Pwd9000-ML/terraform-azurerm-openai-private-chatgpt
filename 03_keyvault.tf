# Key Vault - Create Key Vault to save cognitive account, cosmosDB, App details
resource "azurerm_key_vault" "az_openai_kv" {
  resource_group_name = azurerm_resource_group.az_openai_rg.name
  location            = var.location
  #values from variable kv_config object
  name                      = lower(var.kv_name)
  sku_name                  = var.kv_sku
  enable_rbac_authorization = true
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  network_acls {
    default_action             = var.kv_fw_default_action
    bypass                     = var.kv_fw_bypass
    ip_rules                   = var.kv_fw_allowed_ips
    virtual_network_subnet_ids = azurerm_subnet.az_openai_subnet.*.id
  }
  tags       = var.tags
  depends_on = [azurerm_subnet.az_openai_subnet]
}


# Add "self" permission to key vault RBAC (to manange key vault secrets)
resource "azurerm_role_assignment" "kv_role_assigment" {
  for_each             = toset(["Key Vault Administrator"])
  role_definition_name = each.key
  scope                = azurerm_key_vault.az_openai_kv.id
  principal_id         = data.azurerm_client_config.current.object_id
}