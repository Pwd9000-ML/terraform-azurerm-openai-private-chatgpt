# Private ChatGPT instance only (No AFD WAF / custom DNS integration)

This example will create a Privately hosted instance of ChatGPT on Azure OpenAI only. This example will create the following:

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

<!-- END_TF_DOCS -->
