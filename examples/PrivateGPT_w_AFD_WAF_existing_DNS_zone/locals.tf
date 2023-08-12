locals {
  ca_secrets = [
    {
      name  = "openai-api-key"
      value = "${module.private-chatgpt-openai.openai_primary_key}"
    },
    {
      name  = "openai-api-host"
      value = "${module.private-chatgpt-openai.openai_endpoint}"
    }
  ]
}