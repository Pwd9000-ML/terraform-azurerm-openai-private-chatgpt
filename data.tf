##################################################
# DATA                                           #
##################################################
data "azurerm_client_config" "current" {}

# Get OpenAI Service details
data "azurerm_automation_account" "openai" {
  count               = var.create_openai_service ? 0 : 1
  name                = var.openai_account_name
  resource_group_name = var.openai_resource_group_name
}