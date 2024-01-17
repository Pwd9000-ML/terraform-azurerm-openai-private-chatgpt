resource "resource_group" "az_openai" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}