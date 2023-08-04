terraform {
  #backend "azurerm" {}
  backend "local" { path = "terraform-test1.tfstate" }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

#################################################
# PRE-REQS                                      #
#################################################
### Random integer to generate unique names
resource "random_integer" "number" {
  min = 0001
  max = 9999
}

### Resource group to deploy the container apps instance and supporting resources into
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

### Resource group to deploy the cognitive account openai service into
resource "azurerm_resource_group" "openai_rg" {
  name     = var.openai_resource_group_name
  location = var.location
  tags     = var.tags
}

##################################################
# MODULE TO TEST                                 #
##################################################
module "private-chatgpt-openai" {
  source = "../.."

  #Required
  resource_group_name        = azurerm_resource_group.rg.name
  openai_resource_group_name = azurerm_resource_group.openai_rg.name
  location                   = var.location
  tags                       = var.tags

  #Create OpenAI Service
  create_openai_service = true
}