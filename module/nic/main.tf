data "azurerm_subnet" "subnet" {
  for_each             = var.nicname
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "pip" {
  for_each            = { for k, v in var.nicname : k => v if try(v.public_ip_name, null) != null }
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_security_group" "nsg" {
  for_each            = { for k, v in var.nicname : k => v if try(v.nsg_name, null) != null }
  name                = each.value.nsg_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface" "nics" {
  for_each            = var.nicname
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = try(data.azurerm_public_ip.pip[each.key].id, null)
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each                  = { for k, v in var.nicname : k => v if try(v.nsg_name, null) != null }
  network_interface_id      = azurerm_network_interface.nics[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsg[each.key].id
}