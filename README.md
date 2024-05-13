[![Manual-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/actions/workflows/manual-test-release.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/actions/workflows/manual-test-release.yml) [![Automated-Dependency-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/actions/workflows/dependency-tests.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/actions/workflows/dependency-tests.yml) [![Dependabot](https://badgen.net/badge/Dependabot/enabled/green?icon=dependabot)](https://dependabot.com/)

# Module: Azure OpenAI Private ChatGPT

## Current Version 2.x

Version **2.x** a complete rewrite of the module and is not backwards compatible with version **1.x.**  
New integrations and features have been added to the module to use the latest **Azure OpenAI** services and features such as `GPT-4-1106`, `GPT-4-Vision` and `DALL-E-3`. A new ChatBot UI / [LibreChat](https://docs.librechat.ai/index.html) has been added to the module to provide a complete solution.  

[![LIBRE](https://img.youtube.com/vi/pNIOs1ovsXw/0.jpg)](https://www.youtube.com/watch?v=pNIOs1ovsXw)  

## Coming next - Feature development

### v2.4.x

- [ ] Privatise solution with Private endpoint support
- [ ] Front Door and WAF support for public entrypoint
- [ ] Azure AI Search/MeiliSearch Integration
- [ ] Add additional support for [Azure OpenAI DALL-E-3](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#dall-e-models-preview)

### v2.3.x

- [x] Dependency updates and tests

### v2.2.x

- [x] Added User Violations Support
- [x] Updated documentation and examples
- [x] Added module outputs

### v2.1.x

- [x] Custom domain support with managed certificates

## Legacy Version 1.x

**NOTE:** Legacy version **1.x** can be found in the legacy branch **[here](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/tree/legacy-v1)**  

**[Version 1.x Documentation](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/blob/legacy-v1/README.md)**  

## Introduction

Under **OpenAI's** terms when using the public version of **ChatGPT**, any questions you pose—referred to as **"prompts"**—may contribute to the further training of OpenAI's Large Language Model (LLM). Given this, it's crucial to ask: Are you comfortable with this precious data flow leaving your organization? If you're a decision-maker or hold responsibility over your organization's security measures, what steps are you taking to ensure proprietary information remains confidential?  

An effective solution lies in utilising a hosted version of the popular LLM on **Azure OpenAI**. While there are numerous advantages to Azure OpenAI, I'd like to spotlight two:

- **Data Privacy**: By hosting OpenAI's models on Azure, your prompts will never serve as a source for training the LLM. It's simply a self-contained version running on Azure tailored for your use.

- **Enhanced Security**: Azure OpenAI offers robust security measures, from the capability to secure specific endpoints to intricate role-based access controls.
For a deeper dive, refer to this [Microsoft Learn article](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview).  

While Azure OpenAI does come with a cost, it's highly affordable—often, a conversation costs under 10 cents. You can review Azure [OpenAI's pricing](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/) details here.

## Diagram

coming soon...

## Examples

- [Public Deployment with Custom Domain and IP Whitelisting](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/tree/master/examples/public_deployment_with_custom_domain)

## Screens

### Model Selection

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/master/assets/demo1.png)  

### Presets

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/master/assets/presets1.png)

### Vision analysis

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/master/assets/vision1.png)

## Contributing

Contributions are welcome. Please submit a pull request if you have any improvements or fixes. Make sure to follow the existing code style and add comments to your code explaining what it does.  

## License

This terraform module is licensed under the MIT License. See the LICENSE file for more details.  

## Support

If you encounter any issues or have any questions about this terraform module, please open an issue on GitHub. We'll do our best to respond as quickly as possible.  

## Acknowledgements

This terraform module was developed by **Marcel Lupo** as part of a project to explore the capabilities of Azure OpenAI models. We'd like to thank the OpenAI and Microsoft team for their incredible work and ongoing support of the AI community. 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.102.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.102.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_certificate_binding.libre_app_cert_binding](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.hostname_binding](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_managed_certificate.libre_app_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_managed_certificate) | resource |
| [azurerm_cognitive_account.az_openai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) | resource |
| [azurerm_cognitive_deployment.az_openai_models](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_deployment) | resource |
| [azurerm_cosmosdb_account.az_openai_mongodb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_dns_cname_record.cname_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_txt_record.domain_verification](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |
| [azurerm_key_vault.az_openai_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.libre_app_creds_iv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.libre_app_creds_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.libre_app_jwt_refresh_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.libre_app_jwt_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.openai_cosmos_uri](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.openai_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.openai_primary_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_web_app.librechat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_resource_group.az_openai_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.kv_role_assigment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.librechat_app_kv_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.az_openai_asp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_subnet.az_openai_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.az_openai_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_password.libre_app_creds_iv](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.libre_app_creds_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.libre_app_jwt_refresh_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.libre_app_jwt_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_name"></a> [app\_service\_name](#input\_app\_service\_name) | Name of the Linux App Service Plan. | `string` | `"openaiasp9000"` | no |
| <a name="input_app_service_sku_name"></a> [app\_service\_sku\_name](#input\_app\_service\_sku\_name) | The SKU name of the App Service Plan. | `string` | `"B1"` | no |
| <a name="input_cosmosdb_automatic_failover"></a> [cosmosdb\_automatic\_failover](#input\_cosmosdb\_automatic\_failover) | Whether to enable automatic failover for the Cosmos DB account | `bool` | `false` | no |
| <a name="input_cosmosdb_capabilities"></a> [cosmosdb\_capabilities](#input\_cosmosdb\_capabilities) | The capabilities for the Cosmos DB account | `list(string)` | <pre>[<br>  "EnableMongo",<br>  "MongoDBv3.4"<br>]</pre> | no |
| <a name="input_cosmosdb_consistency_level"></a> [cosmosdb\_consistency\_level](#input\_cosmosdb\_consistency\_level) | The consistency level of the Cosmos DB account | `string` | `"BoundedStaleness"` | no |
| <a name="input_cosmosdb_geo_locations"></a> [cosmosdb\_geo\_locations](#input\_cosmosdb\_geo\_locations) | The geo-locations for the Cosmos DB account | <pre>list(object({<br>    location          = string<br>    failover_priority = number<br>  }))</pre> | <pre>[<br>  {<br>    "failover_priority": 0,<br>    "location": "uksouth"<br>  }<br>]</pre> | no |
| <a name="input_cosmosdb_is_virtual_network_filter_enabled"></a> [cosmosdb\_is\_virtual\_network\_filter\_enabled](#input\_cosmosdb\_is\_virtual\_network\_filter\_enabled) | Whether to enable virtual network filtering for the Cosmos DB account | `bool` | `true` | no |
| <a name="input_cosmosdb_kind"></a> [cosmosdb\_kind](#input\_cosmosdb\_kind) | The kind of Cosmos DB to create | `string` | `"MongoDB"` | no |
| <a name="input_cosmosdb_max_interval_in_seconds"></a> [cosmosdb\_max\_interval\_in\_seconds](#input\_cosmosdb\_max\_interval\_in\_seconds) | The maximum staleness interval in seconds for the Cosmos DB account | `number` | `10` | no |
| <a name="input_cosmosdb_max_staleness_prefix"></a> [cosmosdb\_max\_staleness\_prefix](#input\_cosmosdb\_max\_staleness\_prefix) | The maximum staleness prefix for the Cosmos DB account | `number` | `200` | no |
| <a name="input_cosmosdb_name"></a> [cosmosdb\_name](#input\_cosmosdb\_name) | The name of the Cosmos DB account | `string` | `"openaicosmosdb"` | no |
| <a name="input_cosmosdb_offer_type"></a> [cosmosdb\_offer\_type](#input\_cosmosdb\_offer\_type) | The offer type to use for the Cosmos DB account | `string` | `"Standard"` | no |
| <a name="input_cosmosdb_public_network_access_enabled"></a> [cosmosdb\_public\_network\_access\_enabled](#input\_cosmosdb\_public\_network\_access\_enabled) | Whether to enable public network access for the Cosmos DB account | `bool` | `true` | no |
| <a name="input_cosmosdb_virtual_network_subnets"></a> [cosmosdb\_virtual\_network\_subnets](#input\_cosmosdb\_virtual\_network\_subnets) | The virtual network subnets to associate with the Cosmos DB account (Service Endpoint). If networking is created as part of the module, this will be automatically populated. | `list(string)` | `null` | no |
| <a name="input_dns_resource_group_name"></a> [dns\_resource\_group\_name](#input\_dns\_resource\_group\_name) | The Resource Group that contains the custom DNS Zone to use for the App Service | `string` | `"dns-rg"` | no |
| <a name="input_kv_fw_allowed_ips"></a> [kv\_fw\_allowed\_ips](#input\_kv\_fw\_allowed\_ips) | value of key vault firewall allowed ip rules. | `list(string)` | `[]` | no |
| <a name="input_kv_fw_bypass"></a> [kv\_fw\_bypass](#input\_kv\_fw\_bypass) | List of key vault firewall rules to bypass. | `string` | `"AzureServices"` | no |
| <a name="input_kv_fw_default_action"></a> [kv\_fw\_default\_action](#input\_kv\_fw\_default\_action) | Default action for key vault firewall rules. | `string` | `"Deny"` | no |
| <a name="input_kv_fw_network_subnet_ids"></a> [kv\_fw\_network\_subnet\_ids](#input\_kv\_fw\_network\_subnet\_ids) | The virtual network subnets to associate with the Cosmos DB account (Service Endpoint). If networking is created as part of the module, this will be automatically populated. | `list(string)` | `null` | no |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | Name of the Key Vault to create (solution secrets). | `string` | `"openaikv9000"` | no |
| <a name="input_kv_sku"></a> [kv\_sku](#input\_kv\_sku) | SKU of the Key Vault to create. | `string` | `"standard"` | no |
| <a name="input_libre_app_allow_email_login"></a> [libre\_app\_allow\_email\_login](#input\_libre\_app\_allow\_email\_login) | Allow Email Login | `bool` | `true` | no |
| <a name="input_libre_app_allow_registration"></a> [libre\_app\_allow\_registration](#input\_libre\_app\_allow\_registration) | Allow Registration | `bool` | `true` | no |
| <a name="input_libre_app_allow_social_login"></a> [libre\_app\_allow\_social\_login](#input\_libre\_app\_allow\_social\_login) | Allow Social Login | `bool` | `false` | no |
| <a name="input_libre_app_allow_social_registration"></a> [libre\_app\_allow\_social\_registration](#input\_libre\_app\_allow\_social\_registration) | Allow Social Registration | `bool` | `false` | no |
| <a name="input_libre_app_allowed_ip_addresses"></a> [libre\_app\_allowed\_ip\_addresses](#input\_libre\_app\_allowed\_ip\_addresses) | Allowed IP Addresses. The CIDR notation of the IP or IP Range to match to allow. For example: 10.0.0.0/24 or 192.168.10.1/32 | <pre>list(object({<br>    ip_address = string<br>    priority   = number<br>    name       = string<br>    action     = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "Allow",<br>    "ip_address": "0.0.0.0/0",<br>    "name": "ip-access-rule1",<br>    "priority": 300<br>  }<br>]</pre> | no |
| <a name="input_libre_app_allowed_subnets"></a> [libre\_app\_allowed\_subnets](#input\_libre\_app\_allowed\_subnets) | Allowed Subnets (By default the subnet the app service is deployed in is allowed access already as priority 100). Add any additionals here | <pre>list(object({<br>    virtual_network_subnet_id = string<br>    priority                  = number<br>    name                      = string<br>    action                    = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "Allow",<br>    "name": "subnet-access-rule1",<br>    "priority": 200,<br>    "virtual_network_subnet_id": "subnet_id1"<br>  }<br>]</pre> | no |
| <a name="input_libre_app_az_oai_api_key"></a> [libre\_app\_az\_oai\_api\_key](#input\_libre\_app\_az\_oai\_api\_key) | Azure OpenAI API Key | `string` | `null` | no |
| <a name="input_libre_app_az_oai_api_version"></a> [libre\_app\_az\_oai\_api\_version](#input\_libre\_app\_az\_oai\_api\_version) | Azure OpenAI API Version | `string` | `"2023-07-01-preview"` | no |
| <a name="input_libre_app_az_oai_dall3_api_version"></a> [libre\_app\_az\_oai\_dall3\_api\_version](#input\_libre\_app\_az\_oai\_dall3\_api\_version) | Azure OpenAI DALL-E API Version | `string` | `"2023-12-01-preview"` | no |
| <a name="input_libre_app_az_oai_dall3_deployment_name"></a> [libre\_app\_az\_oai\_dall3\_deployment\_name](#input\_libre\_app\_az\_oai\_dall3\_deployment\_name) | Azure OpenAI DALL-E Deployment Name | `string` | `"dall-e-3"` | no |
| <a name="input_libre_app_az_oai_instance_name"></a> [libre\_app\_az\_oai\_instance\_name](#input\_libre\_app\_az\_oai\_instance\_name) | Azure OpenAI Instance Name | `string` | `null` | no |
| <a name="input_libre_app_az_oai_models"></a> [libre\_app\_az\_oai\_models](#input\_libre\_app\_az\_oai\_models) | Azure OpenAI Models. E.g. 'gpt-4-1106-preview,gpt-4,gpt-3.5-turbo,gpt-3.5-turbo-1106,gpt-4-vision-preview' | `string` | `"gpt-4-1106-preview"` | no |
| <a name="input_libre_app_az_oai_use_model_as_deployment_name"></a> [libre\_app\_az\_oai\_use\_model\_as\_deployment\_name](#input\_libre\_app\_az\_oai\_use\_model\_as\_deployment\_name) | Azure OpenAI Use Model as Deployment Name | `bool` | `true` | no |
| <a name="input_libre_app_custom_domain_create"></a> [libre\_app\_custom\_domain\_create](#input\_libre\_app\_custom\_domain\_create) | Create a custom domain and managed certificate for the App Service. | `bool` | `false` | no |
| <a name="input_libre_app_custom_footer"></a> [libre\_app\_custom\_footer](#input\_libre\_app\_custom\_footer) | Add a custom footer for the App. | `string` | `"Privately hosted chat app powered by Azure OpenAI and LibreChat."` | no |
| <a name="input_libre_app_debug_console"></a> [libre\_app\_debug\_console](#input\_libre\_app\_debug\_console) | Enable verbose server output in the console, though it's not recommended due to high verbosity. | `bool` | `false` | no |
| <a name="input_libre_app_debug_logging"></a> [libre\_app\_debug\_logging](#input\_libre\_app\_debug\_logging) | LibreChat has central logging built into its backend (api). Log files are saved in /api/logs. Error logs are saved by default. Debug logs are enabled by default but can be turned off if not desired. | `bool` | `false` | no |
| <a name="input_libre_app_debug_plugins"></a> [libre\_app\_debug\_plugins](#input\_libre\_app\_debug\_plugins) | Enable debug mode for Libre App plugins. | `bool` | `false` | no |
| <a name="input_libre_app_docker_image"></a> [libre\_app\_docker\_image](#input\_libre\_app\_docker\_image) | The Docker Image to use for the App Service. | `string` | `"ghcr.io/danny-avila/librechat-dev-api:latest"` | no |
| <a name="input_libre_app_domain_client"></a> [libre\_app\_domain\_client](#input\_libre\_app\_domain\_client) | To use locally, set DOMAIN\_CLIENT and DOMAIN\_SERVER to http://localhost:3080 (3080 being the port previously configured).When deploying to a custom domain, set DOMAIN\_CLIENT and DOMAIN\_SERVER to your deployed URL, e.g. https://mydomain.example.com | `string` | `"http://localhost:3080"` | no |
| <a name="input_libre_app_domain_server"></a> [libre\_app\_domain\_server](#input\_libre\_app\_domain\_server) | To use locally, set DOMAIN\_CLIENT and DOMAIN\_SERVER to http://localhost:3080 (3080 being the port previously configured).When deploying to a custom domain, set DOMAIN\_CLIENT and DOMAIN\_SERVER to your deployed URL, e.g. https://mydomain.example.com | `string` | `"http://localhost:3080"` | no |
| <a name="input_libre_app_enable_meilisearch"></a> [libre\_app\_enable\_meilisearch](#input\_libre\_app\_enable\_meilisearch) | Enable Meilisearch | `bool` | `false` | no |
| <a name="input_libre_app_endpoints"></a> [libre\_app\_endpoints](#input\_libre\_app\_endpoints) | endpoints and models selection. E.g. 'openAI,azureOpenAI,bingAI,chatGPTBrowser,google,gptPlugins,anthropic' | `string` | `"azureOpenAI"` | no |
| <a name="input_libre_app_host"></a> [libre\_app\_host](#input\_libre\_app\_host) | he server will listen to localhost:3080 by default. You can change the target IP as you want. If you want to make this server available externally, for example to share the server with others or expose this from a Docker container, set host to 0.0.0.0 or your external IP interface. | `string` | `"0.0.0.0"` | no |
| <a name="input_libre_app_jwt_refresh_secret"></a> [libre\_app\_jwt\_refresh\_secret](#input\_libre\_app\_jwt\_refresh\_secret) | JWT Refresh Secret | `string` | `null` | no |
| <a name="input_libre_app_jwt_secret"></a> [libre\_app\_jwt\_secret](#input\_libre\_app\_jwt\_secret) | JWT Secret | `string` | `null` | no |
| <a name="input_libre_app_mongo_uri"></a> [libre\_app\_mongo\_uri](#input\_libre\_app\_mongo\_uri) | The MongoDB Connection String to connect to. | `string` | `null` | no |
| <a name="input_libre_app_name"></a> [libre\_app\_name](#input\_libre\_app\_name) | Name of the LibreChat App Service. | `string` | `"librechatapp9000"` | no |
| <a name="input_libre_app_plugins_creds_iv"></a> [libre\_app\_plugins\_creds\_iv](#input\_libre\_app\_plugins\_creds\_iv) | Libre App Plugins Creds IV | `string` | `null` | no |
| <a name="input_libre_app_plugins_creds_key"></a> [libre\_app\_plugins\_creds\_key](#input\_libre\_app\_plugins\_creds\_key) | Libre App Plugins Creds Key | `string` | `null` | no |
| <a name="input_libre_app_port"></a> [libre\_app\_port](#input\_libre\_app\_port) | The host port to listen on. | `number` | `3080` | no |
| <a name="input_libre_app_public_network_access_enabled"></a> [libre\_app\_public\_network\_access\_enabled](#input\_libre\_app\_public\_network\_access\_enabled) | Whether or not public network access is enabled. Defaults to `false`. | `bool` | `true` | no |
| <a name="input_libre_app_title"></a> [libre\_app\_title](#input\_libre\_app\_title) | Add a custom title for the App. | `string` | `"PrivateGPT"` | no |
| <a name="input_libre_app_violations"></a> [libre\_app\_violations](#input\_libre\_app\_violations) | Configuration for violations | <pre>object({<br>    enabled                      = bool<br>    ban_duration                 = number<br>    ban_interval                 = number<br>    login_violation_score        = number<br>    registration_violation_score = number<br>    concurrent_violation_score   = number<br>    message_violation_score      = number<br>    non_browser_violation_score  = number<br>    login_max                    = number<br>    login_window                 = number<br>    register_max                 = number<br>    register_window              = number<br>    limit_concurrent_messages    = bool<br>    concurrent_message_max       = number<br>    limit_message_ip             = bool<br>    message_ip_max               = number<br>    message_ip_window            = number<br>    limit_message_user           = bool<br>    message_user_max             = number<br>    message_user_window          = number<br>  })</pre> | <pre>{<br>  "ban_duration": 7200000,<br>  "ban_interval": 20,<br>  "concurrent_message_max": 2,<br>  "concurrent_violation_score": 1,<br>  "enabled": true,<br>  "limit_concurrent_messages": true,<br>  "limit_message_ip": true,<br>  "limit_message_user": false,<br>  "login_max": 7,<br>  "login_violation_score": 1,<br>  "login_window": 5,<br>  "message_ip_max": 40,<br>  "message_ip_window": 1,<br>  "message_user_max": 40,<br>  "message_user_window": 1,<br>  "message_violation_score": 1,<br>  "non_browser_violation_score": 20,<br>  "register_max": 5,<br>  "register_window": 60,<br>  "registration_violation_score": 1<br>}</pre> | no |
| <a name="input_libre_app_virtual_network_subnet_id"></a> [libre\_app\_virtual\_network\_subnet\_id](#input\_libre\_app\_virtual\_network\_subnet\_id) | The ID of the subnet, used to allow access to the App Service (priority 100), e.g. cosmosdb, meilisearch etc. If networking is created as part of the module, this will be automatically populated if value is 'null'. | `string` | `null` | no |
| <a name="input_librechat_app_custom_dns_zone_name"></a> [librechat\_app\_custom\_dns\_zone\_name](#input\_librechat\_app\_custom\_dns\_zone\_name) | The DNS Zone to use for the App Service. | `string` | `"domain.com"` | no |
| <a name="input_librechat_app_custom_domain_name"></a> [librechat\_app\_custom\_domain\_name](#input\_librechat\_app\_custom\_domain\_name) | The custom domain to use for the App Service. | `string` | `"privategpt"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be hosted. | `string` | `"uksouth"` | no |
| <a name="input_oai_account_name"></a> [oai\_account\_name](#input\_oai\_account\_name) | The name of the OpenAI service. | `string` | `"az-openai-account"` | no |
| <a name="input_oai_custom_subdomain_name"></a> [oai\_custom\_subdomain\_name](#input\_oai\_custom\_subdomain\_name) | The subdomain name used for token-based authentication. Changing this forces a new resource to be created. (normally the same as the account name) | `string` | `"demo-account"` | no |
| <a name="input_oai_customer_managed_key"></a> [oai\_customer\_managed\_key](#input\_oai\_customer\_managed\_key) | type = object({<br>  key\_vault\_key\_id   = (Required) The ID of the Key Vault Key which should be used to Encrypt the data in this OpenAI Account.<br>  identity\_client\_id = (Optional) The Client ID of the User Assigned Identity that has access to the key. This property only needs to be specified when there're multiple identities attached to the OpenAI Account.<br>}) | <pre>object({<br>    key_vault_key_id   = string<br>    identity_client_id = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_oai_dynamic_throttling_enabled"></a> [oai\_dynamic\_throttling\_enabled](#input\_oai\_dynamic\_throttling\_enabled) | Whether or not dynamic throttling is enabled. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_oai_fqdns"></a> [oai\_fqdns](#input\_oai\_fqdns) | A list of FQDNs to be used for token-based authentication. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_oai_identity"></a> [oai\_identity](#input\_oai\_identity) | type = object({<br>  type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.<br>  identity\_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.<br>}) | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | <pre>{<br>  "type": "SystemAssigned"<br>}</pre> | no |
| <a name="input_oai_local_auth_enabled"></a> [oai\_local\_auth\_enabled](#input\_oai\_local\_auth\_enabled) | Whether local authentication methods is enabled for the Cognitive Account. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_oai_model_deployment"></a> [oai\_model\_deployment](#input\_oai\_model\_deployment) | type = list(object({<br>  deployment\_id   = (Required) The name of the Cognitive Services Account `Model Deployment`. Changing this forces a new resource to be created.<br>  model\_name = {<br>    model\_format  = (Required) The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is OpenAI.<br>    model\_name    = (Required) The name of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created.<br>    model\_version = (Required) The version of Cognitive Services Account Deployment model.<br>  }<br>  scale = {<br>    scale\_type     = (Required) Deployment scale type. Possible value is Standard. Changing this forces a new resource to be created.<br>    scale\_tier     = (Optional) Possible values are Free, Basic, Standard, Premium, Enterprise. Changing this forces a new resource to be created.<br>    scale\_size     = (Optional) The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. Changing this forces a new resource to be created.<br>    scale\_family   = (Optional) If the service has different generations of hardware, for the same SKU, then that can be captured here. Changing this forces a new resource to be created.<br>    scale\_capacity = (Optional) Tokens-per-Minute (TPM). If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. Default value is 1. Changing this forces a new resource to be created.<br>  }<br>  rai\_policy\_name = (Optional) The name of RAI policy. Changing this forces a new resource to be created.<br>})) | <pre>list(object({<br>    deployment_id   = string<br>    model_name      = string<br>    model_format    = string<br>    model_version   = string<br>    scale_type      = string<br>    scale_tier      = optional(string)<br>    scale_size      = optional(number)<br>    scale_family    = optional(string)<br>    scale_capacity  = optional(number)<br>    rai_policy_name = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_oai_network_acls"></a> [oai\_network\_acls](#input\_oai\_network\_acls) | type = set(object({<br>  default\_action = (Required) The Default Action to use when no rules match from ip\_rules / virtual\_network\_rules. Possible values are `Allow` and `Deny`.<br>  ip\_rules       = (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Cognitive Account.<br>  virtual\_network\_rules = optional(set(object({<br>    subnet\_id                            = (Required) The ID of a Subnet which should be able to access the OpenAI Account.<br>    ignore\_missing\_vnet\_service\_endpoint = (Optional) Whether ignore missing vnet service endpoint or not. Default to `false`.<br>  })))<br>})) | <pre>set(object({<br>    default_action = string<br>    ip_rules       = optional(set(string))<br>    virtual_network_rules = optional(set(object({<br>      subnet_id                            = string<br>      ignore_missing_vnet_service_endpoint = optional(bool, false)<br>    })))<br>  }))</pre> | `null` | no |
| <a name="input_oai_outbound_network_access_restricted"></a> [oai\_outbound\_network\_access\_restricted](#input\_oai\_outbound\_network\_access\_restricted) | Whether or not outbound network access is restricted. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_oai_public_network_access_enabled"></a> [oai\_public\_network\_access\_enabled](#input\_oai\_public\_network\_access\_enabled) | Whether or not public network access is enabled. Defaults to `false`. | `bool` | `true` | no |
| <a name="input_oai_sku_name"></a> [oai\_sku\_name](#input\_oai\_sku\_name) | SKU name of the OpenAI service. | `string` | `"S0"` | no |
| <a name="input_oai_storage"></a> [oai\_storage](#input\_oai\_storage) | type = list(object({<br>  storage\_account\_id = (Required) Full resource id of a Microsoft.Storage resource.<br>  identity\_client\_id = (Optional) The client ID of the managed identity associated with the storage resource.<br>})) | <pre>list(object({<br>    storage_account_id = string<br>    identity_client_id = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to create the OpenAI service / or where an existing service is hosted. | `string` | n/a | yes |
| <a name="input_subnet_config"></a> [subnet\_config](#input\_subnet\_config) | A list of subnet configuration objects to create subnets in the virtual network. | <pre>object({<br>    subnet_name                                   = string<br>    subnet_address_space                          = list(string)<br>    service_endpoints                             = list(string)<br>    private_endpoint_network_policies_enabled     = bool<br>    private_link_service_network_policies_enabled = bool<br>    subnets_delegation_settings = map(list(object({<br>      name    = string<br>      actions = list(string)<br>    })))<br>  })</pre> | <pre>{<br>  "private_endpoint_network_policies_enabled": false,<br>  "private_link_service_network_policies_enabled": false,<br>  "service_endpoints": [<br>    "Microsoft.AzureCosmosDB",<br>    "Microsoft.Web"<br>  ],<br>  "subnet_address_space": [<br>    "10.4.0.0/24"<br>  ],<br>  "subnet_name": "app-cosmos-sub",<br>  "subnets_delegation_settings": {<br>    "app-service-plan": [<br>      {<br>        "actions": [<br>          "Microsoft.Network/virtualNetworks/subnets/action"<br>        ],<br>        "name": "Microsoft.Web/serverFarms"<br>      }<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key value pairs that is used to tag resources created. | `map(string)` | `{}` | no |
| <a name="input_use_cosmosdb_free_tier"></a> [use\_cosmosdb\_free\_tier](#input\_use\_cosmosdb\_free\_tier) | Whether to enable the free tier for the Cosmos DB account. This needs to be false if another instance already uses free tier. | `bool` | `true` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network where resources are attached. | `string` | `"openai-vnet-9000"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | value of the address space for the virtual network. | `list(string)` | <pre>[<br>  "10.4.0.0/24"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_default_hostname"></a> [app\_service\_default\_hostname](#output\_app\_service\_default\_hostname) | The default hostname of the App Service |
| <a name="output_app_service_id"></a> [app\_service\_id](#output\_app\_service\_id) | The ID of the App Service |
| <a name="output_app_service_name"></a> [app\_service\_name](#output\_app\_service\_name) | The name of the App Service |
| <a name="output_app_service_outbound_ip_addresses"></a> [app\_service\_outbound\_ip\_addresses](#output\_app\_service\_outbound\_ip\_addresses) | The outbound IP addresses of the App Service |
| <a name="output_app_service_plan_id"></a> [app\_service\_plan\_id](#output\_app\_service\_plan\_id) | The ID of the App Service Plan |
| <a name="output_app_service_plan_name"></a> [app\_service\_plan\_name](#output\_app\_service\_plan\_name) | The name of the App Service Plan |
| <a name="output_cognitive_deployment_ids"></a> [cognitive\_deployment\_ids](#output\_cognitive\_deployment\_ids) | The IDs of the OpenAI Cognitive Account Model Deployments |
| <a name="output_cognitive_deployment_names"></a> [cognitive\_deployment\_names](#output\_cognitive\_deployment\_names) | The names of the OpenAI Cognitive Account Model Deployments |
| <a name="output_cosmosdb_account_connection_strings"></a> [cosmosdb\_account\_connection\_strings](#output\_cosmosdb\_account\_connection\_strings) | The primary connection string for the Cosmos DB account |
| <a name="output_cosmosdb_account_endpoint"></a> [cosmosdb\_account\_endpoint](#output\_cosmosdb\_account\_endpoint) | The endpoint used to connect to the Cosmos DB account |
| <a name="output_cosmosdb_account_id"></a> [cosmosdb\_account\_id](#output\_cosmosdb\_account\_id) | The ID of the Cosmos DB account |
| <a name="output_cosmosdb_account_name"></a> [cosmosdb\_account\_name](#output\_cosmosdb\_account\_name) | The name of the Cosmos DB account |
| <a name="output_cosmosdb_account_primary_key"></a> [cosmosdb\_account\_primary\_key](#output\_cosmosdb\_account\_primary\_key) | The primary master key for the Cosmos DB account |
| <a name="output_cosmosdb_account_secondary_key"></a> [cosmosdb\_account\_secondary\_key](#output\_cosmosdb\_account\_secondary\_key) | The secondary master key for the Cosmos DB account |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the Key Vault |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | The name of the Key Vault |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | The URI of the Key Vault |
| <a name="output_openai_endpoint"></a> [openai\_endpoint](#output\_openai\_endpoint) | The endpoint used to connect to the Cognitive Service Account. |
| <a name="output_openai_primary_key"></a> [openai\_primary\_key](#output\_openai\_primary\_key) | The primary access key for the Cognitive Service Account. |
| <a name="output_openai_secondary_key"></a> [openai\_secondary\_key](#output\_openai\_secondary\_key) | The secondary access key for the Cognitive Service Account. |
| <a name="output_openai_subdomain"></a> [openai\_subdomain](#output\_openai\_subdomain) | The subdomain used to connect to the Cognitive Service Account. |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The ID of the subnet |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | The name of the subnet |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the virtual network |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network |
<!-- END_TF_DOCS -->