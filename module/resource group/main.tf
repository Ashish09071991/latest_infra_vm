resource "azurerm_resource_group" "rgname" {
  for_each = var.rgnames
  name     = each.value.name
  location = each.value.location
}