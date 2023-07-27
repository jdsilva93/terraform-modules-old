resource "azurerm_mysql_flexible_server" "example" {
    name                   = var.sqlname
    resource_group_name    = var.resource_group
    location               = var.location
    administrator_login    = var.sqllogin
    administrator_password = var.sqlpass
    backup_retention_days  = 7
    delegated_subnet_id    = var.subnet_id
    sku_name               = "GP_Standard_D2ds_v4"
    zone                   = var.zone
}

resource "azurerm_private_dns_zone" "example" {
    name                = "${var.sqlname}.database.azure.com"
    resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
    name                  = "${var.sqlname}.com"
    private_dns_zone_name = azurerm_private_dns_zone.example.name
    virtual_network_id    = azurerm_virtual_network.example.id
    resource_group_name   = azurerm_resource_group.example.name
}