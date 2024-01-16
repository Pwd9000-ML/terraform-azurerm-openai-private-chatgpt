variable "app_resource_group_name" {
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
    Description = "OpenAI App Resource."
    Author      = "Marcel Lupo"
    GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
  }
  description = "A map of key value pairs that is used to tag resources created."
}

variable "app_service_name" {
  type        = string
  description = "Name of the App Service."
  default     = "openai-asp"
}

variable "app_service_sku_name" {
  type        = string
  description = "The SKU name of the App Service Plan."
  default     = "B1"
}

variable "app_name" {
  type        = string
  description = "Name of the App."
  default     = "openai-app"
}

##Pull from KV potentially
variable "app_title" {
  type        = string
  description = "Title of the App."
  default     = "PrivateGPT"
}

variable "mongodb_connection_string" {
  type        = string
  description = "Connection string to the MongoDB database."
  sensitive   = true
  default     = "value"
}

