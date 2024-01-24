# Public Deployment with Custom Domain and IP Whitelisting

This example contains a Terraform script for provisioning a set of Azure resources for a chat application powered by Azure OpenAI models. The script is designed to be modular and configurable, allowing you to customise the resources and settings to fit your specific needs.  

In this example the Chat App is deployed with a public endpoint, a custom domain name and managed certificate. The access to the app can be restricted to a set of whitelisted IP addresses or subnets using these variables:

```hcl
libre_app_virtual_network_subnet_id     = null # Access is allowed on the built in subnet of this module. If networking is created as part of the module, this will be automatically populated if value is 'null' (priority 100)
libre_app_allowed_subnets               = null # Add any other subnet ids to allow access to the app service (optional)
libre_app_allowed_ip_addresses = [
  {
    ip_address = "0.0.0.0/0" # (Change to your IP address or CIDR range)
    priority   = 200
    name       = "ip-access-rule1"
    action     = "Allow"
  }
]
```

## Resources

The script provisions the following resources:

- **Random Integer**: This is used to generate unique names for the resources to avoid naming conflicts.
- **Resource Group**: This is the resource group that contains all the resources for the chat application.
- **Virtual Network**: This is the virtual network and subnet that contains the chat application and supporting resources.
- **Key Vault**: This is used to store secrets for the chat application, such as the OpenAI API key and other secrets used by the application.
- **OpenAI Service**: This is the core service that powers the chat application. It uses OpenAI's GPT-3 model to generate responses to user inputs.
- **CosmosDB Instance**: This is the database for the chat application. It stores user data and chat logs.
- **App Service**: This hosts the chat application. It's configured with various settings for networking, storage, and access control.

## Configuration

The script uses variables for configuration. These variables can be set in a `common.auto.tfvars` file or passed in via the command line when running `terraform apply`.  

The variables include settings for the location, tags, resource group name, virtual network name, subnet configuration, key vault settings, OpenAI service settings, CosmosDB settings, and App Service settings.  

## Usage

To use this script, you need to have Terraform installed. You can then clone this repository and run `terraform init` to initialize your Terraform workspace. Once the workspace is initialized, you can run `terraform apply` to create the resources.  

Please note that you will need to provide values for all the required variables in the `common.auto.tfvars` file and defining the variables there, or by passing them in via the command line when running `terraform apply`.  

## Contributing

Contributions are welcome. Please submit a pull request if you have any improvements or fixes. Make sure to follow the existing code style and add comments to your code explaining what it does.

## License

This script is licensed under the MIT License. See the LICENSE file for more details.

## Support

If you encounter any issues or have any questions about this script, please open an issue on GitHub. We'll do our best to respond as quickly as possible.

## Acknowledgements

This script was developed by **Marcel Lupo** as part of a project to explore the capabilities of Azure OpenAI models. We'd like to thank the OpenAI and Microsoft team for their incredible work and ongoing support of the AI community.  
