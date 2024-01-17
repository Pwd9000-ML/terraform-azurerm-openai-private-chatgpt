#locals {
## locals config for key vault firewall rules ##
#   kv_net_rules = [
#     {
#       default_action             = var.keyvault_firewall_default_action
#       bypass                     = var.keyvault_firewall_bypass
#       ip_rules                   = var.keyvault_firewall_allowed_ips
#virtual_network_subnet_ids = azurerm_subnet.az_openai_subnet.*.id
#    }
#  ]
#}

#locals {
#  cdn_gpt_origin = merge(
#    var.cdn_gpt_origin,
#    {
#      host_name          = module.privategpt_chatbot_container_apps.latest_revision_fqdn
#      origin_host_header = module.privategpt_chatbot_container_apps.latest_revision_fqdn
#    }
#  )
#}