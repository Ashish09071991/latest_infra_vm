data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvlt" {
  for_each                    = var.keyvaults
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  rbac_authorization_enabled  = try(each.value.rbac_authorization_enabled, false)
  enabled_for_disk_encryption = try(each.value.enabled_for_disk_encryption, true)
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = try(each.value.soft_delete_retention_days, 7)
  purge_protection_enabled    = try(each.value.purge_protection_enabled, false)
  sku_name                    = try(each.value.sku_name, "standard")

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }
}

resource "random_password" "vm_password" {
  for_each         = var.keyvaults
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "azurerm_key_vault_secret" "vm_secret" {
  for_each     = var.keyvaults
  name         = try(each.value.secret_name, "vm-admin-password")
  value        = random_password.vm_password[each.key].result
  key_vault_id = azurerm_key_vault.keyvlt[each.key].id

  depends_on = [azurerm_key_vault.keyvlt]
}