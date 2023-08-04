##################################################
# CREATE OPENAI Service and Model Deployment     #
##################################################
# IMPORTANT: If existing service and model exist #
# set 'var.create_model_deployment' = false      #
# set 'var.create_openai_service' = false        #
##################################################

module "create_openai_service" {
  source = "./modules/openai_service"
  # Only deploy a new openai service 'var.create_openai_service' is true
  count                      = var.create_openai_service == true ? 1 : 0
  openai_resource_group_name = var.openai_resource_group_name
  location                   = var.location
  #   #virtual_network_name        = var.virtual_network_name
  #   #vnet_address_space          = var.vnet_address_space
  #   #subnet_config               = var.subnet_config
  #   #subnet_config_delegated_aci = var.subnet_config_delegated_aci
  #   #private_dns_zones           = var.private_dns_zones
  tags = var.tags
}

# module "create_model_deployment" {
#   source = "./modules/model_deployment"
#   # Only deploy new model if 'var.create_model_deployment' is true
#   #count                       = var.create_networking_prereqs == true ? 1 : 0
#   #network_resource_group_name = var.network_resource_group_name
#   #location                    = var.location
#   #virtual_network_name        = var.virtual_network_name
#   #vnet_address_space          = var.vnet_address_space
#   #subnet_config               = var.subnet_config
#   #subnet_config_delegated_aci = var.subnet_config_delegated_aci
#   #private_dns_zones           = var.private_dns_zones
#   #tags                        = var.tags
# }

