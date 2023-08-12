# Module: Azure Container App

Create a container app running ChatBot UI linked with OpenAI service hosted in Azure

- Create a container app log analytics workspace.
- Create a container app environment.
- Create a container app instance.
- Grant the container app access a the key vault for secret retrieval (optional).

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_app.gpt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |
| [azurerm_container_app_environment.gpt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_log_analytics_workspace.gpt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_role_assignment.kv_role_assigment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_container_config"></a> [ca\_container\_config](#input\_ca\_container\_config) | type = object({<br>  name                    = (Required) The name of the container.<br>  image                   = (Required) The name of the container image.<br>  cpu                     = (Required) The number of CPU cores to allocate to the container.<br>  memory                  = (Required) The amount of memory to allocate to the container in GB.<br>  min\_replicas            = (Optional) The minimum number of replicas to run. Defaults to `0`.<br>  max\_replicas            = (Optional) The maximum number of replicas to run. Defaults to `10`.<br>  env = list(object({<br>    name        = (Required) The name of the environment variable.<br>    secret\_name = (Optional) The name of the secret to use for the environment variable.<br>    value       = (Optional) The value of the environment variable.<br>  }))<br>}) | <pre>object({<br>    name         = string<br>    image        = string<br>    cpu          = number<br>    memory       = string<br>    min_replicas = optional(number, 0)<br>    max_replicas = optional(number, 10)<br>    env = optional(list(object({<br>      name        = string<br>      secret_name = optional(string)<br>      value       = optional(string)<br>    })))<br>  })</pre> | <pre>{<br>  "cpu": 1,<br>  "env": [],<br>  "image": "ghcr.io/pwd9000-ml/chatbot-ui:main",<br>  "max_replicas": 10,<br>  "memory": "2Gi",<br>  "min_replicas": 0,<br>  "name": "gpt-chatbot-ui"<br>}</pre> | no |
| <a name="input_ca_identity"></a> [ca\_identity](#input\_ca\_identity) | type = object({<br>  type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.<br>  identity\_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.<br>}) | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_ca_ingress"></a> [ca\_ingress](#input\_ca\_ingress) | type = object({<br>  allow\_insecure\_connections = (Optional) Allow insecure connections to the container app. Defaults to `false`.<br>  external\_enabled           = (Optional) Enable external access to the container app. Defaults to `true`.<br>  target\_port                = (Required) The port to use for the container app. Defaults to `3000`.<br>  transport                  = (Optional) The transport protocol to use for the container app. Defaults to `auto`.<br>  type = object({<br>    percentage      = (Required) The percentage of traffic to route to the container app. Defaults to `100`.<br>    latest\_revision = (Optional) The percentage of traffic to route to the container app. Defaults to `true`.<br>  }) | <pre>object({<br>    allow_insecure_connections = optional(bool)<br>    external_enabled           = optional(bool)<br>    target_port                = number<br>    transport                  = optional(string)<br>    traffic_weight = optional(object({<br>      percentage      = number<br>      latest_revision = optional(bool)<br>    }))<br>  })</pre> | <pre>{<br>  "allow_insecure_connections": false,<br>  "external_enabled": true,<br>  "target_port": 3000,<br>  "traffic_weight": {<br>    "latest_revision": true,<br>    "percentage": 100<br>  },<br>  "transport": "auto"<br>}</pre> | no |
| <a name="input_ca_name"></a> [ca\_name](#input\_ca\_name) | Name of the container app to create. | `string` | `"gptca"` | no |
| <a name="input_ca_resource_group_name"></a> [ca\_resource\_group\_name](#input\_ca\_resource\_group\_name) | Name of the resource group to create the Container App and supporting solution resources in. | `string` | n/a | yes |
| <a name="input_ca_revision_mode"></a> [ca\_revision\_mode](#input\_ca\_revision\_mode) | Revision mode of the container app to create. | `string` | `"Single"` | no |
| <a name="input_ca_secrets"></a> [ca\_secrets](#input\_ca\_secrets) | type = list(object({<br>  name  = (Required) The name of the secret.<br>  value = (Required) The value of the secret.<br>})) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "secret1",<br>    "value": "value1"<br>  },<br>  {<br>    "name": "secret2",<br>    "value": "value2"<br>  }<br>]</pre> | no |
| <a name="input_cae_name"></a> [cae\_name](#input\_cae\_name) | Name of the container app environment to create. | `string` | `"gptcae"` | no |
| <a name="input_key_vault_access_permission"></a> [key\_vault\_access\_permission](#input\_key\_vault\_access\_permission) | The permission to grant the container app to the key vault. Set this variable to `null` if no Key Vault access is needed. Defaults to `Key Vault Secrets User`. | `list(string)` | <pre>[<br>  "Key Vault Secrets User"<br>]</pre> | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | (Optional) - The id of the key vault to grant access to. Only required if `key_vault_access_permission` is set. | `string` | `""` | no |
| <a name="input_laws_name"></a> [laws\_name](#input\_laws\_name) | Name of the log analytics workspace to create. | `string` | `"gptlaws"` | no |
| <a name="input_laws_retention_in_days"></a> [laws\_retention\_in\_days](#input\_laws\_retention\_in\_days) | Retention in days of the log analytics workspace to create. | `number` | `30` | no |
| <a name="input_laws_sku"></a> [laws\_sku](#input\_laws\_sku) | SKU of the log analytics workspace to create. | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `"uksouth"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_app_environment_id"></a> [container\_app\_environment\_id](#output\_container\_app\_environment\_id) | The id of the container app environment. |
| <a name="output_container_app_id"></a> [container\_app\_id](#output\_container\_app\_id) | The id of the container app. |
| <a name="output_latest_revision_fqdn"></a> [latest\_revision\_fqdn](#output\_latest\_revision\_fqdn) | The FQDN of the latest revision of the container app. |
| <a name="output_latest_revision_name"></a> [latest\_revision\_name](#output\_latest\_revision\_name) | The name of the latest Container Revision. |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The id of the log analytics workspace. |
| <a name="output_outbound_ip_addresses"></a> [outbound\_ip\_addresses](#output\_outbound\_ip\_addresses) | A list of the Public IP Addresses which the Container App uses for outbound network access. |
<!-- END_TF_DOCS -->