### common ###
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

### openai service ###
variable "create_openai_service" {
  type        = bool
  description = "Create the OpenAI service."
  default     = false
}

variable "openai_resource_group_name" {
  type        = string
  description = "Name of the resource group to create where the cognitive account OpenAI service is hosted."
  nullable    = false
}

variable "openai_account_name" {
  type        = string
  description = "Name of the OpenAI service."
  default     = "demo-account"
}

variable "openai_sku_name" {
  type        = string
  description = "SKU name of the OpenAI service."
  default     = "S0"
}

variable "openai_local_auth_enabled" {
  type        = bool
  default     = true
  description = "Whether local authentication methods is enabled for the Cognitive Account. Defaults to `true`."
}

variable "openai_outbound_network_access_restricted" {
  type        = bool
  default     = false
  description = "Whether or not outbound network access is restricted. Defaults to `false`."
}

variable "openai_public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether or not public network access is enabled. Defaults to `false`."
}

variable "openai_identity" {
  type = object({
    type = string
  })
  default = {
    type = "SystemAssigned"
  }
  description = <<-DESCRIPTION
    type = object({
      type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
      identity_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.
    })
  DESCRIPTION
}