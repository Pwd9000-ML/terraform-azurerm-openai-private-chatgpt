##################################################
# VARIABLES                                      #
##################################################
###Common###
variable "tags" {
  type = map(string)
  default = {
    Terraform   = "True"
    Description = "Private ChatGPT hosted on Azure OpenAI service."
    Author      = "Marcel Lupo"
    GitHub      = "https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt"
  }
  description = "A map of key value pairs that is used to tag resources created."
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Azure region to deploy resources to."
}

###Resource Group###
#variable "resource_group_name" {
#  type        = string
#  description = "Name of the resource group where resources will be hosted."
#  nullable    = false
#}

variable "openai_resource_group_name" {
  type        = string
  description = "Name of the resource group to create where the cognitive account OpenAI service is hosted."
  nullable    = false
}

##########################################
# Networking                             #
##########################################
