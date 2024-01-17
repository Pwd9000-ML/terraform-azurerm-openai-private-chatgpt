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

variable "public_network_access_enabled " {
  type        = bool
  description = "Whether or not public network access is allowed for this App Service."
  default     = false
}

### App Settings ###
## Server Configuration ## 
variable "app_title" {
  type        = string
  description = "Title of the App."
  default     = "PrivateGPT"
}

variable "app_custom_footer" {
  type        = string
  description = "Custom footer for the App."
  default     = "Privately hosted chat app powered by Azure OpenAI"
}

variable "app_host" {
  type        = string
  description = "The server will listen to localhost:3080 by default. You can change the target IP as you want. If you want to make this server available externally, for example to share the server with others or expose this from a Docker container, set host to 0.0.0.0 or your external IP interface. Setting host to 0.0.0.0 means listening on all interfaces. It's not a real IP."
  default     = "0.0.0.0"
}

variable "app_port" {
  type        = number
  description = "The port to listen on."
  default     = 80
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this App Service."
  default     = false
}

###31
variable "mongodb_connection_string" {
  type        = string
  description = "Connection string to the MongoDB database."
  sensitive   = true
}

