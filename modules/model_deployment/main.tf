resource "azurerm_cognitive_deployment" "model" {
  for_each = var.model_deployment

  cognitive_account_id = data.azurerm_cognitive_account.openai.id
  name                 = each.value.name
  rai_policy_name      = each.value.rai_policy_name

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }
  scale {
    type     = each.value.scale_type
    tier     = each.value.scale_tier
    size     = each.value.scale_size
    family   = each.value.scale_family
    capacity = each.value.scale_capacity
  }
}