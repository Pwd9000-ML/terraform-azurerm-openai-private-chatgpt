locals {
  cdn_gpt_origin = merge(
    var.cdn_gpt_origin,
    {
      host_name          = module.privategpt_chatbot_container_apps.latest_revision_fqdn
      origin_host_header = module.privategpt_chatbot_container_apps.latest_revision_fqdn
    }
  )
}