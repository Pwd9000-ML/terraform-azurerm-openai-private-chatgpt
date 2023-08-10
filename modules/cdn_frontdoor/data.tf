##################################################
# DATA                                           #
##################################################
# Get DNS Zone ID if custom DNS zone already exists
data "azurerm_dns_zone" "gpt" {
  count               = var.create_dns_zone ? 0 : 1
  name                = var.custom_domain_config.zone_name
  resource_group_name = var.resource_group_name
}