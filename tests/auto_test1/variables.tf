variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create where container apps resources will be hosted for the private chatgpt service."
  nullable    = false
}

variable "openai_resource_group_name" {
  type        = string
  description = "Name of the resource group to create where the cognitive account OpenAI service is hosted."
  nullable    = false
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Azure region where resources will be hosted."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of key value pairs that is used to tag resources created."
}

# variable "virtual_network_name" {
#   type        = string
#   default     = null
#   description = "Name of the virtual network to create."
# }

# variable "vnet_address_space" {
#   type        = list(string)
#   default     = []
#   description = "value of the address space for the virtual network."
# }

# variable "subnet_config" {
#   type = list(object({
#     subnet_name                                   = string
#     subnet_address_space                          = list(string)
#     service_endpoints                             = list(string)
#     private_endpoint_network_policies_enabled     = bool
#     private_link_service_network_policies_enabled = bool
#   }))
#   default     = []
#   description = "A list of subnet configuration objects to create subnets in the virtual network."
# }

# variable "subnet_config_delegated_aci" {
#   type = list(object({
#     subnet_name                                   = string
#     subnet_address_space                          = list(string)
#     service_endpoints                             = list(string)
#     private_endpoint_network_policies_enabled     = bool
#     private_link_service_network_policies_enabled = bool
#     delegation_name                               = string
#     delegation_service                            = string
#     delegation_ations                             = list(string)
#   }))
#   default     = []
#   description = "A list of subnet configuration objects to create subnets in the virtual network. - delegated to ACI"
# }

# variable "private_dns_zones" {
#   type        = list(string)
#   default     = []
#   description = "Private DNS zones to create."
# }
