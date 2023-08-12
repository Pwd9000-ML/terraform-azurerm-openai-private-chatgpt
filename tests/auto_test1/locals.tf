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

  kv_config = {
    name = "gptkv${random_integer.number.result}"
    sku  = "standard"
  }

  custom_domain_config = {
    zone_name = "gpt${random_integer.number.result}.com"
    host_name = "PrivateGPT"
    ttl       = 600
    tls = [{
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }]
  }
}