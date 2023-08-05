##########################
### Solution resources ###
##########################
# Key Vault
#Create Key Vault with RBAC model (To save cognitive account details )
resource "azurerm_key_vault" "openai_kv" {
  resource_group_name = var.resource_group_name
  location            = var.location
  #values from variable kv_config object
  name                      = lower(var.kv_config.name)
  sku_name                  = var.kv_config.sku
  enable_rbac_authorization = var.kv_config.enable_rbac_authorization
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  dynamic "network_acls" {
    for_each = local.kv_net_rules
    content {
      default_action             = network_acls.value.default_action
      bypass                     = network_acls.value.bypass
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
  tags = var.tags
}

#Add "self" permission to key vault RBAC
resource "azurerm_role_assignment" "kv_role_assigment" {
  for_each             = toset(["Key Vault Administrator"])
  role_definition_name = each.key
  scope                = azurerm_key_vault.openai_kv.id
  principal_id         = data.azurerm_client_config.current.object_id
}


##################################################
# CREATE OPENAI Service and Model Deployment     #
##################################################
# IMPORTANT: If existing service and model exist #
# set 'var.create_model_deployment' = false      #
# set 'var.create_openai_service' = false        #
##################################################

### OpenAI Service
module "create_openai_service" {
  source = "./modules/openai_service"
  # Only deploy a new openai service 'var.create_openai_service' is true
  count                              = var.create_openai_service == true ? 1 : 0
  resource_group_name                = var.openai_resource_group_name
  location                           = var.location
  account_name                       = var.openai_account_name
  sku_name                           = var.openai_sku_name
  custom_subdomain_name              = var.openai_custom_subdomain_name
  dynamic_throttling_enabled         = var.openai_dynamic_throttling_enabled
  fqdns                              = var.openai_fqdns
  local_auth_enabled                 = var.openai_local_auth_enabled
  outbound_network_access_restricted = var.openai_outbound_network_access_restricted
  public_network_access_enabled      = var.openai_public_network_access_enabled
  customer_managed_key               = var.openai_customer_managed_key
  identity                           = var.openai_identity
  network_acls                       = var.openai_network_acls
  storage                            = var.openai_storage
  tags                               = var.tags
}

### Model Deployment
# module "create_model_deployment" {
#   source = "./modules/model_deployment"
#   # Only deploy new model if 'var.create_model_deployment' is true
#   #count                       = var.create_networking_prereqs == true ? 1 : 0
#   #network_resource_group_name = var.network_resource_group_name
#   #location                    = var.location
#   #virtual_network_name        = var.virtual_network_name
#   #vnet_address_space          = var.vnet_address_space
#   #subnet_config               = var.subnet_config
#   #subnet_config_delegated_aci = var.subnet_config_delegated_aci
#   #private_dns_zones           = var.private_dns_zones
#   #tags                        = var.tags
# }

### Save OpenAI Cognitive Account details to Key Vault
resource "azurerm_key_vault_secret" "openai_endpoint" {
  name         = "${var.openai_account_name}-openai-endpoint"
  value        = var.create_openai_service == true ? module.create_openai_service[0].openai_endpoint : data.azurerm_automation_account.openai[0].endpoint
  key_vault_id = azurerm_key_vault.openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

resource "azurerm_key_vault_secret" "openai_primary_key" {
  name         = "${var.openai_account_name}-openai-key"
  value        = var.create_openai_service == true ? module.create_openai_service[0].openai_primary_key : data.azurerm_automation_account.openai[0].primary_key
  key_vault_id = azurerm_key_vault.openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}
