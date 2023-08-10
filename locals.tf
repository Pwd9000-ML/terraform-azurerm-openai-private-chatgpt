locals {
  cdn_gpt_origin = merge(
    var.cdn_gpt_origin,
    {
      host_name          = azurerm_container_app.gpt.latest_revision_fqdn
      origin_host_header = azurerm_container_app.gpt.latest_revision_fqdn
    }
  )
}