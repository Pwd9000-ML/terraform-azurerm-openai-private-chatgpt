resource "azurerm_resource_group" "az_openai_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}