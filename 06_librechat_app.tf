# LibreChat CREDS key (64 characters in hex) and 16-byte IV (32 characters in hex)
resource "random_password" "libre_app_creds_key" {
  length  = 64
  special = false
}

resource "random_password" "libre_app_creds_iv" {
  length  = 32
  special = false
}

resource "azurerm_key_vault_secret" "libre_app_creds_key" {
  name         = "${var.libre_app_name}-key"
  value        = random_password.libre_app_creds_key.result
  key_vault_id = azurerm_key_vault.az_openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

resource "azurerm_key_vault_secret" "libre_app_creds_iv" {
  name         = "${var.libre_app_name}-iv"
  value        = random_password.libre_app_creds_iv.result
  key_vault_id = azurerm_key_vault.az_openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

# LibreChat JWT Secret (64 characters in hex) and JWT Refresh Secret (64 characters in hex)
resource "random_password" "libre_app_jwt_secret" {
  length  = 64
  special = false
}

resource "random_password" "libre_app_jwt_refresh_secret" {
  length  = 64
  special = false
}

resource "azurerm_key_vault_secret" "libre_app_jwt_secret" {
  name         = "${var.libre_app_name}-jwt-secret"
  value        = random_password.libre_app_jwt_secret.result
  key_vault_id = azurerm_key_vault.az_openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

resource "azurerm_key_vault_secret" "libre_app_jwt_refresh_secret" {
  name         = "${var.libre_app_name}-jwt-refresh-secret"
  value        = random_password.libre_app_jwt_refresh_secret.result
  key_vault_id = azurerm_key_vault.az_openai_kv.id
  depends_on   = [azurerm_role_assignment.kv_role_assigment]
}

# Create app service plan for librechat app and meilisearch app
resource "azurerm_service_plan" "az_openai_asp" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = azurerm_resource_group.az_openai_rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku_name
}

#Create LibeChat App Service
resource "azurerm_linux_web_app" "librechat" {
  name                          = var.libre_app_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.az_openai_rg.name
  service_plan_id               = azurerm_service_plan.az_openai_asp.id
  public_network_access_enabled = var.libre_app_public_network_access_enabled
  https_only                    = true

  site_config {
    minimum_tls_version = "1.2"
    ip_restriction {
      virtual_network_subnet_id = var.libre_app_virtual_network_subnet_id != null ? var.libre_app_virtual_network_subnet_id : azurerm_subnet.az_openai_subnet.id
      priority                  = 100
      name                      = "Allow from LibreChat app subnet"
      action                    = "Allow"
    }

    ip_restriction {
      ipip_address = var.libre_app_allowed_ip_address
      priority     = 200
      name         = "The CIDR notation of the IP or IP Range to match to allow. For example: 10.0.0.0/24 or 192.168.10.1/32"
      action       = "Allow"
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    application_logs {
      file_system_level = "Information"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings              = local.libre_app_settings
  virtual_network_subnet_id = var.libre_app_virtual_network_subnet_id != null ? var.libre_app_virtual_network_subnet_id : azurerm_subnet.az_openai_subnet.id

  depends_on = [azurerm_subnet.az_openai_subnet]
}

# Grant kv access to librechat app to reference environment variables (stored as secrets in key vault)
resource "azurerm_role_assignment" "librechat_app_kv_access" {
  scope                = azurerm_key_vault.az_openai_kv.id
  principal_id         = azurerm_linux_web_app.librechat.identity[0].principal_id
  role_definition_name = "Key Vault Secrets User" # Read secret contents. Only works for key vaults that use the 'Azure role-based access control' permission model.
}

#Custom Domain / Certificates / Allowed IPs
# resource "azurerm_dns_zone" "dns-zone" {
#   name                = var.azure_dns_zone
#   resource_group_name = var.azure_resource_group_name
# }

# resource "azurerm_linux_web_app" "app-service" {
#   name                = "some-service"
#   resource_group_name = var.azure_resource_group_name
#   location            = var.azure_region
#   service_plan_id = "some-plan"
#   site_config {}
# }

# resource "azurerm_dns_txt_record" "domain-verification" {
#   name                = "asuid.api.domain.com"
#   zone_name           = var.azure_dns_zone
#   resource_group_name = var.azure_resource_group_name
#   ttl                 = 300

#   record {
#     value = azurerm_linux_web_app.app-service.custom_domain_verification_id
#   }
# }

# resource "azurerm_dns_cname_record" "cname-record" {
#   name                = "domain.com"
#   zone_name           = azurerm_dns_zone.dns-zone.name
#   resource_group_name = var.azure_resource_group_name
#   ttl                 = 300
#   record              = azurerm_linux_web_app.app-service.default_hostname

#   depends_on = [azurerm_dns_txt_record.domain-verification]
# }

#TODO:
# #  Deploy code from a public GitHub repo
# # resource "azurerm_app_service_source_control" "sourcecontrol" {
# #   app_id                 = azurerm_linux_web_app.librechat.id
# #   repo_url               = "https://github.com/danny-avila/LibreChat"
# #   branch                 = "main"    
# #   type = "Github"

# #   # use_manual_integration = true
# #   # use_mercurial          = false
# #   depends_on = [
# #     azurerm_linux_web_app.librechat,
# #   ]
# # }

# Implement a Search (either Meili or Azure AI Search)
# # Generate random strings as keys for meilisearch and librechat (Stored securely in Azure Key Vault)
# resource "random_string" "meilisearch_master_key" {
#   length  = 20
#   special = false
# }

# resource "azurerm_key_vault_secret" "meilisearch_master_key" {
#   name         = "${var.meilisearch_app_name}-master-key"
#   value        = random_string.meilisearch_master_key.result
#   key_vault_id = azurerm_key_vault.az_openai_kv.id
#   depends_on   = [azurerm_role_assignment.kv_role_assigment]
# }

# Create meilisearch app
# TODO: Add support for private endpoints instead of subnet access
# resource "azurerm_linux_web_app" "meilisearch" {
#   name                = var.meilisearch_app_name
#   location            = var.location
#   resource_group_name = azurerm_resource_group.az_openai_rg.name
#   service_plan_id     = azurerm_service_plan.az_openai_asp.id
#   https_only          = true

#   app_settings = {
#     WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

#     MEILI_MASTER_KEY   = var.meilisearch_app_key != null ? var.meilisearch_app_key : random_string.meilisearch_master_key.result #"@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.meilisearch_master_key.id})"
#     MEILI_NO_ANALYTICS = var.libre_app_disable_meilisearch_analytics

#     DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"
#     WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
#     DOCKER_ENABLE_CI                    = false
#     WEBSITES_PORT                       = 7700
#     PORT                                = 7700
#     DOCKER_CUSTOM_IMAGE_NAME            = "getmeili/meilisearch:latest"
#   }

#   site_config {
#     always_on = "true"
#     ip_restriction {
#       virtual_network_subnet_id = var.meilisearch_app_virtual_network_subnet_id != null ? var.meilisearch_app_virtual_network_subnet_id : azurerm_subnet.az_openai_subnet.id
#       priority                  = 100
#       name                      = "Allow from LibreChat app subnet"
#       action                    = "Allow"
#     }
#   }

#   logs {
#     http_logs {
#       file_system {
#         retention_in_days = 7
#         retention_in_mb   = 35
#       }
#     }
#     application_logs {
#       file_system_level = "Information"
#     }
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   depends_on = [azurerm_subnet.az_openai_subnet]
# }

# Grant kv access to meilisearch app to reference the master key secret
# resource "azurerm_role_assignment" "meilisearch_app_kv_access" {
#   scope                = azurerm_key_vault.az_openai_kv.id
#   principal_id         = azurerm_linux_web_app.meilisearch.identity[0].principal_id
#   role_definition_name = "Key Vault Secrets User" # Read secret contents. Only works for key vaults that use the 'Azure role-based access control' permission model.
# }