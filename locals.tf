locals {
  ## locals config for keyvault firewall rules ##
  kv_net_rules = [
    {
      default_action             = var.keyvault_firewall_default_action
      bypass                     = var.keyvault_firewall_bypass
      ip_rules                   = var.keyvault_firewall_allowed_ips
      virtual_network_subnet_ids = var.keyvault_firewall_virtual_network_subnet_ids
    }
  ]
}