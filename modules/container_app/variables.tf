### common vars ###
variable "ca_resource_group_name" {
  type        = string
  description = "Name of the resource group to create the Container App and supporting solution resources in."
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

### log analytics workspace ###
variable "laws_name" {
  type        = string
  description = "Name of the log analytics workspace to create."
  default     = "gptlaws"
}

variable "laws_sku" {
  type        = string
  description = "SKU of the log analytics workspace to create."
  default     = "PerGB2018"
}

variable "laws_retention_in_days" {
  type        = number
  description = "Retention in days of the log analytics workspace to create."
  default     = 30
}

### container app environment ###
variable "cae_name" {
  type        = string
  description = "Name of the container app environment to create."
  default     = "gptcae"
}


### container app ###
variable "ca_name" {
  type        = string
  description = "Name of the container app to create."
  default     = "gptca"
}

variable "ca_revision_mode" {
  type        = string
  description = "Revision mode of the container app to create."
  default     = "Single"
}

variable "ca_identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default     = null
  description = <<-DESCRIPTION
    type = object({
      type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
      identity_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.
    })
  DESCRIPTION
}

variable "ca_ingress" {
  type = object({
    allow_insecure_connections = optional(bool)
    external_enabled           = optional(bool)
    target_port                = number
    transport                  = optional(string)
    traffic_weight = optional(object({
      percentage      = number
      latest_revision = optional(bool)
    }))
  })
  default = {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 3000
    transport                  = "auto"
    traffic_weight = {
      percentage      = 100
      latest_revision = true
    }
  }
  description = <<-DESCRIPTION
    type = object({
      allow_insecure_connections = (Optional) Allow insecure connections to the container app. Defaults to `false`.
      external_enabled           = (Optional) Enable external access to the container app. Defaults to `true`.
      target_port                = (Required) The port to use for the container app. Defaults to `3000`.
      transport                  = (Optional) The transport protocol to use for the container app. Defaults to `auto`.
      type = object({
        percentage      = (Required) The percentage of traffic to route to the container app. Defaults to `100`.
        latest_revision = (Optional) The percentage of traffic to route to the container app. Defaults to `true`.
      })
  DESCRIPTION
}

variable "ca_container_config" {
  type = object({
    name         = string
    image        = string
    cpu          = number
    memory       = string
    min_replicas = optional(number, 0)
    max_replicas = optional(number, 10)
    env = optional(list(object({
      name        = string
      secret_name = optional(string)
      value       = optional(string)
    })))
  })
  default = {
    name         = "gpt-chatbot-ui"
    image        = "ghcr.io/pwd9000-ml/chatbot-ui:main"
    cpu          = 1
    memory       = "2Gi"
    min_replicas = 0
    max_replicas = 10
    env          = []
  }
  description = <<-DESCRIPTION
    type = object({
      name                    = (Required) The name of the container.
      image                   = (Required) The name of the container image.
      cpu                     = (Required) The number of CPU cores to allocate to the container.
      memory                  = (Required) The amount of memory to allocate to the container in GB.
      min_replicas            = (Optional) The minimum number of replicas to run. Defaults to `0`.
      max_replicas            = (Optional) The maximum number of replicas to run. Defaults to `10`.
      env = list(object({
        name        = (Required) The name of the environment variable.
        secret_name = (Optional) The name of the secret to use for the environment variable.
        value       = (Optional) The value of the environment variable.
      }))
    })
  DESCRIPTION
}

variable "ca_secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "secret1"
      value = "value1"
    },
    {
      name  = "secret2"
      value = "value2"
    }
  ]
  description = <<-DESCRIPTION
    type = list(object({
      name  = (Required) The name of the secret.
      value = (Required) The value of the secret.
    }))
  DESCRIPTION  
}

### key vault access ###
variable "key_vault_access_permission" {
  type        = list(string)
  default     = ["Key Vault Secrets User"]
  description = "The permission to grant the container app to the key vault. Set this variable to `null` if no Key Vault access is needed. Defaults to `Key Vault Secrets User`."
}

variable "key_vault_id" {
  type        = string
  description = "(Required) - The id of the key vault to grant access to."
  default     = ""
}