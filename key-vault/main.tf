resource "azurerm_key_vault" "kv" {
    name                            = var.kvname
    resource_group_name             = var.rgname
    location                        = var.location
    enabled_for_disk_encryption     = true
    tenant_id                       = var.tenant_id
    soft_delete_retention_days      = 7
    purge_protection_enabled        = false 
    enabled_for_deployment          = true
    enabled_for_template_deployment = true
    sku                             = "Standard"
}