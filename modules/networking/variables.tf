variable "network_resource_group_name" {
  type        = string
  description = "Name of the resource group to where networking resources will be hosted."
  nullable    = false
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Azure region where resources will be hosted."
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = "True"
    Description = "OpenAI Private Networking Resource."
    Author      = "Marcel Lupo"
    GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
  }
  description = "A map of key value pairs that is used to tag resources created."
}

variable "virtual_network_name" {
  type        = string
  default     = "openai-vnet"
  description = "Name of the virtual network to create."
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.4.0.0/16"]
  description = "value of the address space for the virtual network."
}

variable "subnet_config" {
  type = list(object({
    subnet_name                                   = string
    subnet_address_space                          = list(string)
    service_endpoints                             = list(string)
    private_endpoint_network_policies_enabled     = bool
    private_link_service_network_policies_enabled = bool
    subnets_delegation_settings = map(list(object({
      name    = string
      actions = list(string)
    })))
  }))
  default = [
    {
      subnet_name                                   = "app-cosmos-sub"
      subnet_address_space                          = ["10.4.0.0/24"]
      service_endpoints                             = ["Microsoft.AzureCosmosDB", "Microsoft.Web"]
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
      subnets_delegation_settings = {
        app-service-plan = [
          {
            name    = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
          }
        ]
      }
    }
  ]
  description = "A list of subnet configuration objects to create subnets in the virtual network."
}