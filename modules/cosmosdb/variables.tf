variable "cosmosdb_name" {
  description = "The name of the Cosmos DB account"
  type        = string
  default     = "openaicosmosdb"
}

variable "cosmosdb_resource_group_name" {
  description = "The name of the resource group in which to create the Cosmos DB account"
  type        = string
  nullable    = false
}

variable "location" {
  description = "The location/region in which to create the Cosmos DB account"
  type        = string
  default     = "uksouth"
}

variable "cosmosdb_offer_type" {
  description = "The offer type to use for the Cosmos DB account"
  type        = string
  default     = "Standard"
}

variable "cosmosdb_kind" {
  description = "The kind of Cosmos DB to create"
  type        = string
  default     = "MongoDB"
}

variable "cosmosdb_automatic_failover" {
  description = "Whether to enable automatic failover for the Cosmos DB account"
  type        = bool
  default     = false
}

variable "use_cosmosdb_free_tier" {
  description = "Whether to enable the free tier for the Cosmos DB account. This needs to be false if another instance already uses free tier."
  type        = bool
  default     = true
}

variable "cosmosdb_consistency_level" {
  description = "The consistency level of the Cosmos DB account"
  type        = string
  default     = "BoundedStaleness"
}

variable "cosmosdb_max_interval_in_seconds" {
  description = "The maximum staleness interval in seconds for the Cosmos DB account"
  type        = number
  default     = 10
}

variable "cosmosdb_max_staleness_prefix" {
  description = "The maximum staleness prefix for the Cosmos DB account"
  type        = number
  default     = 200
}

variable "geo_locations" {
  description = "The geo-locations for the Cosmos DB account"
  type = list(object({
    location          = string
    failover_priority = number
  }))
  default = [
    {
      location          = "uksouth"
      failover_priority = 0
    }
  ]
}

variable "capabilities" {
  description = "The capabilities for the Cosmos DB account"
  type        = list(string)
  default = [
    "MongoDB"
  ]
}

variable "virtual_network_subnets" {
  description = "The virtual network subnet ID for the Cosmos DB account"
  type        = list(string)
  default     = []
}

variable "is_virtual_network_filter_enabled" {
  description = "Whether to enable virtual network filtering for the Cosmos DB account"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether to enable public network access for the Cosmos DB account"
  type        = bool
  default     = true
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = "True"
    Description = "OpenAI CosmosDB Resource."
    Author      = "Marcel Lupo"
    GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
  }
  description = "A map of key value pairs that is used to tag resources created."
}