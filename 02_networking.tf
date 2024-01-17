resource "azurerm_virtual_network" "az_openai_vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Azure Virtual Network Subnets
resource "azurerm_subnet" "az_openai_subnet" {
  resource_group_name                           = azurerm_resource_group.az_openai_rg.name
  virtual_network_name                          = azurerm_virtual_network.az_openai_vnet.name
  name                                          = var.subnet_config.subnet_name
  address_prefixes                              = var.subnet_config.subnet_address_space
  service_endpoints                             = var.subnet_config.service_endpoints
  private_link_service_network_policies_enabled = var.subnet_config.private_link_service_network_policies_enabled
  private_endpoint_network_policies_enabled     = var.subnet_config.private_endpoint_network_policies_enabled

  dynamic "delegation" {
    for_each = var.subnet_config.subnets_delegation_settings
    content {
      name = delegation.key
      dynamic "service_delegation" {
        for_each = toset(delegation.value)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}
