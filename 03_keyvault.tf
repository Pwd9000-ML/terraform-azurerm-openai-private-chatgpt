# Key Vault - Create Key Vault to save cognitive account details
resource "azurerm_key_vault" "az_openai_kv" {
  resource_group_name = var.resource_group_name
  location            = var.location
  #values from variable kv_config object
  name                      = lower(var.kv_name)
  sku_name                  = var.kv_sku
  enable_rbac_authorization = true
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  dynamic "network_acls" {
    for_each = var.kv_net_rules
    content {
      default_action             = network_acls.value.default_action
      bypass                     = network_acls.value.bypass
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
  tags = var.tags
}

# Add "self" permission to key vault RBAC (to manange key vault secrets)
resource "azurerm_role_assignment" "kv_role_assigment" {
  for_each             = toset(["Key Vault Administrator"])
  role_definition_name = each.key
  scope                = azurerm_key_vault.openai_kv.id
  principal_id         = data.azurerm_client_config.current.object_id
}