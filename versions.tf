terraform {
  required_version = ">= 1.5.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.67.0"
    }
  }
}