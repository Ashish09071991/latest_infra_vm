resource "azurerm_public_ip" "pips" {
  for_each            = var.pipname
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = try(each.value.allocation_method, "Static")
  sku                 = try(each.value.sku, "Standard")
}
