resource "azurerm_subnet" "subnet" {
  virtual_network_name = var.vnetname
  resource_group_name  = var.resource_group
  name                 = var.subnetname
  address_prefixes     = var.subnetcidr
}
