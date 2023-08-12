# Private ChatGPT instance only (No AFD WAF / custom DNS integration)

This example will create a Privately hosted instance of ChatBot/ChatGPT on Azure OpenAI only. This example will create the following:

## Prerequisites

- Create a resource group to deploy all resources for the solution.  

## Create OpenAI Service

1. Create an Azure Key Vault to store the OpenAI account details.
2. Create an OpenAI service account.  
    Other options include:
    - Specify an already existing OpenAI service account to use.

3. Create OpenAI language model deployments on the OpenAI service. (e.g. GPT-3, GPT-4, etc.)
4. Store the OpenAI account and model details in the key vault for consumption.

## Create a container app ChatBot UI linked with OpenAI service hosted in Azure

1. Create a container app log analytics workspace (to link with container app).
2. Create a container app environment.
3. Create a container app instance hosting chatbot-ui from image/container.
4. Link chatbot-ui with corresponding OpenAI account and language model deployment.
5. Grant the container app access to the key vault to retrieve secrets (optional).

## Front solution with an Azure front door (optional)

- No Front Door solution is created in this example.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private-chatgpt-openai"></a> [private-chatgpt-openai](#module\_private-chatgpt-openai) | Pwd9000-ML/openai-private-chatgpt/azurerm | >= 1.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_key_vault.gpt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_container_config"></a> [ca\_container\_config](#input\_ca\_container\_config) | type = object({<br>  name                    = (Required) The name of the container.<br>  image                   = (Required) The name of the container image.<br>  cpu                     = (Required) The number of CPU cores to allocate to the container.<br>  memory                  = (Required) The amount of memory to allocate to the container in GB.<br>  min\_replicas            = (Optional) The minimum number of replicas to run. Defaults to `0`.<br>  max\_replicas            = (Optional) The maximum number of replicas to run. Defaults to `10`.<br>  env = list(object({<br>    name        = (Required) The name of the environment variable.<br>    secret\_name = (Optional) The name of the secret to use for the environment variable.<br>    value       = (Optional) The value of the environment variable.<br>  }))<br>}) | <pre>object({<br>    name         = string<br>    image        = string<br>    cpu          = number<br>    memory       = string<br>    min_replicas = optional(number, 0)<br>    max_replicas = optional(number, 10)<br>    env = optional(list(object({<br>      name        = string<br>      secret_name = optional(string)<br>      value       = optional(string)<br>    })))<br>  })</pre> | <pre>{<br>  "cpu": 1,<br>  "env": [],<br>  "image": "ghcr.io/pwd9000-ml/chatbot-ui:main",<br>  "max_replicas": 10,<br>  "memory": "2Gi",<br>  "min_replicas": 0,<br>  "name": "gpt-chatbot-ui"<br>}</pre> | no |
| <a name="input_ca_identity"></a> [ca\_identity](#input\_ca\_identity) | type = object({<br>  type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.<br>  identity\_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.<br>}) | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_ca_ingress"></a> [ca\_ingress](#input\_ca\_ingress) | type = object({<br>  allow\_insecure\_connections = (Optional) Allow insecure connections to the container app. Defaults to `false`.<br>  external\_enabled           = (Optional) Enable external access to the container app. Defaults to `true`.<br>  target\_port                = (Required) The port to use for the container app. Defaults to `3000`.<br>  transport                  = (Optional) The transport protocol to use for the container app. Defaults to `auto`.<br>  type = object({<br>    percentage      = (Required) The percentage of traffic to route to the container app. Defaults to `100`.<br>    latest\_revision = (Optional) The percentage of traffic to route to the container app. Defaults to `true`.<br>  }) | <pre>object({<br>    allow_insecure_connections = optional(bool)<br>    external_enabled           = optional(bool)<br>    target_port                = number<br>    transport                  = optional(string)<br>    traffic_weight = optional(object({<br>      percentage      = number<br>      latest_revision = optional(bool)<br>    }))<br>  })</pre> | <pre>{<br>  "allow_insecure_connections": false,<br>  "external_enabled": true,<br>  "target_port": 3000,<br>  "traffic_weight": {<br>    "latest_revision": true,<br>    "percentage": 100<br>  },<br>  "transport": "auto"<br>}</pre> | no |
| <a name="input_ca_name"></a> [ca\_name](#input\_ca\_name) | Name of the container app to create. | `string` | `"gptca"` | no |
| <a name="input_ca_revision_mode"></a> [ca\_revision\_mode](#input\_ca\_revision\_mode) | Revision mode of the container app to create. | `string` | `"Single"` | no |
| <a name="input_ca_secrets"></a> [ca\_secrets](#input\_ca\_secrets) | type = list(object({<br>  name  = (Required) The name of the secret.<br>  value = (Required) The value of the secret.<br>})) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "secret1",<br>    "value": "value1"<br>  },<br>  {<br>    "name": "secret2",<br>    "value": "value2"<br>  }<br>]</pre> | no |
| <a name="input_cae_name"></a> [cae\_name](#input\_cae\_name) | Name of the container app environment to create. | `string` | `"gptcae"` | no |
| <a name="input_create_front_door_cdn"></a> [create\_front\_door\_cdn](#input\_create\_front\_door\_cdn) | Create a Front Door profile. | `bool` | `false` | no |
| <a name="input_create_model_deployment"></a> [create\_model\_deployment](#input\_create\_model\_deployment) | Create the model deployment. | `bool` | `false` | no |
| <a name="input_create_openai_service"></a> [create\_openai\_service](#input\_create\_openai\_service) | Create the OpenAI service. | `bool` | `false` | no |
| <a name="input_key_vault_access_permission"></a> [key\_vault\_access\_permission](#input\_key\_vault\_access\_permission) | The permission to grant the container app to the key vault. Set this variable to `null` if no Key Vault access is needed. Defaults to `Key Vault Secrets User`. | `list(string)` | <pre>[<br>  "Key Vault Secrets User"<br>]</pre> | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | (Optional) - The id of the key vault to grant access to. Only required if `key_vault_access_permission` is set. | `string` | `""` | no |
| <a name="input_keyvault_firewall_allowed_ips"></a> [keyvault\_firewall\_allowed\_ips](#input\_keyvault\_firewall\_allowed\_ips) | value of keyvault firewall allowed ip rules. | `list(string)` | `[]` | no |
| <a name="input_keyvault_firewall_bypass"></a> [keyvault\_firewall\_bypass](#input\_keyvault\_firewall\_bypass) | List of keyvault firewall rules to bypass. | `string` | `"AzureServices"` | no |
| <a name="input_keyvault_firewall_default_action"></a> [keyvault\_firewall\_default\_action](#input\_keyvault\_firewall\_default\_action) | Default action for keyvault firewall rules. | `string` | `"Deny"` | no |
| <a name="input_keyvault_firewall_virtual_network_subnet_ids"></a> [keyvault\_firewall\_virtual\_network\_subnet\_ids](#input\_keyvault\_firewall\_virtual\_network\_subnet\_ids) | value of keyvault firewall allowed virtual network subnet ids. | `list(string)` | `[]` | no |
| <a name="input_kv_config"></a> [kv\_config](#input\_kv\_config) | Key Vault configuration object to create azure key vault to store openai account details. | <pre>object({<br>    name = string<br>    sku  = string<br>  })</pre> | <pre>{<br>  "name": "gptkv",<br>  "sku": "standard"<br>}</pre> | no |
| <a name="input_laws_name"></a> [laws\_name](#input\_laws\_name) | Name of the log analytics workspace to create. | `string` | `"gptlaws"` | no |
| <a name="input_laws_retention_in_days"></a> [laws\_retention\_in\_days](#input\_laws\_retention\_in\_days) | Retention in days of the log analytics workspace to create. | `number` | `30` | no |
| <a name="input_laws_sku"></a> [laws\_sku](#input\_laws\_sku) | SKU of the log analytics workspace to create. | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `"uksouth"` | no |
| <a name="input_model_deployment"></a> [model\_deployment](#input\_model\_deployment) | type = list(object({<br>  deployment\_id   = (Required) The name of the Cognitive Services Account `Model Deployment`. Changing this forces a new resource to be created.<br>  model\_name = {<br>    model\_format  = (Required) The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is OpenAI.<br>    model\_name    = (Required) The name of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created.<br>    model\_version = (Required) The version of Cognitive Services Account Deployment model.<br>  }<br>  scale = {<br>    scale\_type     = (Required) Deployment scale type. Possible value is Standard. Changing this forces a new resource to be created.<br>    scale\_tier     = (Optional) Possible values are Free, Basic, Standard, Premium, Enterprise. Changing this forces a new resource to be created.<br>    scale\_size     = (Optional) The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. Changing this forces a new resource to be created.<br>    scale\_family   = (Optional) If the service has different generations of hardware, for the same SKU, then that can be captured here. Changing this forces a new resource to be created.<br>    scale\_capacity = (Optional) Tokens-per-Minute (TPM). If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. Default value is 1. Changing this forces a new resource to be created.<br>  }<br>  rai\_policy\_name = (Optional) The name of RAI policy. Changing this forces a new resource to be created.<br>})) | <pre>list(object({<br>    deployment_id   = string<br>    model_name      = string<br>    model_format    = string<br>    model_version   = string<br>    scale_type      = string<br>    scale_tier      = optional(string)<br>    scale_size      = optional(number)<br>    scale_family    = optional(string)<br>    scale_capacity  = optional(number)<br>    rai_policy_name = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_openai_account_name"></a> [openai\_account\_name](#input\_openai\_account\_name) | Name of the OpenAI service. | `string` | `"demo-account"` | no |
| <a name="input_openai_custom_subdomain_name"></a> [openai\_custom\_subdomain\_name](#input\_openai\_custom\_subdomain\_name) | The subdomain name used for token-based authentication. Changing this forces a new resource to be created. (normally the same as the account name) | `string` | `"demo-account"` | no |
| <a name="input_openai_identity"></a> [openai\_identity](#input\_openai\_identity) | type = object({<br>  type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.<br>  identity\_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.<br>}) | <pre>object({<br>    type = string<br>  })</pre> | <pre>{<br>  "type": "SystemAssigned"<br>}</pre> | no |
| <a name="input_openai_local_auth_enabled"></a> [openai\_local\_auth\_enabled](#input\_openai\_local\_auth\_enabled) | Whether local authentication methods is enabled for the Cognitive Account. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_openai_outbound_network_access_restricted"></a> [openai\_outbound\_network\_access\_restricted](#input\_openai\_outbound\_network\_access\_restricted) | Whether or not outbound network access is restricted. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_openai_public_network_access_enabled"></a> [openai\_public\_network\_access\_enabled](#input\_openai\_public\_network\_access\_enabled) | Whether or not public network access is enabled. Defaults to `false`. | `bool` | `true` | no |
| <a name="input_openai_sku_name"></a> [openai\_sku\_name](#input\_openai\_sku\_name) | SKU name of the OpenAI service. | `string` | `"S0"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to create where the cognitive account OpenAI service is hosted. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
