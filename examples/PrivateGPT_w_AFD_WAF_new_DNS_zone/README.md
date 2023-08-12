# Private ChatGPT with Azure Front Door + Firewall on new DNS zone

This example will create a Privately hosted instance of ChatBot/ChatGPT on Azure OpenAI with AFD + WAF using a new DNS zone for the custom domain configuration. This example will create the following:

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

1. Deploy Azure Front Door to front solution with CDN + WAF.
2. Setup a custom domain in Azure Front Door with AFD managed certificate.
    Other options include:
    - This example specifies a new DNZ zone to create. (e.g. `newzone2158.com` - see `common.auto.tfvars`)
    - **Note:** Remember to add the zone to your DNS registrar as the module creates a TXT auth. (Certificates fully managed by AFD)

3. Create a CNAME and TXT record in the custom DNS zone. (e.g. `privategpt.newzone2158.com`)
4. Setup and apply an ADF WAF policy with `IPAllow list` for allowed IPs to connect using a custom rule.

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
