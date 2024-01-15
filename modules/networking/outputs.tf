output "virtual_network_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "The IDs of the Subnets"
  value       = { for each in azurerm_subnet.subnet : each.name => each.id }
}