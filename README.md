[![Automated-Dependency-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/actions/workflows/dependency-tests.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/actions/workflows/dependency-tests.yml) [![Dependabot](https://badgen.net/badge/Dependabot/enabled/green?icon=dependabot)](https://dependabot.com/)

# Module: Azure OpenAI Private ChatGPT

**NOTE:** Your Azure subscription will need to be whitelisted for **Azure Open AI**. At the release time of this module (August 2023) you will need to request access via this **[form](https://aka.ms/oai/access)** and a further form for **[GPT 4](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR7en2Ais5pxKtso_Pz4b1_xURjE4QlhVUERGQ1NXOTlNT0w1NldTWjJCMSQlQCN0PWcu)**. Once you have access deploy either **GPT-35-Turbo**, **GPT-35-Turbo-16k** or if you have access to **GPT-4-32k**, go forward with that model.  

## Introduction

Under **OpenAI's** terms when using the public version of **ChatGPT**, any questions you pose—referred to as **"prompts"**—may contribute to the further training of OpenAI's Large Language Model (LLM). Given this, it's crucial to ask: Are you comfortable with this precious data flow leaving your organization? If you're a decision-maker or hold responsibility over your organization's security measures, what steps are you taking to ensure proprietary information remains confidential?  

An effective solution lies in utilising a hosted version of the popular LLM on **Azure OpenAI**. While there are numerous advantages to Azure OpenAI, I'd like to spotlight two:

- **Data Privacy**: By hosting OpenAI's models on Azure, your prompts will never serve as a source for training the LLM. It's simply a self-contained version running on Azure tailored for your use.

- **Enhanced Security**: Azure OpenAI offers robust security measures, from the capability to secure specific endpoints to intricate role-based access controls.
For a deeper dive, refer to this [Microsoft Learn article](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview).  

While Azure OpenAI does come with a cost, it's highly affordable—often, a conversation costs under 10 cents. You can review Azure [OpenAI's pricing](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/) details here.

This terraform module helps establishing a secure **ChatGPT-like** interface. This uses Azure OpenAI, combined with an array of Azure's other services, such as **Azure Container App**, **Azure Front Door / CDN**, **Web Application Firewall**, **Key Vault** and **Azure DNS**, ensuring a confidential and dedicated ChatGPT experience for you.

## Diagram

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/master/assets/main.png)

## Description

This flexible terraform module is an **OpneAI accelerator** that can be used to deploy a privately hosted instance of a **ChatBot** similar to **ChatGPT** hosted on Azure using **Azure Container Apps**, **Azure OpenI** and optionally fronted by **Azure CDN/Front Door** with a **WAF / Firewall** and custom allowed IP list.  

## This module can be used to create the following:

### Create OpenAI Service

1. Create an Azure Key Vault to store the OpenAI account details.
2. Create an OpenAI service account.  
    Other options include:
    - Specify an already existing OpenAI service account to use.

3. Create OpenAI language model deployments on the OpenAI service. (e.g. GPT-3, GPT-4, etc.)
4. Store the OpenAI account and model details in the key vault for consumption.

### Create a container app ChatBot UI linked with OpenAI service hosted in Azure

1. Create a container app log analytics workspace (to link with container app).
2. Create a container app environment.
3. Create a container app instance hosting chatbot-ui from image/container.
4. Link chatbot-ui with corresponding OpenAI account and language model deployment.
5. Grant the container app access to the key vault to retrieve secrets (optional).

### Front solution with an Azure front door (optional)

1. Deploy Azure Front Door to front solution with CDN + WAF.
2. Setup a custom domain in Azure Front Door with AFD managed certificate.
    Other options include:
    - This example specifies an already existing DNZ zone to use. (e.g. `existingzone.com` - see `common.auto.tfvars`)
    - **Note:** Remember to add the zone to your DNS registrar as the module creates a TXT auth. (Certificates fully managed by AFD)

3. Create a CNAME and TXT record in the custom DNS zone. (e.g. `privategpt.existingzone.com`)
4. Setup and apply an ADF WAF policy with `IPAllow list` for allowed IPs to connect using a custom rule.

## ChatBot Demo

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/master/assets/chatbotui1.png)

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/master/assets/chatbotui2.png)

## Examples

See **[Private ChatGPT with Azure Front Door + Firewall on existing DNS zone](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/tree/master/examples/PrivateGPT_w_AFD_WAF_existing_DNS_zone):**  
For an example of how to create a Privately hosted instance of ChatBot/ChatGPT on Azure OpenAI with AFD + WAF using an existing DNS zone for the custom domain configuration.  

See **[Private ChatGPT with Azure Front Door + Firewall on new DNS zone](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/tree/master/examples/PrivateGPT_w_AFD_WAF_new_DNS_zone):**  
For an example of how to create a Privately hosted instance of ChatBot/ChatGPT on Azure OpenAI with AFD + WAF using a new DNS zone for the custom domain configuration.  

See **[Private ChatGPT instance only](https://github.com/Pwd9000-ML/terraform-azurerm-openai-private-chatgpt/tree/master/examples/PrivateGPT_without_AFD_WAF):**  
For an example of how to create a Privately hosted instance of ChatBot/ChatGPT on Azure OpenAI only. (No AFD + WAF + DNS zone)  

This module is published on the **[Public Terraform Registry - openai-private-chatgpt](https://registry.terraform.io/modules/Pwd9000-ML/openai-private-chatgpt/azurerm/latest)**  

Enjoy!

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->